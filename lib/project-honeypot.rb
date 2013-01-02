require 'net/dns'
require "project_honeypot/url"
require "project_honeypot/base"
require "project_honeypot/rack/header"
require "project_honeypot/rack/forbidden"

module ProjectHoneypot
  class << self
    attr_accessor :api_key

    def api_key
      raise "ProjectHoneypot really needs its api_key set to work" unless @api_key
      @api_key
    end

    def configure(&block)
        class_eval(&block)
    end
  end

  def self.lookup(api_key_or_url, url=nil)
    if url.nil?
      url = api_key_or_url
      api_key_or_url = ProjectHoneypot.api_key
    end
    searcher = Base.new(api_key_or_url)
    searcher.lookup(url)
  end
end
