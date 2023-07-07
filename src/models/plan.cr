# require "json"

class Plan
  include JSON::Serializable

  # @[JSON::Field(key: "id")]
  property id : Int32
  # @[JSON::Field(key: "travel_stops")]
  property travel_stops : Array(Int32)
  @id = 0
  @travel_stops = Array(Int32).new
  def initialize
  end
  # def initialize(@id, @travel_stops)
  # end

end