require 'json'

module Gluestick
  class OnboardingCustomer
    attr_accessor :customer_email, :customer_first_name, :customer_last_name, :customer_phone, :customer_website

    def initialize(params = {})
      params.each do |k, v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
      yield self if block_given?
    end

    def to_h
      payload = {
        :customer_email => @customer_email,
        :customer_first_name => @customer_first_name,
        :customer_last_name => @customer_last_name,
        :customer_phone => @customer_phone
        :customer_website => @customer_website
      }.reject {|k,v| v.nil?}

      payload
    end
  end
end