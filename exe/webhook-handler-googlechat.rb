#!/usr/bin/env ruby
# Saba Webhook Gateway Handler for Google Chat on Sinatra
#
# Copyright 2023 Kenshi Muto <kmuto@kmuto.jp>
require 'dotenv'
require 'sinatra'

require_relative '../lib/saba-webhook-gateway'

Dotenv.load
@bind = ENV['SERVER_BIND'] || '0.0.0.0'
@port = ENV['SERVER_PORT'] || 4567
@path = ENV['SERVER_PATH'] || '/'

set :bind, @bind
set :port, @port

post @path do
  status 204
  request.body.rewind
  request_json = request.body.read

  m = SabaWebhookGateway::GoogleChat.new
  h = m.parse(request_json)
  m.run(h) if h
end
