module ProjectHoneypot
  class Rack
    class Forbidden < Rack
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
end
