
require "./data"
require "json"

class Integrations

  include JSON::Serializable

  @[JSON::Field(key: "data")]  
  getter data : Data
  def initialize(@data)
  end
end