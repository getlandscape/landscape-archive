RUN  = docker-compose run app
RAKE = docker-compose run app bundle exec rake

build:
	@docker build -t landscape/landscape:latest . -f deploy/Dockerfile
shell:
  docker exec -it landscape_app /bin/sh
up:
	docker-compose up -d -f deploy/docker-compose.yml
status:
	docker-compose ps -f deploy/docker-compose.yml
stop:
	docker-compose stop landscape_app landscape_nginx -f deploy/docker-compose.yml
down:
	docker-compose down -f deploy/docker-compose.yml
secret:
	@test -f deploy/app.secret.env || echo "SECRET_KEY_BASE=`openssl rand -hex 32`" > deploy/app.secret.env
	@cat deploy/app.secret.env
backup:
	./deploy/backup .
install:
	@$(RUN) bundle exec rails db:migrate RAILS_ENV=production
	@$(RUN) bundle exec rails db:seed RAILS_ENV=production
	@$(RUN) bundle exec rails assets:precompile RAILS_ENV=production
reindex:
	@echo "Reindex ElasticSearch..."
	@$(RAKE) environment elasticsearch:import:model CLASS=Topic FORCE=y
	@$(RAKE) environment elasticsearch:import:model CLASS=User FORCE=y
