#!/usr/bin/env ruby
require 'sinatra'
require 'sinatra/activerecord'
require './models/customer'
require './models/node'
require './osquery_config'
require 'json'

set :database, { adapter: 'sqlite3', database: 'sophos.sqlite3' }

class FleetManager < Sinatra::Base
  configure do
    set :bind, '0.0.0.0'
    set :environment, 'development'
  end

  before do
    content_type 'application/json'
  end

  post '/enroll' do
    post_params = JSON.parse request.body.read
    customer = Customer.where(enrollment_secret: post_params['enroll_secret']).first
    return invalid_response unless customer
    node = if post_params['host_identifier'].present?
      customer.nodes.where(host_identifier: post_params['host_identifier']).first
    else
      # Question: Can unknown hosts that provide a correct secret enroll?
      # if so, then we can do this...
      customer.nodes.create(node_key: SecureRandom.base64, host_identifier: SecureRandom.hex)
    end
    node ? valid_response(node.node_key) : invalid_response
  end

  post '/configuration' do
    post_params = JSON.parse request.body.read
    node = Node.where(node_key: post_params['node_key']).first
    node ? valid_config_response : invalid_config_response
  end

  private

  def invalid_response
    {
      "node_key": "",
      "node_invalid": true
    }.to_json
  end

  def valid_response node_key
    {
      "node_key": "#{node_key}",
      "node_invalid": true
    }.to_json
  end

  def valid_config_response
    {
      "tls_plugin": {
        "schedule": {
          "test_query": {
            "interval": "5",
            "description": "test query",
            "query": "SELECT * FROM processes;"
          }
        }
      },
      "node_invalid": false
    }.to_json
  end

  def invalid_config_response
    {
      "node_invalid": true
    }.to_json
  end

end
