# Variables
PROJECT_NAME ?= intake_api_prototype

include Makefile.settings

.PHONY: test clean

test:
	${INFO} "Pulling latest images..."
	@ docker-compose $(TEST_ARGS) pull
	${INFO} "Building images..."
	@ docker-compose $(TEST_ARGS) build --pull
	${INFO} "Starting services..."
	@ docker-compose $(TEST_ARGS) up -d postgres
	@ $(call check_service_health,$(TEST_ARGS),postgres)
	@ docker-compose $(TEST_ARGS) up -d elasticsearch
	@ $(call check_service_health,$(TEST_ARGS),elasticsearch)
	${INFO} "Running tests..."
	@ docker-compose $(TEST_ARGS) up rspec_test
	@ docker cp $$(docker-compose $(TEST_ARGS) ps -q rspec_test):/reports/. reports
	@ $(call check_exit_code,$(TEST_ARGS),rspec_test)
	${INFO} "Testing complete"

clean:
	${INFO} "Destroying test environment..."
	@ docker-compose $(TEST_ARGS) down --volumes
	${INFO} "Removing dangling images..."
	@ $(call clean_dangling_images,$(PROJECT_NAME))
	${INFO} "Clean complete"