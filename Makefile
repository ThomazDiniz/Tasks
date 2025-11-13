.PHONY: build up down test clean

build:
	docker-compose build

up:
	docker-compose up

down:
	docker-compose down

test:
	docker-compose -f docker-compose.test.yml up --abort-on-container-exit

clean:
	docker-compose down -v

