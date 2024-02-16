#!/bin/sh

# Variável de ambiente
GO_VERSION={{go-version}} # Versão do Go a ser instalada

# Função para verificar se o Go está instalado
check_go_installed() {
    if command -v go >/dev/null  2>&1; then
        echo "Go está instalado."
        return  0
    else
        echo "Go não está instalado."
        return  1
    fi
}

# Função para obter a versão atual do Go
get_current_go_version() {
    if check_go_installed; then
        go version | awk '{print $3}' | tr -d 'go'
    else
        echo "N/A"
    fi
}

# Função para instalar o Go
install_go() {
    echo "Instalando Go versão $GO_VERSION no Linux..."
    apt-get update
    apt-get install -y wget
    wget https://dl.google.com/go/go$GO_VERSION.linux-amd64.tar.gz
    if [ $? -ne   0 ]; then
        echo "Falha ao baixar o Go$GO_VERSION. Verifique o URL e tente novamente."
        return   1
    fi
    tar -xvf go$GO_VERSION.linux-amd64.tar.gz
    mv go /usr/local
}


# Verificar se o Go está instalado e obter a versão atual
if check_go_installed; then
    CURRENT_GO_VERSION=$(get_current_go_version)
    echo "Versão atual do Go: $CURRENT_GO_VERSION"

    # Verificar se a versão atual é diferente da versão desejada
    if [ "$CURRENT_GO_VERSION" != "$GO_VERSION" ]; then
        echo "A versão atual do Go é diferente da versão desejada. Instalando a nova versão..."
        install_go
    else
        echo "A versão atual do Go já é a versão desejada."
    fi
else
    echo "O Go não está instalado. Instalando a versão desejada..."
    install_go
fi
