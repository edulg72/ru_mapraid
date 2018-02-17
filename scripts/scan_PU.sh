#!/bin/bash

cd /home/rails/ru_mapraid/scripts

echo "Start: $(date '+%d/%m/%Y %H:%M:%S')"
psql -h 127.0.0.1 -d ru_mapraid -U waze -c 'delete from pu; delete from places;'
psql -h 127.0.0.1 -d ru_mapraid -U waze -c 'vacuum pu;'
psql -h 127.0.0.1 -d ru_mapraid -U waze -c 'vacuum places;'

# Bashkortostan - Республика Башкортостан
    ruby scan_PU.rb $1 $2 53.63 56.57 59.63 56.07 0.5
    ruby scan_PU.rb $1 $2 53.63 56.07 60.13 55.57 0.5
    ruby scan_PU.rb $1 $2 53.13 55.57 59.63 55.07 0.5
    ruby scan_PU.rb $1 $2 53.13 55.07 60.13 54.57 0.5
    ruby scan_PU.rb $1 $2 53.13 54.57 60.13 54.07 0.5
    ruby scan_PU.rb $1 $2 53.13 54.07 59.63 53.57 0.5
    ruby scan_PU.rb $1 $2 53.63 53.57 59.13 53.07 0.5
    ruby scan_PU.rb $1 $2 54.63 53.07 59.13 52.57 0.5
    ruby scan_PU.rb $1 $2 55.13 52.57 59.13 52.07 0.5
    ruby scan_PU.rb $1 $2 56.63 52.07 59.13 51.57 0.5
    ruby scan_PU.rb $1 $2 57.13 51.57 57.63 51.07 0.5

# Kirov - Кировская область
    ruby scan_PU.rb $1 $2 46.82 61.08 48.82 60.58 0.5
    ruby scan_PU.rb $1 $2 46.32 60.58 48.82 60.08 0.5
    ruby scan_PU.rb $1 $2 50.82 60.58 53.82 60.08 0.5
    ruby scan_PU.rb $1 $2 46.32 60.08 53.82 59.58 0.5
    ruby scan_PU.rb $1 $2 46.82 59.58 54.32 59.08 0.5
    ruby scan_PU.rb $1 $2 46.32 59.08 54.32 58.58 0.5
    ruby scan_PU.rb $1 $2 46.32 58.58 53.82 58.08 0.5
    ruby scan_PU.rb $1 $2 46.32 58.08 52.32 57.58 0.5
    ruby scan_PU.rb $1 $2 46.32 57.58 51.82 57.08 0.5
    ruby scan_PU.rb $1 $2 46.32 57.08 48.32 56.58 0.5
    ruby scan_PU.rb $1 $2 48.82 57.08 51.82 56.58 0.5
    ruby scan_PU.rb $1 $2 50.32 56.58 51.82 56.08 0.5

# Orenburg - Оренбургская область
    ruby scan_PU.rb $1 $2 51.83 54.4 53.83 53.9 0.5
    ruby scan_PU.rb $1 $2 51.83 53.9 54.83 53.4 0.5
    ruby scan_PU.rb $1 $2 51.83 53.4 55.33 52.9 0.5
    ruby scan_PU.rb $1 $2 51.33 52.9 56.83 52.4 0.5
    ruby scan_PU.rb $1 $2 58.83 52.9 60.33 52.4 0.5
    ruby scan_PU.rb $1 $2 50.83 52.4 56.83 51.9 0.5
    ruby scan_PU.rb $1 $2 58.33 52.4 60.33 51.9 0.5
    ruby scan_PU.rb $1 $2 50.83 51.9 61.83 51.4 0.5
    ruby scan_PU.rb $1 $2 53.33 51.4 61.83 50.9 0.5
    ruby scan_PU.rb $1 $2 53.83 50.9 56.33 50.4 0.5
    ruby scan_PU.rb $1 $2 57.33 50.9 57.83 50.4 0.5
    ruby scan_PU.rb $1 $2 58.33 50.9 61.83 50.4 0.5

# Penza - Пензенская область
    ruby scan_PU.rb $1 $2 42.1 54.02 46.6 53.52 0.5
    ruby scan_PU.rb $1 $2 42.1 53.52 47.1 53.02 0.5
    ruby scan_PU.rb $1 $2 42.6 53.02 47.1 52.52 0.5
    ruby scan_PU.rb $1 $2 43.1 52.52 46.1 52.02 0.5

# Perm' - Пермская край
    ruby scan_PU.rb $1 $2 55.76 61.71 59.76 61.21 0.5
    ruby scan_PU.rb $1 $2 51.76 61.21 59.76 60.71 0.5
    ruby scan_PU.rb $1 $2 51.76 60.71 59.76 60.21 0.5
    ruby scan_PU.rb $1 $2 52.26 60.21 59.26 59.71 0.5
    ruby scan_PU.rb $1 $2 52.76 59.71 59.26 59.21 0.5
    ruby scan_PU.rb $1 $2 53.26 59.21 59.76 58.71 0.5
    ruby scan_PU.rb $1 $2 53.26 58.71 59.76 58.21 0.5
    ruby scan_PU.rb $1 $2 53.76 58.21 59.26 57.71 0.5
    ruby scan_PU.rb $1 $2 53.76 57.71 58.76 57.21 0.5
    ruby scan_PU.rb $1 $2 53.76 57.21 58.26 56.71 0.5
    ruby scan_PU.rb $1 $2 53.76 56.71 57.76 56.21 0.5
    ruby scan_PU.rb $1 $2 56.26 56.21 57.26 55.71 0.5

# Samara - Самарская область
    ruby scan_PU.rb $1 $2 49.98 54.69 52.98 54.19 0.5
    ruby scan_PU.rb $1 $2 47.98 54.19 52.48 53.69 0.5
    ruby scan_PU.rb $1 $2 47.98 53.69 52.48 53.19 0.5
    ruby scan_PU.rb $1 $2 47.98 53.19 52.48 52.69 0.5
    ruby scan_PU.rb $1 $2 47.98 52.69 51.98 52.19 0.5
    ruby scan_PU.rb $1 $2 49.48 52.19 51.48 51.69 0.5

# Saratov - Саратовская область
    ruby scan_PU.rb $1 $2 42.54 52.84 50.04 52.34 0.5
    ruby scan_PU.rb $1 $2 42.54 52.34 51.04 51.84 0.5
    ruby scan_PU.rb $1 $2 42.54 51.84 51.04 51.34 0.5
    ruby scan_PU.rb $1 $2 42.54 51.34 50.54 50.84 0.5
    ruby scan_PU.rb $1 $2 45.04 50.84 49.54 50.34 0.5
    ruby scan_PU.rb $1 $2 47.54 50.34 49.04 49.84 0.5
    ruby scan_PU.rb $1 $2 48.04 49.84 48.54 49.34 0.5

# Tatarstan - Республика Татарстан
    ruby scan_PU.rb $1 $2 48.77 56.72 51.27 56.22 0.5
    ruby scan_PU.rb $1 $2 52.27 56.72 53.77 56.22 0.5
    ruby scan_PU.rb $1 $2 47.77 56.22 54.27 55.72 0.5
    ruby scan_PU.rb $1 $2 47.27 55.72 54.27 55.22 0.5
    ruby scan_PU.rb $1 $2 47.27 55.22 53.77 54.72 0.5
    ruby scan_PU.rb $1 $2 47.27 54.72 53.77 54.22 0.5
    ruby scan_PU.rb $1 $2 52.77 54.22 53.77 53.72 0.5

# Udmurt - Удмуртская Республика
    ruby scan_PU.rb $1 $2 51.6 58.55 54.1 58.05 0.5
    ruby scan_PU.rb $1 $2 51.6 58.05 54.6 57.55 0.5
    ruby scan_PU.rb $1 $2 51.1 57.55 54.6 57.05 0.5
    ruby scan_PU.rb $1 $2 51.1 57.05 54.6 56.55 0.5
    ruby scan_PU.rb $1 $2 51.1 56.55 54.6 56.05 0.5
    ruby scan_PU.rb $1 $2 51.1 56.05 54.1 55.55 0.5

# Ul'yanovsk - Ульяновская область
    ruby scan_PU.rb $1 $2 46.34 54.91 50.34 54.41 0.5
    ruby scan_PU.rb $1 $2 45.84 54.41 50.34 53.91 0.5
    ruby scan_PU.rb $1 $2 45.84 53.91 50.34 53.41 0.5
    ruby scan_PU.rb $1 $2 46.34 53.41 48.84 52.91 0.5
    ruby scan_PU.rb $1 $2 46.34 52.91 48.84 52.41 0.5

# Volgograd - Волгоградская область
    ruby scan_PU.rb $1 $2 41.27 51.26 46.27 50.76 0.5
    ruby scan_PU.rb $1 $2 41.27 50.76 47.77 50.26 0.5
    ruby scan_PU.rb $1 $2 41.27 50.26 47.77 49.76 0.5
    ruby scan_PU.rb $1 $2 41.77 49.76 47.27 49.26 0.5
    ruby scan_PU.rb $1 $2 41.77 49.26 47.27 48.76 0.5
    ruby scan_PU.rb $1 $2 41.77 48.76 46.77 48.26 0.5
    ruby scan_PU.rb $1 $2 41.77 48.26 45.77 47.76 0.5
    ruby scan_PU.rb $1 $2 42.27 47.76 44.27 47.26 0.5

psql -h 127.0.0.1 -d ru_mapraid -U waze -c 'update pu set area_id = (select id from areas_mapraid where ST_Contains(geom, pu.position) limit 1) where area_id is null;'
psql -h 127.0.0.1 -d ru_mapraid -U waze -c 'delete from pu where area_id is null;'
psql -h 127.0.0.1 -d ru_mapraid -U waze -c 'refresh materialized view vw_pu;'
psql -h 127.0.0.1 -d ru_mapraid -U waze -c "update updates set updated_at = current_timestamp where object = 'pu';"
psql -h 127.0.0.1 -d ru_mapraid -U waze -c 'vacuum pu;'

echo "End: $(date '+%d/%m/%Y %H:%M:%S')"
