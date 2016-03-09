require 'pg'

if ARGV.size > 0
  passo = ARGV[0].to_f
else
  passo = 0.08
end

if ARGV.size > 1
  sigla = "and sigla = '#{ARGV[1]}' "
else
  sigla = nil
end

puts "#!/bin/bash\n\necho \"Start: $(date '+%d/%m/%Y %H:%M:%S')\"\n\ncase \"$3\" in"

db = PG::Connection.new(:hostaddr => '127.0.0.1', :dbname => 'wazedb', :user => 'waze', :password => 'waze')
db.prepare('box_estado','select nl_name_1 from states_shapes where (ST_Overlaps(geom,ST_SetSRID(ST_MakeBox2D(ST_Point($1,$2),ST_Point($3,$4)),4326)) or ST_Contains(geom,ST_SetSRID(ST_MakeBox2D(ST_Point($1,$2),ST_Point($3,$4)),4326))) and id = $5')

db.exec("select id_1, hasc_1, nl_name_1, ST_Xmin(ST_Envelope(geom)) as longoeste, ST_Xmax(ST_Envelope(geom)) longleste, ST_Ymax(ST_Envelope(geom)) as latnorte, ST_Ymin(ST_Envelope(geom)) as latsul from countries_tmp").each do |estado|
  puts "# #{estado['nl_name_1']}"
  puts "  #{estado['hasc_1']})"
  puts "#   [#{estado['longoeste']},#{estado['latnorte']} - #{estado['longleste']},#{estado['latsul']}]"
  latIni = (estado['latnorte'].to_f.round(2) + 0.01).round(8)
  while latIni > estado['latsul'].to_f
#    puts "Latitude: [#{latIni} #{(latIni - passo).round(8)}]"
    area = false
    out = ''
    lonIni = (estado['longoeste'].to_f.round(2) - 0.01).round(8)
    while lonIni < estado['longleste'].to_f
#      puts "  Longitude: [#{lonIni} #{(lonIni + passo).round(8)}] #{area}"
      if area
        if db.exec_prepared('box_estado',[lonIni, (latIni - passo).round(8), (lonIni + passo).round(8), latIni, estado['id']]).ntuples == 0
          area = false
          puts "#{out} #{lonIni} #{(latIni - passo).round(8)} #{passo}"
          out = ''
        end
      else
        if db.exec_prepared('box_estado',[lonIni, (latIni - passo).round(8), (lonIni + passo).round(8), latIni, estado['id']]).ntuples > 0
          area = true
          out = "    ruby scan_segments.rb $1 $2 #{lonIni} #{latIni}"
        end
      end
      lonIni = (lonIni + passo).round(8)
    end
    latIni = (latIni - passo).round(8)
  end
  puts "  ;;"
end
puts "  *)\n    echo \"Sintax: scan_segments.sh <user> <password> <state abbreviation>\"\n    exit 1\nesac\n"

puts "psql -h 127.0.0.7 -d wazedb -U waze -c 'delete from segment where id in (select id from segment except select s.id from segment s, node n1, node n2 where s.tonodeid = n1.id and s.fromnodeid = n2.id)'\npsql -h 127.0.0.1 -d wazedb -U waze -c 'update segment set city_id = (select id from cities_shapes where ST_Contains(geom, ST_StartPoint(segment.geometry))) where city_id is null;'\npsql -h 127.0.0.1 -d wazedb -U waze -c 'refresh materialized view vw_segments;'\npsql -h 127.0.0.1 -d wazedb -U waze -c 'refresh materialized view vw_streets;'\npsql -h 127.0.0.1 -d wazedb -U waze -c \"update updates set updated_at = current_timestamp where object = 'segments';\"\n\necho \"End exec: $(date '+%d/%m/%Y %H:%M:%S')\""

