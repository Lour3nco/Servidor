#!/bin/bash

# ==============================================================================
# Script: keep_active.sh
# Descrição: Atualiza um arquivo com o timestamp atual, faz commit e push
#            para manter o repositório do GitHub ativo.
# Uso: Agendado via crontab no servidor.
# ==============================================================================

# 1. Variáveis de Configuração
# Altere o caminho para o diretório do seu repositório
REPO_DIR="/caminho/para/seu/repositorio" 
# Nome do arquivo a ser atualizado
FILE_TO_UPDATE="server_activity.log"
# Mensagens de commit aleatórias
COMMIT_MESSAGES=(
    "Server activity log update: $(date +'%Y-%m-%d %H:%M:%S')"
    "Routine server maintenance commit"
    "Keep the server streak alive!"
    "Automated log update from Minecraft server"
)

# 2. Navega para o diretório do repositório
cd "$REPO_DIR" || { echo "Erro: Não foi possível navegar para o diretório $REPO_DIR. Verifique o caminho." >&2; exit 1; }

# 3. Gera o timestamp e o conteúdo
TIMESTAMP=$(date +'%Y-%m-%d %H:%M:%S')
LOG_ENTRY="[${TIMESTAMP}] Automated activity log entry."

# 4. Atualiza o arquivo (adiciona uma nova linha)
echo "$LOG_ENTRY" >> "$FILE_TO_UPDATE"

# 5. Adiciona o arquivo ao staging
git add "$FILE_TO_UPDATE"

# 6. Verifica se há alterações para commitar
if git diff --cached --exit-code; then
    echo "Nenhuma alteração para commitar. Encerrando."
    exit 0
fi

# 7. Seleciona uma mensagem de commit aleatória
COMMIT_MESSAGE=${COMMIT_MESSAGES[$RANDOM % ${#COMMIT_MESSAGES[@]}]}

# 8. Faz o commit
git commit -m "$COMMIT_MESSAGE"

# 9. Faz o push
# Assume que você está na branch principal (main ou master)
# Se você estiver usando um token de acesso pessoal (PAT) ou SSH,
# o git push deve funcionar sem pedir senha.
git push origin HEAD

# 10. Verifica o status do push
if [ $? -eq 0 ]; then
    echo "Sucesso: Commit e push realizados em $TIMESTAMP."
else
    echo "Erro: Falha ao fazer o push. Verifique as credenciais e permissões." >&2
    exit 1
fi

exit 0
