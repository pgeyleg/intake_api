# Variables
PROJECT_NAME ?= intake_api_prototype
ORG_NAME ?= cwds
REPO_NAME ?= intake-api
DOCKER_REGISTRY ?= 429614120872.dkr.ecr.us-west-2.amazonaws.com
AWS_ACCOUNT_ID ?= 429614120872
DOCKER_LOGIN_EXPRESSION := eval $$(aws ecr get-login --registry-ids $(AWS_ACCOUNT_ID))

export HTTP_PORT ?= 80

include Makefile.settings

.PHONY: test build clean release

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

build:
	${INFO} "Building images..."
	@ docker-compose $(TEST_ARGS) build builder
	${INFO} "Removing existing artifacts..."
	@ rm -rf release
	${INFO} "Building application artifacts..."
	@ docker-compose $(TEST_ARGS) up builder
	@ $(call check_exit_code,$(TEST_ARGS),builder)
	${INFO} "Copying application artifacts..."
	@ docker cp $$(docker-compose $(TEST_ARGS) ps -q builder):/build_artefacts/. release
	${INFO} "Build complete"

release:
	${INFO} "Pulling latest images..."
	@ $(if $(NOPULL_ARG),,docker-compose $(RELEASE_ARGS) pull)
	${INFO} "Building images..."
	@ docker-compose $(RELEASE_ARGS) build app
	@ docker-compose $(RELEASE_ARGS) build $(NOPULL_FLAG) nginx postgres elasticsearch
	${INFO} "Release image build complete..."
	${INFO} "Starting databases..."
	@ docker-compose $(RELEASE_ARGS) up -d postgres
	@ $(call check_service_health,$(RELEASE_ARGS),postgres)
	@ docker-compose $(RELEASE_ARGS) up -d elasticsearch
	@ $(call check_service_health,$(RELEASE_ARGS),elasticsearch)
	${INFO} "Running database migrations..."
	@ docker-compose $(RELEASE_ARGS) run app bundle exec rake db:create
	@ docker-compose $(RELEASE_ARGS) run app bundle exec rake db:migrate
	@ docker-compose $(RELEASE_ARGS) run app bundle exec rake search:migrate
	@ docker-compose $(RELEASE_ARGS) run app bundle exec rake search:reindex
	${INFO} "Starting application..."
	@ docker-compose $(RELEASE_ARGS) up -d app
	${INFO} "Starting nginx..."
	@ docker-compose $(RELEASE_ARGS) up -d nginx
	@ $(call check_service_health,$(RELEASE_ARGS),nginx)
	${INFO} "Application is running at http://$(DOCKER_HOST_IP):$(call get_port_mapping,$(RELEASE_ARGS),nginx,$(HTTP_PORT))/api/v1/screenings"

clean:
	${INFO} "Destroying development environment..."
	@ docker-compose $(TEST_ARGS) down --volumes || true
	${INFO} "Destroying release environment..."
	@ docker-compose $(RELEASE_ARGS) down --volumes || true
	${INFO} "Removing dangling images..."
	@ $(call clean_dangling_images,$(PROJECT_NAME))
	${INFO} "Clean complete"