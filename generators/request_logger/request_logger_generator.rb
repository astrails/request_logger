class RequestLoggerGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.file "app/models/request_log.rb", "app/models/request_log.rb"
      m.migration_template "migrations/create_request_logs.rb", 'db/migrate', :migration_file_name => "create_request_logs"
    end
  end
end