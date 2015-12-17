

ls *.png | while read source
do
	echo "Working on $source"
	for adjust in 1 2 3 4 5 6 7 8 9 10
	do
		basename=`basename $source | cut -d'.' -f1`
        ((brightness=$adjust \* 2))
		convert $source -brightness-contrast -$brightness gen/$basename-$adjust.png
	done
done