# Request Logger

## Description

Request Logger logs request. duh!
Seriously though, its an after_filter that logs request_information into the database.
Logged information includes session_id, request_ip, uri, etc.
It also allows to extend the logged information with custom fields.

## Installation

    script/plugin install http://github.com/astrails/request_logger
    script/generate request_logger
    rake db:migrate

Add the following to your application_controller.rb:

    class ApplicationController < ActionController::Base
      log_requests
      ...
    end

## Customization

### Guards

You can use :only, :except, :if conditions when calling the log_requests. :if accepts a method name or a proc
which will be called with controller as the only argument

    class ApplicationController < ActionController::Base
      log_requests :only => :index, :if => proc {|controller| controller.params[:format] == "xml"}
      ...
    end

    class ApplicationController < ActionController::Base
      log_requests :except => [:edit, :new], :if => :api_request?
      ...
    protected
      def api_request?
        ...
      end
    end

You can completely disable the filter in on of the controllers by calling skip_after_filter:

    class BoringController
      skip_after_filter :log_request
      ...
    end

### Extra logging fields

You can also add your own fields to the request_logs table and provide a controller method (or proc) to add custom
information to the created request_log record:

#### in your migration:

    class MoreLoggerFields < ActiveRecord::Migration
      def self.up
        add_column :request_logs, :format, :string, :limit => 8
      end
      ...

#### in application_controller.rb:

    class ApplicationController < ActionController::Base
      log_requests :callback => :set_my_field
      ...
    protected
      def set_my_field(record)
        record.format = params[:format]
      end
    end

OR

    class ApplicationController < ActionController::Base
      log_requests :callback => proc {|controller, record| record.format = controller.params[:format] }
      ...
    end
