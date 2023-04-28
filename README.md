/Este script inicia um fake AP com o nome da rede fornecido pelo usuário e captura o tráfego utilizando o Wireshark. 
//Ele também utiliza um servidor Apache para hospedar uma página HTML que funciona como um captive portal e redireciona todo o tráfego HTTP e HTTPS para um proxy que usa o SSLstrip para capturar o tráfego HTTPS. 
///Além disso, o arpspoof é utilizado para capturar as credenciais dos usuários.

\O script pede ao usuário para inserir o nome da rede e o caminho do arquivo HTML para o captive portal. Ele também permite que o usuário interrompa o ataque pressionando CTRL+C e continua a capturar o tráfego HTTPS após o usuário inserir as credenciais

 # Execução:

- sudo su
- apt-get install aircrack-ng dnsmasq iptables hostapd sslstrip tshark apache2
- chmod +x fakeap.sh
- ./fakeap.sh
