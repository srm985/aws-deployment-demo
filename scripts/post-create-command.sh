sudo apt update

# Install nvm
sudo apt install curl -y
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

# Configure nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Configure Git functionality in bash
sudo apt install bash-completion -y

curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash

echo "if [ -f ~/.git-completion.bash ]; then" >> ~/.bashrc
echo "  . ~/.git-completion.bash" >> ~/.bashrc
echo "fi" >> ~/.bashrc

curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
sudo apt install git-lfs -y

# Refresh bash after adding nvm and Git changes
source ~.bashrc
source /tmp/.bashrc

# Install the latest version of NodeJS LTS
nvm install --lts

# Update NPM
npm install -g npm@latest

# Install package dependencies
npm ci --verbose --legacy-peer-deps

# Allow execution
find ./scripts/ -type f -regex '.*\.\(py\|sh\|bash\)$' -exec chmod +x {} +

echo Creating database...

sudo apt install mariadb-server -y

# We start on a different port just to avoid conflicts with other codebases
sudo service mariadb start --port 3306

# We're just waiting for the database to come online
sleep 10

sudo mariadb -u root -e "CREATE DATABASE demo;"

echo Provisioning database user...

sudo mariadb -u root -e "CREATE USER 'local'@'localhost' IDENTIFIED BY 'supersecretpw';"
sudo mariadb -u root -e "GRANT ALL PRIVILEGES ON demo.* TO 'local'@'localhost';"
sudo mariadb -u root -e "FLUSH PRIVILEGES;"
