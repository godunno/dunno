require 'vcr'

VCR.configure do |c|
  c.ignore_request do |request|
    uri = URI(request.uri)
    # ElasticSearch
    uri.host == "localhost" && uri.port == 9200
  end
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
end
