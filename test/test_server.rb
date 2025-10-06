# test_mcp_server.rb
require "minitest/autorun"
require "net/http"
require "json"

class MCPServerTest < Minitest::Test
  HOST = "localhost"
  PORT = 9292
  URI_BASE = URI("http://#{HOST}:#{PORT}/")

  def post_jsonrpc(payload)
    req = Net::HTTP::Post.new(URI_BASE)
    req["Content-Type"] = "application/json"
    req.body = JSON.dump(payload)

    res = Net::HTTP.start(URI_BASE.hostname, URI_BASE.port) do |http|
      http.request(req)
    end

    assert_equal "200", res.code, "Expected HTTP 200 OK"
    assert_equal "application/json", res["content-type"].split(";").first

    JSON.parse(res.body)
  end

  def test_initialize
    response = post_jsonrpc(
      jsonrpc: "2.0",
      method: "initialize",
      id: 1,
      params: {
        protocolVersion: "2024-11-05",
        capabilities: {},
        clientInfo: { name: "test", version: "1.0" }
      }
    )

    assert_equal "2.0", response["jsonrpc"]
    assert_equal 1, response["id"]
    assert response.key?("result"), "Expected 'result' in response"
  end

  def test_shutdown
    response = post_jsonrpc(
      jsonrpc: "2.0",
      method: "shutdown",
      id: 2,
      params: {}
    )

    assert_equal "2.0", response["jsonrpc"]
    assert_equal 2, response["id"]
    # Many JSON-RPC servers return "result": null for shutdown
    assert response.key?("result"), "Expected 'result' in shutdown response"
  end

  def test_exit
    response = post_jsonrpc(
      jsonrpc: "2.0",
      method: "exit",
      id: 3,
      params: {}
    )

    assert_equal "2.0", response["jsonrpc"]
    assert_equal 3, response["id"]
    # Some servers don't return anything for exit, but we check anyway
    assert response.key?("result"), "Expected 'result' in exit response"
  end

  def test_unknown_method
    response = post_jsonrpc(
      jsonrpc: "2.0",
      method: "doesNotExist",
      id: 99,
      params: {}
    )

    assert_equal "2.0", response["jsonrpc"]
    assert_equal 99, response["id"]
    assert response.key?("error"), "Expected 'error' for unknown method"
    assert_match(/method not found/i, response["error"]["message"])
  end
end

