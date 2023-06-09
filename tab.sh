sed -i 's/{//g' $1
sed -i 's/}//g' $1
sed -i "s/'//g" $1
sed -i 's/:/=/g' $1
sed -i 's/merged_sample=/merged_sample_/g' $1
sed -i 's/,18Sve/; merged_sample_18Sve/g' $1

samples=$(tail -n +3 $2 | cut -d ';' -f 1 | sed '/^\s*$/d' | tr '\n' ' ' | sed 's/ / --k merged_sample_/g;s/ --k merged_sample_$//' | sed '1s/^/--k merged_sample_/')


obicsv --k avg_quality --k count --k direction --k experiment --k forward_match --k forward_primer --k forward_score --k forward_tag --k head_quality $samples --k seq_length LZ01.new.fasta > LZ01.new.tab

sed -i 's/NA/0/g' LZ01.new.tab
sed -i 's/,/\t/g' LZ01.new.tab
sed -i 's/merged_sample_/sample:/g' LZ01.new.tab


