#!/bin/bash

set_certbot() {
    echo "Get TLS certificate..."
    echo "Installing certbot..."
    sudo apt-get update -qq &&
        sudo apt-get install certbot python3-certbot-nginx -y -qq
    echo "Issuing certificates..."
    echo "Add values to DNS Server MANUALLY!"
    sudo certbot certonly --manual --preferred-challenges \
        dns -d "*.phoiweb.com" -d "phoiweb.com"
    # TODO: Add auto-renewal script
    # 0 0 1 * * /bin/bash -l -c 'certbot renew --quiet'
}

set_certbot
