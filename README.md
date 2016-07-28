# README

* Ruby version: check the .ruby-version file(currently at 2.3.1)

* System dependencies: check the Dockerfile and docker-compose.yml
For development, you will need to 
- install the docker-toolbelt
- create a docker-machine - 'docker-machine create <name> --driver=virtualbox'
- Run 'docker-compose up' from the root directory

* Configuration
- Check docker-compose.yml for system level configuration
- This a rails api app created with 'rails new --api', so all rails configurations apply

* Database creation
- Notice that the host in the database.yml is set to 'db' which is defined in the docker-compose.yml
- You will need to have the container with the db image running and
  - If you have the api container running, run 'docker-compose exec api rails db:create'
  - If you dont have the api container running, run 'docker-compose run --rm api rails db:create'

* Database initialization
- You will need to have the container with the db image running and
  - If you have the api container running, run 'docker-compose exec api rails db:migrate'
  - If you dont have the api container running, run 'docker-compose run --rm api rails db:migrate'

* How to run the test suite
- Run 'docker-compose run --rm api rspec spec'

* Deployment instructions - TBD

Note: You can run any command from within the container by starting a shell session.
- If you want to start a shell session in a running container, run 'docker-compose exec -it api /bin/bash'
- If you want to start a new container with shell session, run 'docker-compose run api /bin/bash'
