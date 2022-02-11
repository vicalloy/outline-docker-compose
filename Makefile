install:
	cd ./scripts
	@bash main.sh init_cfg

start: install
	docker-compose up -d

logs:
	docker-compose logs -f

stop:
	docker-compose down || true

clean-docker: stop
	docker-compose rm -fsv || true

clean-conf:
	rm -rfv env.* .env docker-compose.yml

clean: clean-docker clean-conf
