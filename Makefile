ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
UID:=$(shell id -u)
GID:=$(shell id -g)

cli:
	docker-compose exec php bash

up:
	docker-compose up -d $(c)
down:
	docker-compose down $(c)
down-volumes:
	docker-compose down -v $(c)
start:
	docker-compose start $(c)
stop:
	docker-compose stop $(c)
exec:
	docker-compose exec $(c)

yarn:
	docker run --rm -it --env-file $(ROOT_DIR)/.env -v $(ROOT_DIR):/app -w /app --init node:8 yarn $(c)
yu:
	make yarn c="upgrade $(c)"
ya:
	make yarn c="add $(c) --dev"
yi:
	make yarn c="install $(c)"

composer:
	docker-compose exec -u $(UID):$(GID) php composer $(c)
cu:
	make composer c="update -o $(c)"
cr:
	make composer c="require $(c)"
ci:
	make composer c="install -o $(c)"

console:
	docker-compose exec -u $(UID):$(GID) php bin/console $(c)

db_repair:
	docker-compose exec -T mariadb mysqlcheck -h $${MYSQL_ROOT_HOST} -uroot -p"$${MYSQL_ROOT_PASSWORD}" --auto-repair --optimize --all-databases

db_dump:
	docker-compose exec -T mariadb sh -c 'exec mysqldump --all-databases -uroot -p"$${MYSQL_ROOT_PASSWORD}"' > ./mariadb/dump-$(shell date +"%F").sql

certbot:
	docker run --rm -it  -v $(ROOT_DIR)/docker/apache/certs:/etc/letsencrypt -p 80:80 -p 443:443 certbot/certbot certonly -m root@example.com --no-eff-email --standalone --rsa-key-size 2048 --agree-tos --expand -d $(nameservers)

certbot_renew:
	docker-compose stop apache
	docker run --rm -it  -v $(ROOT_DIR)/docker/apache/certs:/etc/letsencrypt -p 80:80 -p 443:443 certbot/certbot renew
	docker-compose start apache
