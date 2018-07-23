.PHONY: build
build:
	cd cmd/proxy && buffalo build
	cd cmd/olympus && buffalo build

.PHONY: run
run: build
	./athens

.PHONY: docs
docs:
	cd docs && hugo

.PHONY: test
test: export ATHENS_MONGO_STORAGE_URL=$(docker-compose -p athensdev port mongo 27017)
test:
	cd pkg && go test ./...
	cd cmd/proxy && buffalo test
	cd cmd/olympus && buffalo test

.PHONY: olympus-docker
olympus-docker:
	docker build -t gopackages/olympus -f cmd/olympus/Dockerfile .

.PHONY: dev
dev:
	docker-compose -p athensdev up -d mysql
	docker-compose -p athensdev up -d postgres
	docker-compose -p athensdev up -d mongo
	docker-compose -p athensdev up -d redis
	docker-compose -p athensdev up -d minio
	docker-compose -p athensdev up -d jaeger
	echo "sleeping for a bit to wait for the DB to come up"
	sleep 5

.PHONY: dev-teardown
dev-teardown:
	docker-compose -p athensdev down
	docker volume prune
