# pipeline_eDNA
The pipeline made for this study, working with OBiTools4 (released in 2023). The scripts starting with "owi" are modified versions of scripts by Owen S. Wangensteen (https://github.com/metabarpark/R_scripts_metabarpark) which are normally designed for OBitools2). addtax.sh rename.sh and tab.sh are scripts compatible with OBiTools4 written during this internship replacing some scripts by Owen S. Wangensteen
1. Filter the seqs by length and with no 'N':
      ```
      obigrep -l 140 -L 190 -s '^[ACGT]+$' --fasta-output --O ES2022_Lucas_12SU.filtered.fastq > LZ01.filtered_length.fasta
      ```
2. Group the unique seqs x
     ```
     obiuniq --O -m sample LZ01.filtered_length.fasta > LZ01.unique.fasta
     ```
2. Exchange the identifier to a short index (4 letters).
      ```
      bash scripts/rename.sh 'EV3PT:([0-9]+):([0-9]+)_SUB_SUB' LZAC
      ```
3. Remove chimaeras
  3.1. Change formats to VSEARCH
      ```
      Rscript scripts/owi_obifasta2vsearch -i LZ01.new.fasta -o LZ01.vsearch.fasta
      ```
  3.2 Run UCHIME de novo in VSEARCH
     ```
     vsearch --uchime_denovo LZ01.vsearch.fasta --sizeout --nonchimeras LZ01.nonchimeras.fasta --chimeras LZ01.chimeras.fasta --uchimeout LZ01.uchimeout.txt
     ```
4. Clustering using SWARM d=3
      ```
      swarm -d 3 -z -t 20 -o LZ01_SWARM3nc_output -s LZ01_Miya_SWARM3nc_stats -w LZ01_SWARM3nc_seeds.fasta LZ01.nonchimeras.fasta
      ```
5. Get the tab file:
      ```
      bash scripts/tab.sh LZ01.new.fasta ES2022_Lucas_12SU_file_format.csv
      ```
6. Recount after SWARM
      ```
      Rscript scripts/owi_recount_swarm LZ01_SWARM3nc_output LZ01.new.tab
      ```
7. Annotation with Ecotag
  7.1. Select only non singleton MOTUs.
      ```
      sed -i 's/;size=/; count=/g' LZ01_SWARM3nc_seeds.fasta
      obigrep -c 2 LZ01_SWARM3nc_seeds.fasta > LZ01_seeds_nonsingletons.fasta
      ```
  7..2 Annotation with Ecotag
      ```
      obitag -t /home/lamna/Bureau/Files_Lucas_12S/TAXA -R /home/lamna/Bureau/Files_Lucas_12S/TAXA/db_Eukarya_Miya2.fasta --O LZ01_seeds_nonsingletons.fasta > LZ01_ecotag.fasta
      ```
8. Add high-level taxa
      ```
      bash scripts/addtax.sh LZ01_ecotag.fasta
      ```
9. Combine ecotag and abundance files
      ```
      Rscript scripts/owi_combine -i LZ01_ecotag.fasta.annotated.csv -a LZ01_SWARM3nc_output.counts.csv -o LZ01.All_MOTUs.csv
      ```
10. Collapse MOTUs.
      ```
      Rscript scripts/owi_collapse -s 16 -e 108 -i LZ01.All_MOTUs.csv
      ```
