#!/bin/bash

echo "Start: $(date '+%d/%m/%Y %H:%M:%S')"

for state in RU.VG RU.PZ RU.BK RU.KV RU.UD RU.OB RU.SA RU.SR RU.TT RU.UL RU.PE
do
  echo "  $state: $(date '+%d/%m/%Y %H:%M:%S')"
  /home/rails/ru_mapraid/scripts/scan_segments.sh $1 $2 $state
done

echo "End: $(date '+%d/%m/%Y %H:%M:%S')"
