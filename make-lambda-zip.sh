#!/bin/sh
bundle config set --local path 'vendor/bundle'
rm -rf vendor mackerel-webhook-gateway-googlechat.zip
bundle install --gemfile Gemfile-lambda
mv vendor/bundle/ruby/3.1.0 vendor/bundle/ruby/3.2.0
bundle config unset --local path
zip -r mackerel-webhook-gateway-googlechat.zip exe/lambda-handler-googlechat.rb customize.rb lib vendor
