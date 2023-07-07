class Plan

  include JSON::Serializable
  
  property id : Int32
  property travel_stops : Array(Int32)
  @id = 0
  @travel_stops = Array(Int32).new
  def initialize
  end
end