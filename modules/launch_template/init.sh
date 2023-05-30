#!/bin/bash
yum install nginx -y
systemctl start nginx.service
aws s3 cp s3://lesters3staticwebsite/index.html /usr/share/nginx/html/index.html