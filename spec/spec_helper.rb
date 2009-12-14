$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'dav_cms/vortex'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|

end

# Wait for webdav server to start up
def wait_for_server(address)
  server_running = false
  dav = Net::DAV.new(address)
  count = 0
  while(not(server_running))
    begin
      sleep(0.1)
      puts "Test " + count.to_s
      props = dav.propfind("/").to_s
      if(props.match(/200 OK/))
        server_running = true
      else
        warn "Webdav server should return \"200 OK\" "
        exit(1)
      end
    rescue
      count += 1
      puts "Server not running. Retrying..." if ((count % 10) == 0)
    end
  end
  dav = nil
end
