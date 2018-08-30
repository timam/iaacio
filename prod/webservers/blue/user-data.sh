#!/bin/bash
cd /var/www/
sudo git clone -b prod https://github.com/timam/fiesta.git prod.fiesta.timam.io
sudo service nginx restart