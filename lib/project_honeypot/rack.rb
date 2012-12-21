module ProjectHoneypot
  class Rack
    def initialize(app, options={})
      @app = app

      raise ArgumentError, 'Must specify an API key' unless options[:api_key]
      ProjectHoneypot.api_key = options[:api_key]
    end

    def call(env)
      request = ::Rack::Request.new(env)
      url = ProjectHoneypot.lookup(request.ip)

      env['PROJECT_HONEYPOT_SAFE'] = url.safe?

      @app.call(request.env)
    end
  end
end
