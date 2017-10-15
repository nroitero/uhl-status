require 'data_mapper' # requires all the gems listed above
require 'dm-migrations'
DataMapper::Logger.new($stdout, :info)
DataMapper.setup(:default, "mysql://i0fiqs6jmrrc9eor:w8sbevwyv3lcmf2r@zpj83vpaccjer3ah.chr7pe7iynqr.eu-west-1.rds.amazonaws.com:3306/cgfnpubzgrj4gtj1")

class Url
    include DataMapper::Resource
  
    property :id, Serial # An auto-increment integer key
    property :url, Text # A varchar type string, for short strings
    property :loadtime, Text # A text block, for longer string data.
    property :status, Boolean # A text block, for longer string data.
    property :message, Text # A text block, for longer string data.
    property :update_at, DateTime # A DateTime, for any date you might like.
    end
  
  DataMapper.finalize
  DataMapper.auto_upgrade!