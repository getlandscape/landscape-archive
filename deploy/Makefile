build:
  @cd .. & docker build -t landscape/landscape:latest . -f deploy/Dockerfile
start:
  @docker-compose up -d
status:
  @docker-compose ps
stop:
  @docker-compose stop landscape_app landscape_nginx
down:
  @docker-compose down
secret:
	@test -f app.secret.env || echo "SECRET_KEY_BASE=`openssl rand -hex 32`" > app.secret.env
	@cat app.secret.env
