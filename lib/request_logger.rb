module RequestLogger
  protected
  def log_request
    options = self.class.read_inheritable_attribute(:request_logger_options)

    if condition = options[:if]
      return unless condition.respond_to?(:call) ? condition.call(self) : send(condition)
    end

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

    if callback = options[:callback]
      callback.respond_to?(:call) ? callback.call(self, rec) : send(callback, rec)
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

    write_inheritable_attribute :request_logger_options, :callback => opts.delete(:callback), :if => opts.delete(:if)

    opts.assert_valid_keys(:only, :except)
    skip_after_filter :log_request
    after_filter :log_request, opts
  end
end
