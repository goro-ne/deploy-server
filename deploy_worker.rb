#!/usr/bin/ruby

require 'sinatra'
require 'sinatra/base'
require 'json'

HOST = '127.0.0.1'
PORT = '9001'
TARGET_DIR = '/usr/share/nginx/html/drone-golf'

#stdout.sync = true

class DeployWorker < Sinatra::Base

  module GetOrPost
    def get_or_post(url, &block)
      get  url, &block
      post url, &block
    end
  end
  register GetOrPost

  get_or_post "/test" do
    puts "CALL test"
    puts "#{request.body.read}"
    "This is test.\n"
  end

  post '/deploy' do
    puts "CALL deploy"
    puts "#{request.body.read}"

    request.body.rewind
    payload = JSON.parse(request.body.read)
    status 403 && return if payload.nil?

    app = payload["repository"]["name"]

    `cd #{TARGET_DIR} && git pull origin master`
    "done"
  end
end

DeployWorker.run!:host => "#{HOST}",:port => "#{PORT}"
