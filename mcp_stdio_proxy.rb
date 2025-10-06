#!/usr/bin/env ruby
require "json"
require "net/http"
require "uri"

# Endpoint of your Rails MCP server
MCP_URL = ENV.fetch("MCP_ENDPOINT", "http://127.0.0.1:3000/mcp")

def forward_to_http(message)
  uri = URI(MCP_URL)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = (uri.scheme == "https")

  request = Net::HTTP::Post.new(uri.request_uri, { "Content-Type" => "application/json" })
  request.body = JSON.dump(message)

  response = http.request(request)

  unless response.is_a?(Net::HTTPSuccess)
    warn "HTTP error: #{response.code} #{response.body}"
    return nil
  end

  JSON.parse(response.body)
rescue => e
  warn "Proxy error: #{e.message}"
  nil
end

# Main loop: read JSON-RPC messages from stdin, forward, print to stdout
STDOUT.sync = true
STDIN.each_line do |line|
  line.strip!
  next if line.empty?

  begin
    message = JSON.parse(line)
  rescue JSON::ParserError
    warn "Invalid JSON from Claude: #{line}"
    next
  end

  response = forward_to_http(message)
  if response
    puts JSON.dump(response)
    STDOUT.flush
  end
end
