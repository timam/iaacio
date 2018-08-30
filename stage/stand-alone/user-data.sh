#!/bin/bash
cd /var/www/
sudo git clone -b stage https://github.com/timam/fiesta.git stage.fiesta.timam.io
sudo service nginx restart