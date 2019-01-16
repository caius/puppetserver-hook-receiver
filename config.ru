# Webhook server, runs a command serially whenever it receives a request
class Server
  def call(env)
    [200, {"Content-Type" => "text/plain"}, ["OK\n"]]
  end
end

app = Server.new
run app
