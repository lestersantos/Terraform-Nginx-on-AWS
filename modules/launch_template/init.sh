#!/bin/bash
yum install nginx -y
yum install -y amazon-efs-utils
mount -t efs -o tls efs_id:/ /usr/share/nginx/html/
systemctl start nginx.service