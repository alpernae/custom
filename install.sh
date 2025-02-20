#!/usr/bin/sh

# Update APT

echo "Updating APT Source List & Installing some kali tools"
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt install golang seclists ffuf sqlmap nmap python3 -y

# Project Discovery Tools

echo "Installing ProjectDiscovery Tools"
go install -v github.com/projectdiscovery/notify/cmd/notify@latest
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/uncover/cmd/uncover@latest
go install -v github.com/projectdiscovery/chaos-client/cmd/chaos@latest
go install -v github.com/projectdiscovery/mapcidr/cmd/mapcidr@latest
go install github.com/projectdiscovery/alterx/cmd/alterx@latest
go install -v github.com/projectdiscovery/urlfinder/cmd/urlfinder@latest

# Custom Tools from diffrent users

echo "Installing Custom Tools from diffrent users"
go install -v github.com/tomnomnom/anew@latest
go install -v github.com/tomnomnom/waybackurls@latest
go install -v github.com/tomnomnom/gf@latest
