require 'net/dav'
require 'uri'

module DAV

  class Vortex < Net::DAV

    def initialize(uri)
      @dav = Net::DAV.new(uri, :curl => false)
      @dav.verify_server = false
      return @dav
    end

    def exists?(url)
      uri = URI.parse(url)
      # @dav = connect(url)
      if(!@dav)
        @dav = connect(url)
      end
      begin
        @dav.propfind(uri.path)
      rescue Net::HTTPServerException => e
        return false if(e.to_s =~ /404/)
      end
      return true
    end

    # Returns properties for webdav resource as xml
    def properties(url)
      uri = URI.parse(url)
      if(exists?(url))
        @dav.propfind(uri.path).to_s
      else
        throw "404 File not found"
      end
    end

    # Gets resource (file) from webdav server
    def get(url)
      uri = URI.parse(url)
      if(exists?(url))
        @dav.get(uri.path).to_s
      else
        throw "404 File not found"
      end
    end

    def publish(object)
      puts "DEBUG: publish object: " + object.Class.to_s
    end

  end

end
