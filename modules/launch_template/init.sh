#!/bin/bash
yum install nginx -y
yum install -y amazon-efs-utils
mount -t efs -o tls fs-0c52521695fdece1b:/ /usr/share/nginx/html/
systemctl start nginx.service