#!/bin/bash

sed -i 's/obitag_rank/rank/g' $1
sed -i 's/obitag_bestid/best_identity/g' $1
sed -i 's/obitag_bestmatch/best_match/g' $1
sed -i 's/\./-/g' $1
sed -i 's/; rank=/; superkingdom_name=None; kingdom_name=None; phylum_name=None; class_name=None; order_name=None; family_name=None; genus_name=None; species_name=None; species_list=[]; rank=/g' $1

obicsv --taxon --k rank --k best_identity --k scientific_name --k superkingdom_name --k kingdom_name --k phylum_name --k class_name --k order_name --k family_name --k genus_name --k species_name --k best_match --k species_list --k $1 > LZ01.ecotag.tab

sed -i 's/;,/,/g' LZ01.ecotag.tab
sed -i 's/,/;/g' LZ01.ecotag.tab

python3 scripts/addtax.py

sed -i 's/-/\./g' LZ01_ecotag.fasta.annotated.csv

rm LZ01.ecotag.tab
