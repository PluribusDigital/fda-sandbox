#!/bin/sh

# let the DB launch
sleep 10

# build the DB
cd /home/app/webapp
bundle exec rake db:create && \
bundle exec rake db:migrate && \
bundle exec rake db:seed