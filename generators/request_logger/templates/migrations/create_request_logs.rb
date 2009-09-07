class CreateRequestLogs < ActiveRecord::Migration
  def self.up
    create_table :request_logs, :force => true do |t|
      t.string  :session_id
      t.string  :uri
      t.string  :remote_ip, :limit => 15
      t.string  :user_agent
      t.string  :controller
      t.string  :action
      t.integer :pid
      t.string  :referer
      t.text    :params
      t.string  :status

      t.timestamps
    end
  end

  def self.down
    drop_table :request_logs
  end
end
