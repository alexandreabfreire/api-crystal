require "kemal"
require "mysql"
require "../models/plan"
require "../models/integration"
require "../models/location"
require "json" 
require "http/client"

class Travel_plans_data

  def uri 
    return URI.parse("https://rickandmortyapi.com") # api de Rick and Morty para consulta graphql
  end

  def client 
    return HTTP::Client.new(uri)  
  end
  
  def con 
    return "mysql://root:secret@172.28.1.1:3306/travel_plan" # rede privada para os containers
  end

  # Integração api Rick and Morty
  def start_integration(data : String)
    response = client.post("/graphql", headers: HTTP::Headers{"Content-Type" => "application/json", "Accept" => "*/*"}, body: %({"query":"{ locationsByIds(ids: #{data}) { id name type dimension residents { name episode { name } } } }"}))
    root = Integrations.from_json(response.body)
    rick_and_morty_post(root.data.locationsByIds, response.body);    
  end

  # Ler registo de um plano de viagem na tabela plan de travel_plan em MySql
  def travel_plan_get_from(id : Int32)     
    plan = Plan.new
    db = DB.open con
    begin
      db.query "select a.id, b.location_id from plan a inner join plan_stop b on b.plan_id = a.id where a.id = #{id} order by b.id" do |rs|
        rs.each do          
          plan.id = rs.read(Int32)
          plan.travel_stops.push(rs.read(Int32))
        end
      end
    ensure
      db.close
    end    
    return plan
  end

  # Ler todos os locais armazenados 
  def travel_plan_get_all_location()     
    arr = Array(Int32).new
    db = DB.open con
    begin
      db.query "select distinct location_id from plan_stop order by location_id" do |rs|
        rs.each do          
          arr.push(rs.read(Int32))
        end
      end
    ensure
      db.close
    end    
    return arr.to_json
  end

  # Incluir registo de um plano de viagem na tabela plan 
  def travel_plan_post(request : String)
    plan = Plan.new
    id = 0
    db = DB.open con
    begin
      db.exec "insert into plan (id) values(NULL)"
      db.query "select LAST_INSERT_ID()" do |rs|
        rs.each do          
          id = rs.read(Int64).to_i
        end
      end
      array = Array(Int32).new
      string = JSON.parse(request)["travel_stops"].to_s
      array = string.sub("[","").sub("]","").split(",")
      array.each do |l|
        db.exec "insert into plan_stop (plan_id, location_id) values( #{id}, #{l})"
      end
    ensure
      db.close
    end
    plan = travel_plan_get_from(id)
    return plan
  end

  # Modificar registo de um plano de viagem na tabela plan 
  def travel_plan_put(id : Int32, request : String)
    plan = Plan.new
    travel_plan_delete_stops(id)
    db = DB.open con
    begin
      array = Array(Int32).new
      string = JSON.parse(request)["travel_stops"].to_s
      array = string.sub("[","").sub("]","").split(",")
      array.each do |l|
        db.exec "insert into plan_stop (plan_id, location_id) values( #{id}, #{l})"
      end
    ensure
      db.close
    end
    plan = travel_plan_get_from(id)
    return plan
  end

  # Remover registo de um plano de viagem na tabela plan 
  def travel_plan_delete(id : Int32)
    db = DB.open con
    begin
      db.exec "delete from plan where id = #{id}"
    ensure
      db.close
    end
  end  

  # Remover paradas na tabela plan_stop 
  def travel_plan_delete_stops(id : Int32)
    db = DB.open con
    begin
      db.exec "delete from plan_stop where plan_id = #{id}"
    ensure
      db.close
    end
  end

  # Incluir dados temporários em travel_plan calculando a popularidade para ordenação 
  def rick_and_morty_post(root : Array(LocationsById), request : String)
    aux_qte_episode = Array(Int32).new
    qte_episode = 0
    qte_residents = 0
    qte_location = JSON.parse(request)["data"]["locationsByIds"].size
    x = 0
    while (x < qte_location)
      qte_residents = JSON.parse(request)["data"]["locationsByIds"][x]["residents"].size
      qte_episode = 0
      y = 0
      while (y < qte_residents)
        qte_episode += JSON.parse(request)["data"]["locationsByIds"][x]["residents"][y]["episode"].size
        y = y + 1
      end
      aux_qte_episode.push(qte_episode)
      x = x + 1
    end
    db = DB.open con
    begin
      db.exec "delete from location_temp"
      i = 0
      root.each do |x|
        puts x.id
        db.exec "insert into location_temp (id, nome, type, dimension, popularidade, media) values(#{x.id.to_i}, \"#{x.name}\", \"#{x.type}\", \"#{x.dimension}\", #{aux_qte_episode[i]}, 0)"
        i  = i + 1
      end
      db.query "select dimension, sum(popularidade)/count(*) from location_temp GROUP BY dimension" do |rs|
        rs.each do          
          dimension = rs.read(String)          
          media = rs.read(Float64)
          db.exec "update location_temp set media = #{media} where dimension = \"#{dimension}\""
        end
      end
    ensure
      db.close
    end
  end

  # Retornar o os dados expandidos de um plano de viagem de travel_plan no formato json
  def expand_true_by_id(id : Int32, string optimize)
    db = DB.open con
    string = JSON.build do |json|
      json.object do
        json.field "id", id
        json.field "travel_stops" do 
          json.array do
            db.query "select a.id, a.nome, a.type, a.dimension from location_temp a inner join plan_stop b on b.location_id = a.id where b.plan_id = #{id} order by #{(optimize == "false") ? "b.plan_id, b.id" : "b.plan_id, a.media, a.dimension, a.popularidade, a.nome"}" do |rs|
              rs.each do                  
                json.object do
                  json.field "id", rs.read(Int32)
                  json.field "name", rs.read(String)
                  json.field "type", rs.read(String)
                  json.field "dimension", rs.read(String)
                end
              end
            end
          end
        end
      end
    end  
    return string
  end

  # Retornar o os dados de um plano de viagem de travel_plan no formato json
  def expand_false_by_id(id : Int32, string optimize)
    db = DB.open con
    string = JSON.build do |json|
      json.object do
        json.field "id", id
        json.field "travel_stops" do   
          json.array do
            db.query "select a.id from location_temp a inner join plan_stop b on b.location_id = a.id where b.plan_id = #{id} order by #{(optimize == "false") ? "b.plan_id, b.id" : "b.plan_id, a.media, a.dimension, a.popularidade, a.nome"}" do |rs|
              rs.each do                  
                json.number rs.read(Int32)
              end
            end
          end
        end
      end
    end  
    return string
  end

  # Retornar o os dados expandidos de todos os planos de viagem de travel_plan no formato json
  def expand_true(string optimize)
    db = DB.open con
    string = JSON.build do |json|
      json.array do
        db.query "select id from plan order by id" do |rs_id|
          rs_id.each do   
            json.object do
              id = rs_id.read(Int32)              
              json.field "id", id
              json.field "travel_stops" do  
                json.array do                  
                  db.query "select a.id, a.nome, a.type, a.dimension from location_temp a inner join plan_stop b on b.location_id = a.id where b.plan_id = #{id} order by #{(optimize == "false") ? "b.plan_id, b.id" : "b.plan_id, a.media, a.dimension, a.popularidade, a.nome"}" do |rs|
                    rs.each do                  
                      json.object do
                        json.field "id", rs.read(Int32)
                        json.field "name", rs.read(String)
                        json.field "type", rs.read(String)
                        json.field "dimension", rs.read(String)                        
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end  
    return string
  end  

  # Retornar o os dados de todos os planos de viagem de travel_plan no formato json
  def expand_false(string optimize)
    db = DB.open con
    string = JSON.build do |json|
      json.array do       
          db.query "select id from plan order by id" do |rs_id|
            rs_id.each do   
              json.object do
                id = rs_id.read(Int32)              
                json.field "id", id
                json.field "travel_stops" do  
                  json.array do                                      
                    db.query "select a.id from location_temp a inner join plan_stop b on b.location_id = a.id where b.plan_id = #{id} order by #{(optimize == "false") ? "b.plan_id, b.id" : "b.plan_id, a.media, a.dimension, a.popularidade, a.nome"}" do |rs|
                      rs.each do
                        json.number rs.read(Int32)                    
                    end
                  end
                end
              end
            end
          end
        end
      end
    end  
    return string
  end  
end