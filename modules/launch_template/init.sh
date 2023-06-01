#!/bin/bash
yum install nginx -y
systemctl start nginx.service
aws s3 cp --recursive s3://lesters3staticwebsite/flowertwebsite /usr/share/nginx/html/