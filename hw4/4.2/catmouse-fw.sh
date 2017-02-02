#!/bin/bash
# Cat & Mouse Framework
# CS9E - Assignment 4.2
#
# Framework by Jeremy Huddleston <jeremyhu@cs.berkeley.edu>
# $LastChangedDate: 2007-10-11 15:49:54 -0700 (Thu, 11 Oct 2007) $
# $Id: catmouse-fw.sh 88 2007-10-11 22:49:54Z selfpace $

# Source the file containing your calculator functions:
. bashcalc-functions.sh

# Additional math functions:

# angle_between <A> <B> <C>
# Returns true (exit code 0) if angle B is between angles A and C and false otherwise
function angle_between {
	local A=$1
	local B=$2
	local C=$3

	# ADD CODE HERE FOR PART 1
	if (float_lt "c($C-$A)" "c($B-$A)") && (float_lt "c($C-$A)" "c($C-$B)") # omitting parentheses works
		then
		# echo "between"
		return 0
	else
		# echo "no between"
		return 1
	fi
}

### Simulation Functions ###
# Variables for the state
RUNNING=0
GIVEUP=1
CAUGHT=2

# does_cat_see_mouse <cat angle> <cat radius> <mouse angle>
#
# Returns true (exit code 0) if the cat can see the mouse, false otherwise.
#
# The cat sees the mouse if
# (cat radius) * cos (cat angle - mouse angle)
# is at least 1.0.
function does_cat_see_mouse {
	local cat_angle=$1
	local cat_radius=$2
	local mouse_angle=$3

	# ADD CODE HERE FOR PART 1
	# local cosine_catAngle_mouseAngle=$(cosine "$cat_angle-$mouse_angle")
	if float_lte 1 "$cat_radius*c($cat_angle-($mouse_angle))"
		then
		# echo "see"
		return 0
	else
		# echo "no see"
		return 1
	fi
}

# next_step <current state> <current step #> <cat angle> <cat radius> <mouse angle> <max steps>
# returns string output similar to the input, but for the next step:
# <state at next step> <next step #> <cat angle> <cat radius> <mouse angle> <max steps>
#
# exit code of this function (return value) should be the state at the next step.  This allows for easy
# integration into a while loop.
function next_step {
	local state=$1
	local -i step=$2
	local old_cat_angle=$3
	local old_cat_radius=$4
	local old_mouse_angle=$5
	local -i max_steps=$6

	local new_cat_angle=${old_cat_angle}
	local new_cat_radius=${old_cat_radius}
	local new_mouse_angle=${old_mouse_angle}

	# First, make sure we are still running
	if (( ${state} != ${RUNNING} )) ; then
		echo ${state} ${step} ${old_cat_angle} ${old_cat_radius} ${old_mouse_angle} ${max_steps}
		return ${state}
	fi

	# ADD CODE HERE FOR PART 2
	
	# Move the cat first
	if (float_lt 1 $old_cat_radius) && (does_cat_see_mouse $old_cat_angle $old_cat_radius $old_mouse_angle) ; then
		# Move the cat in if it's not at the statue and it can see the mouse
		new_cat_radius=$(bashcalc "$new_cat_radius-1")
		if float_lt $new_cat_radius 1
			then
			new_cat_radius=1
		fi
	else
		# Move the cat around if it's at the statue or it can't see the mouse
		# Check if the cat caught the mouse
		new_cat_angle=$(bashcalc "$old_cat_angle+1.25/$old_cat_radius")
		if float_eq 1 $old_cat_radius && angle_between $old_cat_angle $old_mouse_angle $new_cat_angle
			then
			state=$CAUGHT
			# return ${state}
		fi
	fi

	# Now move the mouse if it wasn't caught
	# if ______ ; then
		# Move the mouse
		new_mouse_angle=$(bashcalc "$new_mouse_angle+1")

		# Give up if we're at the last step and haven't caught the mouse
		if [[ $step -eq $max_steps ]] ; then
			state=$GIVEUP
			# return ${state}
		fi
	# fi
	step+=1

	echo ${state} ${step} ${new_cat_angle} ${new_cat_radius} ${new_mouse_angle} ${max_steps}
	return ${state}
}

### Main Script ###

if [[ ${#} != 4 ]] ; then
	echo "$0: usage" >&2
	echo "$0 <cat angle> <cat radius> <mouse angle> <max steps>" >&2
	exit 1
fi

# ADD CODE HERE FOR PART 3
state=0
declare -i step=0
cat_angle=$(bashcalc $1)
cat_radius=$2
mouse_angle=$(bashcalc $3)
declare -i max_steps=$4

echo state step cat_angle cat_radius mouse_angle max_steps
echo ${state} ${step} ${cat_angle} ${cat_radius} ${mouse_angle} ${max_steps}

# cat_angle=$(angle_reduce $cat_angle)
# mouse_angle=$(angle_reduce $mouse_angle)

while float_lte $step $max_steps && [ $state -eq $RUNNING ] ; do
	# read one two three four five six <<<$(next_step $state $step $cat_angle $cat_radius $mouse_angle $max_steps)
	# echo "state = $one"
	# echo "step = $two"
	# echo "cat_angle = $three"
	# echo "cat_radius = $four"
	# echo "mouse_angle = $five"
	# echo "max_steps = six"
	
	retval=$(next_step $state $step $cat_angle $cat_radius $mouse_angle $max_steps)
	state=`echo "$retval" | awk '{print $1}'`
	step=`echo "$retval" | awk '{print $2}'`
	cat_angle=`echo "$retval" | awk '{print $3}'`
	cat_radius=`echo "$retval" | awk '{print $4}'`
	mouse_angle=`echo "$retval" | awk '{print $5}'`
	max_steps=`echo "$retval" | awk '{print $6}'`
	if [ $state -eq $GIVEUP ]
		then
		echo "Cat is tired. Give up!"
	elif [ $state -eq $CAUGHT ]
		then
		echo "Hooray! Cat catches mouse at step $step."
	else
		echo $retval
	fi
done
