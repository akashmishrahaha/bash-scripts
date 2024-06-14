# AUTO APACHE

# The default document root for all the linux distribution is /var/www/html

# Ubuntu and Debian distribution refer to Apache as "APACHE2" and the config file of "APACHE2" is at /etc/apache2/apache2.conf

# CentOS refer to Apache as httpd and config file is present at /etc/httpd/httpd.conf

echo "Installing Apache2"

echo "Before installing apache2, we will check if it is present or not"

if ! command -v apache2 &> /dev/null
then
    echo "apache2 is not installed"
    echo "installing apache2"
    sudo apt update
    sudo apt install -y apache2
else
    echo "apache2 is already installed"
fi

echo "Now in order to push your static website, we need a website"

read -p "What is the name of the folder: " folderName

if [ -d "$folderName" ]
then
    cd "$folderName" 
    sudo cp -r . /var/www/html/
    echo "Successfully moved"
else
    echo "Please provide a directory containing your static website"
    exit 1
fi    

echo "Setting up the VirtualHost Configuration File"

cd /etc/apache2/sites-available/

sudo cp 000-default.conf "$folderName".conf

serverName="127.0.0.1"

read -p "What email would you like to use (ex. yourname@example.com): " serverAdmin

sudo sed -i "s|^ServerAdmin.*|ServerAdmin $serverAdmin|" "$folderName".conf
sudo sed -i "s|DocumentRoot /var/www/html|DocumentRoot /var/www/$folderName/|" "$folderName".conf
sudo sed -i "s|^ServerName.*|ServerName $serverName|" "$folderName".conf
echo "Enabling the new site"

sudo a2ensite "$folderName".conf

echo "Restarting Apache"

sudo systemctl restart apache2

echo "Setup complete!"

xdg-open http://127.0.0.1

