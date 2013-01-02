module ProjectHoneypot::Rack
  class Forbidden
    def initialize(app, options={})
      @app = app

      raise ArgumentError, 'Must specify an API key' unless options[:api_key]
      ProjectHoneypot.api_key = options[:api_key]
    end

    def call(env)
      request = ::Rack::Request.new(env)
      url = ProjectHoneypot.lookup(request.ip)

      if url.safe?
        @app.call(request.env)
      else
        [403, {"Content-Type" => "text/html"}, ["Forbidden"]]
      end
    end
  end
end
