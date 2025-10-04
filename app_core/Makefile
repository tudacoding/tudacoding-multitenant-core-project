gen-docker-compose:
	@jsonnet docker-compose.jsonnet | yq eval -P > docker-compose.yml

start-container:
	docker-compose -p multitenant-core up

stop-container:
	docker-compose -p multitenant-core down