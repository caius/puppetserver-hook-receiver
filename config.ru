require "thread"

COMMAND = ENV.fetch("COMMAND")

# Webhook server, runs a command serially whenever it receives a request
class Server
  attr_reader :queue

  def initialize
    @queue = Queue.new
  end

  def consumer_thread
    @consumer_thread ||= Thread.new do
      consumer_kicker
    end
  end

  alias_method :start_consumer_thread, :consumer_thread

  def consumer_kicker
    loop do
      case queue.pop
      when :kick
        system COMMAND
      end
    end
  end

  def call(env)
    queue << :kick

    [200, {"Content-Type" => "text/plain"}, ["OK\n"]]
  end
end

app = Server.new
app.start_consumer_thread
run app
