# Variables
TEST_PROJECT := api_prototype_test
TEST_COMPOSE_FILE := docker/test/docker-compose.yml

.PHONY: test clean

# Check and Inspect Logic
INSPECT := $$(docker-compose -p $$1 -f $$2 ps -q $$3 | xargs -I ARGS docker inspect -f "{{ .State.ExitCode }}" ARGS)
CHECK := @bash -c '\
  if [[ $(INSPECT) -ne 0 ]]; \
  then exit $(INSPECT); fi' VALUE

test:
	${INFO} "Pulling latest images..."
	@ docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) pull
	${INFO} "Building images..."
	@ docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) build --pull postgres
	@ docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) build --pull elasticsearch
	@ docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) build --pull rspec_test
	${INFO} "Running tests..."
	@ docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) up -d postgres
	@ docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) up -d elasticsearch
	@ docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) up rspec_test
	@ docker cp $$(docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) ps -q rspec_test):/reports/. reports
	${CHECK} $(TEST_PROJECT) $(TEST_COMPOSE_FILE) rspec_test
	${INFO} "Testing complete"

clean:
	${INFO} "Destroying test environment..."
	@ docker-compose -p $(TEST_PROJECT) -f $(TEST_COMPOSE_FILE) down --volumes
	${INFO} "Clean complete"

# Cosmetics
YELLOW := "\e[1;33m"
NC := "\e[0m"

# Shell Functions
INFO := @bash -c '\
  printf $(YELLOW); \
  echo "=> $$1"; \
  printf $(NC)' SOME_VALUE
