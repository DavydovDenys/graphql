VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr'
  c.ignore_hosts '127.0.0.1', 'localhost'
  c.hook_into :webmock
  c.default_cassette_options = {
    match_requests_on: %i[method uri body]
  }
end
