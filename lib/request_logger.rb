module RequestLogger
  protected
  def log_request
    options = self.class.read_inheritable_attribute(:request_logger_options)

    rec = RequestLog.new :session_id => request.session_options[:id],
      :uri        => request.try(:url),
      :remote_ip  => request.try(:remote_ip),
      :user_agent => request.try(:user_agent),
      :controller => controller_class_name,
      :action     => action_name,
      :pid        => $$,
      :referer    => request.referer,
      :params     => respond_to?(:filter_parameters) ? filter_parameters(params).inspect : params.inspect,
      :status     => response.headers["Status"]

    if options[:request_info]
      self.send(options[:request_info], rec)
    end

    rec.save!
  rescue => e
    logger.error "Failed to log request: #{e}"
    logger.debug e.backtrace * "\n"
  end
end

class ActionController::Base
  def self.log_requests(opts = {})
    include RequestLogger
    after_filter :log_request, :only => opts[:only], :except => opts[:except]
    write_inheritable_hash :request_logger_options, :request_info => opts[:request_info]
  end
end