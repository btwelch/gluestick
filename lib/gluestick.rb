require_relative 'gluestick/exceptions'
require_relative 'gluestick/onboarding'

#require 'json'
require 'rest-client'

module Gluestick
  class Client
    attr_accessor :api_key, :host, :endpoint


    def initialize(params = {})
      @api_key    = params.fetch(:api_key, nil)
      @host       = params.fetch(:host, 'https://gluestix.herokuapp.com')
      @endpoint   = params.fetch(:endpoint, '/api/start_onboarding_for_customer')
      @conn       = params.fetch(:conn, create_conn)
      @user_agent = params.fetch(:user_agent, 'gluestick/0.1.0;ruby')
      yield self if block_given?
      raise Gluestick::Exception.new('api_key is required') unless @api_key
    end

    def send(mail)
      payload = mail.to_h.merge({api_key: @api_key})
      @conn[@endpoint].post(payload, {user_agent: @user_agent}) do |response, request, result|
        case response.code.to_s
        when /2\d\d/
          response
        when /4\d\d|5\d\d/
          raise Gluestick::Exception.new(response)
        else
          # TODO: What will reach this?
          "DEFAULT #{response.code} #{response}"
        end
      end
    end

    private


    def create_conn
      @conn = RestClient::Resource.new(@host)
    end

  end
end