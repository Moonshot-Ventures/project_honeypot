require 'net/dns'
require "project_honeypot/url"
require "project_honeypot/base"
require "project_honeypot/rack"
require "project_honeypot/rack/header"
require "project_honeypot/rack/forbidden"

module ProjectHoneypot
  class << self
    attr_accessor :api_key, :score, :last_activity, :offenses

    def api_key
      raise "ProjectHoneypot really needs its api_key set to work" unless @api_key
      @api_key
    end

    def configure(&block)
        class_eval(&block)
    end
  end

  def self.lookup(url, api_key=nil)
    api_key ||= ProjectHoneypot.api_key

    raise ArgumentError, 'Must specify an API key' unless api_key

    searcher = Base.new(api_key)
    searcher.lookup(url)
  end
end
