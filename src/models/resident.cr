require "./episode"
require "json"

class Resident
  
  include JSON::Serializable

  @[JSON::Field(key: "name")]
  property name : String
  @[JSON::Field(key: "episode")]
  property episode : Array(Episode)
  @name = ""
  @episode = Array(Episode).new
end