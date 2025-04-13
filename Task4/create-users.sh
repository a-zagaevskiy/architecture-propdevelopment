#!/bin/bash
set -e

# Конфигурация
CLUSTER_NAME="sprint7-cluster"
CA_CERT="/etc/kubernetes/pki/ca.crt"  # Путь к CA сертификату
CA_KEY="/etc/kubernetes/pki/ca.key"    # Путь к CA ключу
OUTPUT_DIR="./k8s-users"         # Директория для сохранения файлов

# Создаем директорию для выходных файлов
mkdir -p "$OUTPUT_DIR"

# Функция для создания пользователя
create_user() {
    local USERNAME=$1
    local USER_GROUPS=$2
    
    echo "Создание пользователя $USERNAME..."
    
    openssl genrsa -out "$OUTPUT_DIR/$USERNAME.key" 2048

    cat > "$OUTPUT_DIR/$USERNAME.cnf" <<EOF
[ req ]
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no
[ req_distinguished_name ]
CN = $USERNAME
O = $USER_GROUPS
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
EOF

    openssl req -new -key "$OUTPUT_DIR/$USERNAME.key" \
        -out "$OUTPUT_DIR/$USERNAME.csr" \
        -config "$OUTPUT_DIR/$USERNAME.cnf"

    # Подписываем CSR с помощью CA
    #
    # openssl x509 -req -in "$OUTPUT_DIR/$USERNAME.csr" \
    #     -CA "$CA_CERT" -CAkey "$CA_KEY" -CAcreateserial \
    #     -out "$OUTPUT_DIR/$USERNAME.crt" -days 365
    #
    # или самоподписанный для проверки работоспособности скрипта
    openssl x509 -req -in "$OUTPUT_DIR/$USERNAME.csr" \
        -key "$OUTPUT_DIR/$USERNAME.key" \
        -out "$OUTPUT_DIR/$USERNAME.crt" -days 365
    
    kubectl config set-credentials "$USERNAME" \
        --client-certificate="$OUTPUT_DIR/$USERNAME.crt" \
        --client-key="$OUTPUT_DIR/$USERNAME.key" \
        --embed-certs=true \
        --kubeconfig="$OUTPUT_DIR/$USERNAME.kubeconfig"

    kubectl config set-context "$USERNAME" \
        --cluster="$CLUSTER_NAME" \
        --user="$USERNAME" \
        --kubeconfig="$OUTPUT_DIR/$USERNAME.kubeconfig"

    kubectl config use-context "$USERNAME" \
        --kubeconfig="$OUTPUT_DIR/$USERNAME.kubeconfig"
    
    echo "Пользователь $USERNAME создан."
    echo "Для использования передайте файл $OUTPUT_DIR/$USERNAME.kubeconfig пользователю"
    echo "----------"
}

# Создаем пользователей
create_user analyst1 bi-analyst
create_user analyst2 bi-analyst
create_user monitor1 monitor
# Создаем администраторов
create_user admin1 administrator
create_user admin2 administrator
# Создаем суперпользователей
create_user ib1 ib-engineer
create_user root superuser