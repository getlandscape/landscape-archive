require 'json'
require 'rest-client'
require 'pathname'

def stringfile(string, filename="file_#{rand 100000}")
  file = StringIO.new(string)

  file.instance_variable_set(:@path, filename)
  def file.path
    @path
  end

  return file
end

module Ipfs

  CONFIG_FILEPATH = "#{ENV['HOME']}/.ipfs/config"

  def self.config
    JSON.parse(::File.read(CONFIG_FILEPATH))
  end

  def self.api_endpoint_from_config
    %r{.*API.*/ip4/(.*)/tcp/(\d+)}.match(::File.read CONFIG_FILEPATH) do |matched|
      "#{matched[1]}:#{matched[2]}"
    end
  end

  def self.api_endpoint
    if ENV['ipfs_api_base']
      ENV['ipfs_api_base']
    else
      api_endpoint_from_config
    end
  end

  def self.id
    config["Identity"]
  end

  def self.up?
    endpoint = api_endpoint
    RestClient.post("http://#{api_endpoint}/api/v0/id", '')
  end

  def self.add_file(ipfs_filename)
    endpoint = api_endpoint
    resp = RestClient.post "http://#{api_endpoint}/api/v0/add?pin=true&recursive=true&wrap-with-directory=true", ipfs_filename => File.new(ipfs_filename, 'rb')
    resp.body.split.map { |e| JSON.parse(e) }
  end

  def self.add_dir(dirname)
    endpoint = api_endpoint
    files = Dir.entries(dirname) - ['.', '..']
    files = files.map {|e| [e, File.new(Pathname.new("#{dirname}/#{e}").cleanpath.to_s, 'rb')] }
    resp = RestClient.post "http://#{api_endpoint}/api/v0/add?pin=true&recursive=true&wrap-with-directory=true", files.to_h
    resp.body.split.map { |e| JSON.parse(e) }
  end

  def self.add_datamap(datamap)
    endpoint = api_endpoint
    datamap = datamap.map {|k, e| [k, stringfile(e, k)] }.to_h
    p datamap
    resp = RestClient.post "http://#{api_endpoint}/api/v0/add?pin=true&recursive=true&wrap-with-directory=true", datamap
    resp.body.split.map { |e| JSON.parse(e) }
  end

end

