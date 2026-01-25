# Organizacao

Repositório: [lucasmiachon-blip/organizacao1](https://github.com/lucasmiachon-blip/organizacao1)

## Configuração

### Autenticação no GitHub (push/pull)

Para `git push` e `git pull` com repositórios privados, use um dos métodos:

**Opção 1 – Token no URL (apenas na máquina local)**  
O `~/.gitconfig` e o `.git/config` não são commitados.

```bash
git remote set-url origin https://SEU_USUARIO:SEU_TOKEN@github.com/lucasmiachon-blip/organizacao1.git
```

**Opção 2 – Git Credential Manager**  
Instale o [Git Credential Manager](https://github.com/git-ecosystem/git-credential-manager) e use seu usuário + token quando o Git pedir.

**Opção 3 – SSH**  
Configure uma chave SSH no GitHub e use:

```bash
git remote set-url origin git@github.com:lucasmiachon-blip/organizacao1.git
```

### Primeiro push

Com a autenticação configurada:

```bash
git push -u origin main
```

Se o repositório remoto já tiver commits e usar outro nome de branch (ex.: `master`), faça o pull antes:

```bash
git pull origin main --allow-unrelated-histories
# ou, se o remoto usar master:
git pull origin master --allow-unrelated-histories
git push -u origin main
```

### Variáveis de ambiente

Crie um `.env` na raiz (já está no `.gitignore`) para chaves e tokens. Nunca commite o `.env`.
