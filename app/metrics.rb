module Metrics
  def track(metric, value)
    if ENV['RACK_ENV'] != 'test'
      puts "logging: #{metric} #{value}"
      conn = TCPSocket.new 'a49e7bd5.carbon.hostedgraphite.com', 2003
      conn.puts "5afc0669-ed8f-49f2-8ada-4bf7bac69c57.#{ENV['RAILS_ENV']}.#{metric} #{value} #{Time.now.to_i}\n"
      conn.close
    end
  end
end
