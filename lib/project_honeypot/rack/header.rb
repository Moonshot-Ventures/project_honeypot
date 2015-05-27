module ProjectHoneypot
  class Rack
    class Header < Rack
      def call(env)
        request = ::Rack::Request.new(env)
        url = ProjectHoneypot.lookup(request.ip)

        env['PROJECT_HONEYPOT_SAFE'] = url.safe?

        @app.call(request.env)
      end
    end
  end
end
