oidc_server_container=wk-oidc-server
docker-compose := $(shell command -v docker-compose 2> /dev/null || echo "docker compose")

gen-conf:
#	echo ${docker-compose}
	cd ./scripts && bash ./main.sh init_cfg

start:
	${docker-compose} up -d
	cd ./scripts && bash ./main.sh reload_nginx

install: gen-conf start
	sleep 1
	${docker-compose} exec ${oidc_server_container} bash -c "make init"
	${docker-compose} exec ${oidc_server_container} bash -c "python manage.py loaddata oidc-server-outline-client"
	cd ./scripts && bash ./main.sh reload_nginx

restart: stop start

logs:
	${docker-compose} logs -f

stop:
	${docker-compose} down || true

update-images:
	${docker-compose} pull

clean-docker: stop
	${docker-compose} rm -fsv || true

clean-conf:
	rm -rfv env.* .env docker-compose.yml config/uc/fixtures/*.json

clean-data: clean-docker
	rm -rfv ./data/certs ./data/minio_root ./data/pgdata ./data/uc

clean: clean-docker clean-conf
