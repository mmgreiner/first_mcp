# Try a very simple MCP

## Goals

- Create a simple MCP tool server and test it
- Use [ruby-mcp] and the programming language [ruby] to create the server
- Write some [minitest] tests for it
- Test it with [mcp-inspector]
- Connect it to the hosts [claude-desktop] and [open-webui]

[ruby]: https://www.ruby-lang.org/en/
[ruby-mcp]: https://github.com/modelcontextprotocol/ruby-sdk
[claude-desktop]: https://docs.claude.com/en/home
[open-webui]: https://github.com/open-webui/mcpo
[mcp-inspector]: https://github.com/modelcontextprotocol/inspector

## Notes
 
See very good session at Rails Conference: duck://player/IYAWJQ_HSQs

See also repository at mcp-on-rails <https://github.com/pstrzalk/mcp-on-rails>

And rails templates at <https://www.visuality.pl/posts/mcp-template-for-rails-applications>

See <https://github.com/modelcontextprotocol/ruby-sdk/blob/main/examples/README.md>

S
create files `http_client.rb` and `http_server.rb` from the link above.

Start the server:

~~~
$ ruby http_server.rb
Starting MCP HTTP server on http://localhost:9292
Use POST requests to initialize and send JSON-RPC commands
Example initialization:
  curl -i http://localhost:9292 --json '{"jsonrpc":"2.0","method":"initialize","id":1,"params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}'

The server will return a session ID in the Mcp-Session-Id header.
Use this session ID for subsequent requests.

Press Ctrl+C to stop the server
Puma starting in single mode...
* Puma version: 7.0.3 ("Romantic Warrior")
* Ruby version: ruby 3.4.6 (2025-09-16 revision dbd83256b1) +PRISM [x86_64-darwin24]
*  Min threads: 0
*  Max threads: 5
*  Environment: development
*          PID: 16284
* Listening on http://127.0.0.1:9292
* Listening on http://[::1]:9292
Use Ctrl-C to stop
~~~

Start the mcp inspector

~~~~
% npx @modelcontextprotocol/inspector
~~~~


## Datatypes

see [MCP Datatypes](./mcp_datatypes.md).
 
