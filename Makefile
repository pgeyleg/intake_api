# Variables
PROJECT_NAME ?= intake_api_prototype
ORG_NAME ?= casecommons
REPO_NAME ?= intake-api
DOCKER_REGISTRY ?= 429614120872.dkr.ecr.us-west-2.amazonaws.com
AWS_ACCOUNT_ID ?= 429614120872
DOCKER_LOGIN_EXPRESSION := eval $$(aws ecr get-login --registry-ids $(AWS_ACCOUNT_ID))

export HTTP_PORT ?= 80

include Makefile.settings

.PHONY: all version test build clean release tag publish login logout

all: clean login test build release tag publish clean logout

version:
	@ echo $(APP_VERSION)

test:
	${INFO} "Pulling latest images..."
	@ $(if $(NOPULL_ARG),,docker-compose $(TEST_ARGS) pull)
	${INFO} "Building images..."
	@ docker-compose $(TEST_ARGS) build $(NOPULL_FLAG)
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
	@ docker-compose $(RELEASE_ARGS) up -d elasticsearch
	@ $(call check_service_health,$(RELEASE_ARGS),postgres)
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

# 'make tag [<tag>...]' tags development and/or release image with default tags or specified tag(s)
tag: TAGS ?= $(if $(ARGS),$(ARGS),latest $(APP_VERSION) $(COMMIT_ID) $(COMMIT_TAG))
tag:
	${INFO} "Tagging release image with tags $(TAGS)..."
	@ $(foreach tag,$(TAGS),$(call tag_image,$(RELEASE_ARGS),app,$(DOCKER_REGISTRY)/$(ORG_NAME)/$(REPO_NAME):$(tag));)
	${INFO} "Tagging complete"

# Login to Docker registry
login:
	${INFO} "Logging in to Docker registry $$DOCKER_REGISTRY..."
	@ $(if $(AWS_ROLE),$(call assume_role,$(AWS_ROLE)),)
	@ $(DOCKER_LOGIN_EXPRESSION)
	${INFO} "Logged in to Docker registry $$DOCKER_REGISTRY"

# Logout of Docker registry
logout:
	${INFO} "Logging out of Docker registry $$DOCKER_REGISTRY..."
	@ docker logout
	${INFO} "Logged out of Docker registry $$DOCKER_REGISTRY"

# Publishes image(s) tagged using make tag commands
publish:
	${INFO} "Publishing release image to $(DOCKER_REGISTRY)/$(ORG_NAME)/$(REPO_NAME)..."
	@ $(call publish_image,$(RELEASE_ARGS),app,$(DOCKER_REGISTRY)/$(ORG_NAME)/$(REPO_NAME))
	${INFO} "Publish complete"

# IMPORTANT - ensures arguments are not interpreted as make targets
%:
	@:
