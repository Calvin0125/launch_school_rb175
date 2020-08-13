require "socket"

def parse_request(request_line)
  request_array = request_line.split
  http_method = request_array[0]
  path = request_array[1].split('?')[0]
  query = request_array[1].split('?')[1]
  query = (query || "").split('&').map { |param| param.split('=') }
  params = {}
  query.each { |param| params[param[0]] = param[1] }
  [http_method, path, params]
end

server = TCPServer.new("localhost", 3003)
loop do
  client = server.accept

  request_line = client.gets
  next if !request_line || request_line =~ /favicon/
  puts request_line
  next unless request_line

  http_method, path, params = parse_request(request_line)

  client.puts "HTTP/1.1 200 OK"
  client.puts "Content-Type: text/html\r\n\r\n"
  client.puts "<html>"
  client.puts "<body>"
  client.puts "<pre>"
  client.puts http_method
  client.puts path
  client.puts params
  client.puts "</pre>"

  client.puts "<h1>Counter</h1>"
  
  number = params["number"].to_i
  client.puts "<p>The current number is #{number}.</p>"

  client.puts "<a href='?number=#{number + 1}'>Add one</a>"
  client.puts "<a href='?number=#{number - 1}'>Subtract one</a>"

  client.puts "</body>"
  client.puts "</html>"

  client.close
end