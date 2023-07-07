require "kemal"
require "mysql"
require "json"
require "http/client"
require "./models/integration"
require "./services/travel_plans_data"

module Api

  VERSION = "0.1.0" 
 
  include JSON::Serializable
 
  get "/travel_plans" do |env|
    optimize = env.params.query["optimize"]?
    expand = env.params.query["expand"]?
    if optimize.nil? || (optimize.size < 1)
      optimize = "false"
    end
    if expand.nil? || (expand.size < 1)
      expand = "false"
    end     
    puts optimize
    env.response.headers["Content-Type"] = "application/json"
    tp = Travel_plans_data.new
    data = tp.travel_plan_get_all_location() # consulta a base mysql de planos de viagem    
    if (data.size > 2)
      tp.start_integration("#{data}"); # consulta a base da api Rick and Morty via query graphql
      if (expand == "true")
        "#{tp.expand_true(optimize)}"
      else
        "#{tp.expand_false(optimize)}"
      end
    else
      "#{data}"
    end
  end

  get "/travel_plans/:id" do |env|
    optimize = env.params.query["optimize"]?
    expand = env.params.query["expand"]?
    if optimize.nil? || (optimize.size < 1)
      optimize = "false"
    end
    if expand.nil? || (expand.size < 1)
      expand = "false"
    end        
    env.response.headers["Content-Type"] = "application/json"
    tp = Travel_plans_data.new
    data = tp.travel_plan_get_from(env.params.url["id"].to_i)      
    if (data.id > 0)
      tp.start_integration("#{data.travel_stops}");
      if (expand == "true")
        "#{tp.expand_true_by_id(env.params.url["id"].to_i, optimize)}"
      else
        "#{tp.expand_false_by_id(env.params.url["id"].to_i, optimize)}"
      end  
    end
  end

  delete "/travel_plans/:id" do |env| 
    tp = Travel_plans_data.new
    tp.travel_plan_delete(env.params.url["id"].to_i)
    env.response.status_code = 204
  end

  post "/travel_plans" do |env| 
    body = env.request.body.as(IO).gets_to_end    
    env.response.headers["Content-Type"] = "application/json"
    tp = Travel_plans_data.new
    response = tp.travel_plan_post(body)   
    env.response.status_code = 201
    %(#{response.to_json})
  end

  put "/travel_plans/:id" do |env| 
    body = env.request.body.as(IO).gets_to_end
    env.response.headers["Content-Type"] = "application/json"
    tp = Travel_plans_data.new
    response = tp.travel_plan_put(env.params.url["id"].to_i, body)   
    %(#{response.to_json})
  end 
end

Kemal.run