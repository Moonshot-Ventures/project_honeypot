module ProjectHoneypot
  class Rack
    def initialize(app, options={})
      @app = app

      raise ArgumentError, 'Must specify an API key' unless options[:api_key]
      ProjectHoneypot.api_key = options[:api_key]
    end
  end
end
