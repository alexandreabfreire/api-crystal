require "./resident"
require "json"

class LocationsById

  include JSON::Serializable

  @[JSON::Field(key: "id")]
  property id : String
  @[JSON::Field(key: "name")]
  property name : String
  @[JSON::Field(key: "type")]
  property type : String  
  @[JSON::Field(key: "dimension")]
  property dimension : String 
  @[JSON::Field(key: "residents")]
  property residents : Array(Resident)
  property popularidade : Int32?
  @id = ""
  @name = ""
  @type = ""
  @dimension = ""
  @residents = Array(Resident).new
  @popularidade = 0
end