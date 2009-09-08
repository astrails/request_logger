Request Logger

= Description

Request Logger logs request. duh!
Seriously though, its an after_filter that logs request_information into the database.
Logged information includes session_id, request_ip, uri, etc.
It also allows to extend the logged information with custom fields.

= Installation

    script/plugin install http://github.com/astrails/request_logger
    script/generate request_logger
    rake db:migrate

Add the following to your application_controller.rb:

    class ApplicationController < ActionController::Base
      log_requests
      ...
    end

= Customization

You can add your own fields to the request_logs table and provide a controller method to add custom
information to the created request_log record:

in your migration:

    class MoreLoggerFields < ActiveRecord::Migration
      def self.up
        add_column :request_logs, :my_field, :integer
      end
      ...

in application_controller.rb:

    class ApplicationController < ActionController::Base
      log_requests :request_info => :set_my_field
      ...
    protected
      def set_my_field(record)
        record.my_field = ...
      end
    end
