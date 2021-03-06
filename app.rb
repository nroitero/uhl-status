
require 'active_support'

require 'awesome_print'
require 'metainspector'

require_relative 'db.rb'

cache = ActiveSupport::Cache.lookup_store(:file_store, '/tmp/cache')


time = Time.now

urls = Url.all.map{|url| url.url}
urls.each do |url|
  time = Time.now
  db=Url.first(url: url)

  begin
    page = MetaInspector.new(url, connection_timeout: 5, read_timeout: 1, retries: 3, faraday_http_cache: { store: cache }) # , faraday_options: { ssl: { verify: false } }
    db.loadtime=(Time.now - time)
    db.status=true
    db.message="OK"
    db.update_at=time
  rescue => e
    db.status=false
    db.loadtime=0
    db.message=e.message
    db.update_at=time
  end
  db.save
end
