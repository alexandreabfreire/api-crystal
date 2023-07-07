require "./location"
require "json"

class Data

  include JSON::Serializable

  @[JSON::Field(key: "locationsByIds")]
  getter locationsByIds : Array(LocationsById)
  @locationsByIds = Array(LocationsById).new
end