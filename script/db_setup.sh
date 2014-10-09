#!/bin/bash

usage(){
  echo "Usage: $0 ENVIRONMENT"
  echo "ENVIRONMENT should be: development|test|production"
} 

ENV=$1

if [ -z "$ENV" ] ; then
  usage
  exit
fi

set -x # turns on stacktrace mode which gives useful debug information

if [ ! -f config/database.yml ] ; then
  cp config/database.yml.example config/database.yml
fi

USERNAME=`ruby -ryaml -e "puts YAML::load_file('config/database.yml')['${ENV}']['username']"`
PASSWORD=`ruby -ryaml -e "puts YAML::load_file('config/database.yml')['${ENV}']['password']"`
DATABASE=`ruby -ryaml -e "puts YAML::load_file('config/database.yml')['${ENV}']['database']"`
HOST=`ruby -ryaml -e "puts YAML::load_file('config/database.yml')['${ENV}']['host']"`
echo "Creating site log"
touch log/site_log.log
echo "Succesfully created site log"
echo "Loading sites"
mysql --host=$HOST --user=$USERNAME --password=$PASSWORD $DATABASE < db/sites.sql

echo "Loaded sites succesfully"
