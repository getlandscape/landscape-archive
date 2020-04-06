RUN  = docker-compose run landscape_app
RAKE = docker-compose run landscape_app bundle exec rake

build:
	@docker build -f deploy/Dockerfile -t landscape/landscape:latest .
shell:
	docker exec -it landscape_app /bin/sh
status:
	docker-compose -f deploy/docker-compose.yml ps
stop:
	docker-compose -f deploy/docker-compose.yml stop landscape_app landscape_nginx
up:
	docker-compose -f deploy/docker-compose.yml up -d
down:
	docker-compose -f deploy/docker-compose.yml down
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
