i=1
while read -r line; do     if [[ "$line" =~ ^\>$1(.*) ]]; then         new_line=">$2_$(printf "%010d" $i)${BASH_REMATCH[3]}";         i=$((i+1));     else new_line="$line";     fi;     echo "$new_line"; done < LZ01.unique.fasta > LZ01.new.fasta
