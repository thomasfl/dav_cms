require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/webdav_server')

describe "DAV::Vortex" do

  before(:all) do
    # Start webdav server in subprocess
    @pid = fork do
      webdav_server(:port => 10080, :authentication => false)
    end
    # Wait for webdavserver to start
    wait_for_server("http://localhost:10080/")
  end

  it "should create a DAV::Vortex object" do
    DAV::Vortex.new("http://localhost.localdomain/").should_not be_nil
  end

  it "should read properties from webdav server" do
    vortex = DAV::Vortex.new("http://localhost:10080/")
    @props = vortex.propfind("/").to_s
    @props.should match(/200 OK/)
  end


  it "should set credentials" do
    vortex = Net::DAV.new("http://localhost:10080/")
    vortex.credentials('user','pass')
    @props = vortex.propfind("/").to_s
  end

  after(:all) do
    # Shut down webdav server
    Process.kill('SIGKILL', @pid) rescue nil
  end

end
