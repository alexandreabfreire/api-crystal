require "json"

class Episode

  include JSON::Serializable

  @[JSON::Field(key: "name")]
  property name : String
  @name = ""
end