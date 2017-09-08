#!/bin/bash
#
# 'Andy Warhol'-like effect using ImageMagick
#
# Copyright (c) Vincent RICHARD, 2007
# vincent@vincent-richard.net
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of
# the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#

###################
#  CONFIGURATION  #
###################

# Quality for output image (if compressed)
QUALITY="90%"

# Define colors to be used in output image
# -- top-left quadrant
C1_B="#342b7c"
C1_G="#94c015"
C1_W="#fefc09"
# -- top-right quadrant
C2_B="#ee6807"
C2_G="#9ec038"
C2_W="#fff9a3"
# -- bottom-left quadrant
C3_B="#734995"
C3_G="#79bef9"
C3_W="#f58508"
# -- bottom-right quadrant
C4_B="#e60877"
C4_G="#fdf107"
C4_W="#0483ee"


############
#  SCRIPT  #
############

# Check arguments
if [ $# -ne 2 ]; then
	echo "Usage: $0 input-file output-file"
	exit 1
fi

# Reduce the number of colors to 3 (black, white and a level of gray).
# Store the output in a temporary file.
TEMP_FILE=`tempfile --suffix=.png`

convert "$1" -background white -flatten +matte -colorspace gray -colors 3 -colorspace rgb -type TrueColor -matte "$TEMP_FILE" \
	|| ( echo "$0: could not reduce colors in input image" ; exit 2 )

convert "$TEMP_FILE" -channel ALL -normalize "$TEMP_FILE" \
	|| ( echo "$0: could not normalize input image" ; rm -f "$TEMP_FILE" ; exit 3 )

# Extract histogram (list of colors) from the image.
# We are only interested in the gray color, so remove black and white lines.
HISTO=`convert "$TEMP_FILE" histogram:- | identify -format %c - | grep -vre "black\|white"`

# Ensure we got only one line
HISTO_LINES=`echo "$HISTO" | wc -l`

if [ $HISTO_LINES -eq 0 ]; then
	echo "$0: could not get histogram"
	rm -f "$TEMP_FILE"
	exit 4
fi

if [ $HISTO_LINES -ne 1 ]; then
	echo "$0: cannot extract colors from histogram"
	rm -f "$TEMP_FILE"
	exit 5
fi

# Extract the color from a line in the form:
#     105037: (119,119,119, 0) #77777700
# or: 32765: (163,163,163, 0) grey64
GRAY=`echo $HISTO | expand | sed 's/ /\n/g' | grep -E -m 1 "^(#[0-9a-zA-Z]{3,12}|[a-zA-Z][a-zA-Z0-9]+)$" | tr -d " \t"`

if [ -z "$GRAY" ]; then
	echo "$0: cannot extract gray color value"
	rm -f "$TEMP_FILE"
	exit 6
fi

# We can now set colors to replace
BLACK="#000000000000"
WHITE="#FFFFFFFFFFFF"
GRAY="$GRAY"

# Apply filter.
#
# * Step 1: apply median filter to get ride on small details
#
# * Step 2: repeat 4 times:
#  - clone the 3-color image ("TEMP_FILE")
#  - replace black, gray and white with their corresponding values Ci_B, Ci_G, Ci_W;
#    to do this we use "-fill TO_COLOR -opaque FROM_COLOR" command
#  - stack the resulting image after the previous one (2 columns, 2 rows)
#
# * Step 3: apply spread filter to "soften" edges

convert "$TEMP_FILE" -median 2 -fuzz 0% \( -clone 0 \( -clone 0 -fill "$C1_W" -opaque "$WHITE" -fill "$C1_G" -opaque "$GRAY" -fill "$C1_B" -opaque "$BLACK" \) \( -clone 0 -fill "$C2_W" -opaque "$WHITE" -fill "$C2_G" -opaque "$GRAY" -fill "$C2_B" -opaque "$BLACK" \) -delete 0 +append \) \( -clone 0 \( -clone 0 -fill "$C4_W" -opaque "$WHITE" -fill "$C4_G" -opaque "$GRAY" -fill "$C4_B" -opaque "$BLACK" \) +append \( -clone 0 -fill "$C3_W" -opaque "$WHITE" -fill "$C3_G" -opaque "$GRAY" -fill "$C3_B" -opaque "$BLACK" \) -delete 0 \) -delete 0 -append -spread 1 -quality $QUALITY "$2" \
	|| ( echo "$0: could not apply filter" ; rm -f "$TEMP_FILE" ; exit 7 )

# Delete temporary file
rm -f "$TEMP_FILE"

# Success
exit 0

