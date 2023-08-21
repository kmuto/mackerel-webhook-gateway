#!/usr/bin/env ruby
# Mackerel Webhook Gateway
# Support:
#   - Google Chat Webhook
#
# Copyright 2023 Kenshi Muto <kmuto@kmuto.jp>
require 'dotenv'
require 'json'
require 'faraday'
require 'erb'

class MackerelWebhookGateway
  def initialize
    Dotenv.load
    @mackerel_url = ENV['MACKEREL_URL'] || 'https://mackerel.io'
  end

  def receive_incoming
    s = <<JSON
{"event":"sample","message":"Sample Notification from Mackerel","imageUrl":null}
JSON
    JSON.parse(s)
  end

  def convert_googlechat(json)
    erb = nil
    case json['event']
    when 'sample'
      erb = ERB.new(File.read(File.join('googlechat-erb', 'sample.erb')))
    when 'monitorUpdate'
      erb = ERB.new(File.read(File.join('googlechat-erb', 'monitorupdate.erb')))
    when 'alert'
      erb = ERB.new(File.read(File.join('googlechat-erb', 'alert.erb')))
    end
    return nil unless erb
    erb.result_with_hash(json)
  end

  def post_googlechat(json)
    resp = Faraday.post ENV['GOOGLECHAT_WEBHOOK'] do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = json
    end
    p resp.body
  end
  
  def gateway_googlechat
    json = receive_incoming
    json['mackerel_url'] = @mackerel_url
    converted_json = convert_googlechat(json)
    puts converted_json
    post_googlechat(converted_json) if converted_json
  end
end

m = MackerelWebhookGateway.new
m.gateway_googlechat
