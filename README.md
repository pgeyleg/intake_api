# README

* Ruby version: check the .ruby-version file(currently at 2.3.1)
* Postgres Version: 9.5.3

For Local Workstation setup, please follow these steps:
- After cloning the repo make sure you have ruby, bundler and postgres set up.
- Run ```bundle install```
- Run ```bundle exec rails db:create db:migrate```


For Docker based development setup, please follow these steps:
You will need to 
- install the docker-toolbelt
- create a docker-machine: ```docker-machine create <name> --driver=virtualbox```
- Run ```docker-compose up``` from the root directory

* Configuration
- Check docker-compose.yml for system level configuration
- This a rails api app created with ```rails new --api```, so all rails configurations apply

* Database creation and initialization
  - run ```docker-compose exec api rails db:create db:migrate```

* How to run the test suite
- Run ```docker-compose run --rm api rspec spec```

* Deployment instructions - TBD

Note: You can run any command from within the container by starting a shell session.
- If you want to start a shell session in a running container, run ```docker-compose exec -it api /bin/bash```
- If you want to start a new container with shell session, run ```docker-compose run api /bin/bash```

