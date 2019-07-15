# phile-starter 

## setup instructions

### requirements

- <a href="https://nodejs.org/">node</a>
  install v10 LTS or later
- <a href="https://yarnpkg.com/lang/en/docs/install">yarn</a>
  you can use npm if you prefer, but as of the time of this writing, yarn is the package manager of choice 
  (this will all be rethought after the great package manager wars of 2020, no doubt...)
- <a href="https://www.docker.com/get-started">docker</a>
  docker will make postgres easy to deal with
- <a href="https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html">ansible</a>
  ansible executes a series of commands to build the database 

also, you will need to install at least the postgres client on your local machine.  there are a couple of ways to do this
- install postgres outright, then disable the server (we are going to be using docker to run postgres in a container)
    https://www.postgresql.org/download/
- install only the client libraries. this method may be a bit less reliable depending on your environment
    https://www.compose.com/articles/postgresql-tips-installing-the-postgresql-client/

after installing the above:

```
git clone git@ssh.dev.azure.com:v3/dauntlessinc/phile-starter/phile-starter

cp ansible/config.ex.yml > ansible/config.yml
```

you need to edit the ansible/config.yml file to point the docker postgres script at your local pg10 data directory
```
pg10_data_path: [PATH TO YOUR PG 10 DATA DIRECTORY]
sqitch_target_local: db:pg://postgres:1234@0.0.0.0/phile_starter
```

then
```
yarn devSetup
```

this will create a shell script that will start the postgres docker image using the pg10 data directory from your ansible/config.yml

run this script to start your database server
```
yarn pg10
```

the image will take a bit to spin up, maybe 30 sec.  you can run psql with the following:
```
yarn psql
```

if you are unfamiliar with the psql client, to quit just enter:
```
\q
```

once postgres is ready, as indicated by success of the psql connection, deploy the database

```
yarn dbDeployLocal
```

open a terminal in the phile_starter/api 

## directory structure

### ansible
ansible-playbooks to aid in dev setup

### api
node-postgraphile graphql server

### az-config
ansible-playbooks to aid in setup on the azure platform

### db
scripts to define and the datbase using sqitch

### drpFunctions
repo for durable-functions related to DRP - may go away

### giant-phile
repo used to explore possibilities with direct import of some data from gian - may go away

### return-manifest
repo for classic javascript implementation of same concepts as drpFunctions - may go away

### sync
repo for the traceability-capture sync process to capture leaf/biotrack/metrc data

### tcFunctions
repo to explore sync as durable-functions.  not a good idea.  will go away

### web-vue
a starter web app that demonstrates login, row-level-security, app modules, and more.  could be basis for a new project or can be thrown away in favor of a different ui


## openssl cert setup
to connect to the test database, follow these instructions to obtain a cert file:

https://docs.microsoft.com/en-us/azure/postgresql/concepts-ssl-connection-security#applications-that-require-certificate-verification-for-ssl-connectivity

# running the server
in a new terminal, go to the phile-starter/api directory

to use the dev db server on azure
```
yarn serve-az-tmp
```

for local db
```
yarn serve
```
