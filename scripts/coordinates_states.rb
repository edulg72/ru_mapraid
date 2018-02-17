require 'pg'

if ARGV.size > 0
  step = ARGV[0].to_f
else
  step = 0.08
end

if ARGV.size > 1
  sigla = "and sigla = '#{ARGV[1]}' "
else
  sigla = nil
end

puts "#!/bin/bash\n\necho \"Start: $(date '+%d/%m/%Y %H:%M:%S')\"\n\ncase \"$3\" in"

db = PG::Connection.new(:hostaddr => '127.0.0.1', :dbname => 'ru_mapraid', :user => 'waze', :password => 'waze')
#db.prepare('box_state','select nl_name_1 from states_shapes where (ST_Overlaps(geom,ST_SetSRID(ST_MakeBox2D(ST_Point($1,$2),ST_Point($3,$4)),4326)) or ST_Contains(geom,ST_SetSRID(ST_MakeBox2D(ST_Point($1,$2),ST_Point($3,$4)),4326))) and id_1 = $5')

db.prepare('box_state','select nl_name_1 from states_shapes where (ST_Overlaps(geom,ST_SetSRID(ST_MakeBox2D(ST_Point($1,$2),ST_Point($3,$4)),4326)) or ST_Contains(geom,ST_SetSRID(ST_MakeBox2D(ST_Point($1,$2),ST_Point($3,$4)),4326)) or ST_Contains(ST_SetSRID(ST_MakeBox2D(ST_Point($1,$2),ST_Point($3,$4)),4326),geom)) and id_1 = $5')

db.exec("select id_1, hasc_1, name_1, nl_name_1, ST_Xmin(ST_Envelope(geom)) as lonwest, ST_Xmax(ST_Envelope(geom)) loneast, ST_Ymax(ST_Envelope(geom)) as latnorth, ST_Ymin(ST_Envelope(geom)) as latsouth from states_shapes where id_1 in (77,54,6,31,74,53,62,63,68,75,55)").each do |state|
  puts "# #{state['name_1']} - #{state['nl_name_1']}"
  puts "  #{state['hasc_1']})"
#  puts "#   [#{state['lonwest']},#{state['latnorth']} - #{state['loneast']},#{state['latsouth']}]"
  latIni = (state['latnorth'].to_f.round(2) + 0.01).round(8)
  while latIni > state['latsouth'].to_f
#    puts "Latitude: [#{latIni} #{(latIni - step).round(8)}]"
    area = false
    out = ''
    lonIni = (state['lonwest'].to_f.round(2) - 0.01).round(8)
    while lonIni < state['loneast'].to_f
#      puts "  Longitude: [#{lonIni} #{(lonIni + step).round(8)}] #{area}"
      if area
        if db.exec_prepared('box_state',[lonIni, (latIni - step).round(8), (lonIni + step).round(8), latIni, state['id_1']]).ntuples == 0
          area = false
          puts "#{out} #{lonIni} #{(latIni - step).round(8)} #{step}"
          out = ''
        end
      else
        if db.exec_prepared('box_state',[lonIni, (latIni - step).round(8), (lonIni + step).round(8), latIni, state['id_1']]).ntuples > 0
          area = true
          out = "    ruby scan_segments.rb $1 $2 #{lonIni} #{latIni}"
        end
      end
      lonIni = (lonIni + step).round(8)
    end
    if area
      puts "#{out} #{lonIni} #{(latIni - step).round(8)} #{step}"
    end
    latIni = (latIni - step).round(8)
  end
  puts "  ;;"
end
puts "  *)\n    echo \"Sintax: scan_segments.sh <user> <password> <state abbreviation>\"\n    exit 1\nesac\n"

puts "psql -h 127.0.0.1 -d ru_mapraid -U waze -c 'update segments set city_id = (select id_2 from cities_shapes where ST_Contains(geom, ST_SetSRID(ST_Point(segments.longitude, segments.latitude), 4326)) limit 1) where city_id is null;'"
puts "psql -h 127.0.0.1 -d ru_mapraid -U waze -c 'delete from segments where city_id is null;'"
puts "psql -h 127.0.0.1 -d ru_mapraid -U waze -c 'update segments set area_id = (select id from areas_mapraid where ST_Contains(geom, ST_SetSRID(ST_Point(segments.longitude, segments.latitude), 4326)) limit 1) where area_id is null'"
puts "psql -h 127.0.0.1 -d ru_mapraid -U waze -c 'delete from streets where id in (select id from streets except select distinct street_id from segments);'"
puts "psql -h 127.0.0.1 -d ru_mapraid -U waze -c 'update segments s1 set dc_density = (select count(*) from segments s2 where not s2.connected and s2.latitude between (s1.latitude - 0.01) and (s1.latitude + 0.01) and s2.longitude between (s1.longitude - 0.01) and (s1.longitude + 0.01)) where not s1.connected and s1.dc_density is null;'"
puts "psql -h 127.0.0.1 -d ru_mapraid -U waze -c \"update updates set updated_at = current_timestamp where object = '$3';\""
puts "psql -h 127.0.0.1 -d ru_mapraid -U waze -c 'refresh materialized view vw_segments; refresh materialized view vw_streets;'"
puts "psql -h 127.0.0.1 -d ru_mapraid -U waze -c 'vacuum analyze;'"
puts "End exec: $(date '+%d/%m/%Y %H:%M:%S')"
