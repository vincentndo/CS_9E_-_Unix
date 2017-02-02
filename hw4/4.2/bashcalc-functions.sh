#!/bin/bash
# Bash Calculator Framework
# CS9E - Assignment 4.1
#
# Framework by Jeremy Huddleston <jeremyhu@cs.berkeley.edu>
# $LastChangedDate: 2007-10-11 15:49:54 -0700 (Thu, 11 Oct 2007) $
# $Id: bashcalc-fw.sh 88 2007-10-11 22:49:54Z selfpace $

## Floating Point Math Functions ##

# bashcalc <expression>
# This function simply passes in the given expressions to 'bc -l' and prints the result
function bashcalc {
	# ADD CODE HERE FOR PART 2
	ret=$(echo "scale=16; $1" | bc -l)
	echo $ret
}

# Remove this line when you start part 3
# return 0

# sine <expression>
# This function prints the cosine of the given expression
function sine {
	# ADD CODE HERE FOR PART 3
	ret=$(echo "scale=16; s($(bashcalc $1))" | bc -l)
	echo $ret
}

# cosine <expression>
# This function prints the cosine of the given expression
function cosine {
	# ADD CODE HERE FOR PART 3
	ret=$(echo "scale=16; c($(bashcalc $1))" | bc -l)
	echo $ret
}

# angle_reduce <angle>
# Prints the angle given expressed as a value between 0 and 2pi
function angle_reduce {
	# ADD CODE HERE FOR PART 3
	TWO_PI=$(echo "scale=16; 8*a(1)" | bc -l)
	ret=$1
	condition1=$(echo "$ret < 0" | bc)
	condition2=$(echo "$ret >= $TWO_PI" | bc)
	while [ $condition1 == 1 ] || [ $condition2 == 1 ]   # = == -eq are the same
	do
		if [ $condition1 == 1 ]
			then
			ret=$(echo "scale=16; $ret + $TWO_PI" | bc)
		else
			ret=$(echo "scale=16; $ret - $TWO_PI" | bc)
		fi
		condition1=$(echo "$ret < 0" | bc)
		condition2=$(echo "$ret >= $TWO_PI" | bc)
	done
	echo $ret
}

# float_{lt,lte,eq} <expr 1> <expr 2>
# These functions returns true (exit code 0) if the first value is less than the second (lt),
# less than or equal to the second (lte), or equal to the second (eq).
# Note: We can't just use BASH's builtin [[ ... < ... ]] operator because that is
#       for integer math.
function float_lt {
	# ADD CODE HERE FOR PART 3
	var1=$(bashcalc $1)
	var2=$(bashcalc $2)
	condition=$(echo "$var1 < $var2" | bc)
	if [ $condition == 1 ]
		then
		# echo "true"
		return 0
	else
		# echo "false"
		return 1
	fi
}

function float_eq {
	# ADD CODE HERE FOR PART 3
	var1=$(bashcalc $1)
	var2=$(bashcalc $2)
	condition=$(echo "$var1 == $var2" | bc)
	if [ $condition == 1 ]
		then
		# echo "true"
		return 0
	else
		# echo "false"
		return 1
	fi
}

function float_lte {
	# ADD CODE HERE FOR PART 3
	var1=$(bashcalc $1)
	var2=$(bashcalc $2)
	condition=$(echo "$var1 <= $var2" | bc)
	if [ $condition -eq 1 ]
		then
		# echo "true"
		return 0
	else
		# echo "false"
		return 1
	fi
}
