
### Install

```
cd /usr/share/nginx/html
git clone https://github.com/hayao56/deploy-server.git

cd deploy-server
```

```
# yum install ruby ruby-devel rubygems
# yum install gcc gcc-c++ make openssl-devel zlib-devel
# yum install sqlite-devel
```

```
# gem install bundler
# bundle -v
Bundler version 1.9.3
```

```
# bundle update
```

### Nginx reverse proxy

For CentOS7-nginx in docker container
```
vim /etc/nginx/conf.d/default.conf
```

Ex)
```
    location /drone-golf-deploy {
        rewrite ^/drone-golf-deploy/(.+) /$1 break;
        proxy_pass http://127.0.0.1:9001;
    }
```

```
# systemctl restart nginx
```


### Settings

```
vim deploy_worker.rb
```

```
  7 HOST = '127.0.0.1'
  8 PORT = '9001'
  9 TARGET_DIR = '/usr/share/nginx/html/target-dir'
```

### Run

```sh
export PATH=/usr/bin/ruby:$PATH && bundle exec ruby deploy_worker.rb -e production &
```

### system

```
       1.Push              2.Webhook
local -----------> github -----------> deploy_worker.rb
                     ^                       |
		     |                       |
		     +-----------------------+
                           3. Pull
```
