#!/bin/bash

# gallery.sh
# Author: Nils Knieling - https://github.com/Cyclenerd/gallery_shell
# Inspired by: Shapor Naghibzadeh - https://github.com/shapor/bashgal
# Modified by wzwtt on November 12, 2022.

#########################################################################################
#The modified functions of wzwtt are as follows: make the input/output directory 
#changeable; The generated image can be easily loaded using CDNs such as jsdelivr; 
#Add PNG format picture support; Sinicization; Use Beijing time zone time; CNAME 
#files are automatically exported.
#########################################################################################

#########################################################################################
#### Configuration Section
#########################################################################################

MY_HEIGHT_SMALL=187
MY_HEIGHT_LARGE=768
MY_QUALITY=85
MY_THUMBDIR="thumbs"
INPUT="$(pwd)/still"
OUTPUT="$(pwd)/../output"
SOURCE_IMGURL="https://gcore.jsdelivr.net/gh/wzwtt/ikun@master/still/"   ##"$INPUT/"   ## must end with "/"
VIEW_IMGURL="https://gcore.jsdelivr.net/gh/wzwtt/ikun@gallery/"  ## must end with "/"
MY_INDEX_HTML_FILE="index.html"
MY_TITLE="IKUN 表情包大全 - 坤图大全"
MY_FOOTER='本页面自动生成于'
CNAME="ikun.wzwtt.cf"

# Use convert from ImageMagick
MY_CONVERT_COMMAND="convert" 
# Use JHead for EXIF Information
MY_EXIF_COMMAND="jhead"

# Bootstrap 4
MY_CSS="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css"

# Debugging output
# true=enable, false=disable 
MY_DEBUG=true

#########################################################################################
#### End Configuration Section
#########################################################################################


MY_SCRIPT_NAME=$(basename "$0")
MY_DATETIME=$(TZ=UTC-8 date +%Y-%m-%d" "%H:%M:%S)
MY_DATETIME+=" UTC+8"

function usage {
	MY_RETURN_CODE="$1"
	echo -e "Usage: $MY_SCRIPT_NAME [-t <title>] [-d <thumbdir>] [-h]:
	[-t <title>]\\t sets the title (default: $MY_TITLE)
	[-d <thumbdir>]\\t sets the thumbdir (default: $MY_THUMBDIR)
	[-h]\\t\\t displays help (this message)"
	exit "$MY_RETURN_CODE"
}

function debugOutput(){
	if [[ "$MY_DEBUG" == true ]]; then
		echo "$1" # if debug variable is true, echo whatever's passed to the function
	fi
}

function getFileSize(){
	# Be aware that BSD stat doesn't support --version and -c
	if stat --version &>/dev/null; then
		# GNU
		MY_FILE_SIZE=$(stat -c %s "$1" | awk '{$1/=1000000;printf "%.2fMB\n",$1}')
	else
		# BSD
		MY_FILE_SIZE=$(stat -f %z "$1" | awk '{$1/=1000000;printf "%.2fMB\n",$1}')
	fi
	echo "$MY_FILE_SIZE"
}

while getopts ":t:d:h" opt; do
	case $opt in
	t)
		MY_TITLE="$OPTARG"
		;;
	d)
		MY_THUMBDIR="$OPTARG"
		;;
	h)
		usage 0
		;;
	*)
		echo "Invalid option: -$OPTARG"
		usage 1
		;;
	esac
done

debugOutput "- $MY_SCRIPT_NAME : $MY_DATETIME"
debugOutput $INPUT
debugOutput $OUTPUT

### Check InputDir
if [ ! -d "$INPUT" ];then
  echo "The input directory does not exist."
  exit 1;
fi

### Check Commands
command -v $MY_CONVERT_COMMAND >/dev/null 2>&1 || { echo >&2 "!!! $MY_CONVERT_COMMAND it's not installed.  Aborting."; exit 1; }
command -v $MY_EXIF_COMMAND >/dev/null 2>&1 || { echo >&2 "!!! $MY_EXIF_COMMAND it's not installed.  Aborting."; exit 1; }

### Create Folders
[[ -d "$OUTPUT" ]] || mkdir "$OUTPUT" || exit 2
[[ -d "$OUTPUT/$MY_THUMBDIR" ]] || mkdir "$OUTPUT/$MY_THUMBDIR" || exit 2

MY_HEIGHTS[0]=$MY_HEIGHT_SMALL
MY_HEIGHTS[1]=$MY_HEIGHT_LARGE
for MY_RES in ${MY_HEIGHTS[*]}; do
	[[ -d "$OUTPUT/$MY_THUMBDIR/$MY_RES" ]] || mkdir -p "$OUTPUT/$MY_THUMBDIR/$MY_RES" || exit 3
done

### Create CNAME file
echo $CNAME >> CNAME

#### Create Startpage
debugOutput "$OUTPUT/$MY_INDEX_HTML_FILE"
cat > "$OUTPUT/$MY_INDEX_HTML_FILE" << EOF
<!DOCTYPE HTML>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title>$MY_TITLE</title>
	<link rel="shortcut icon" href="favicon.ico">
	<meta name="viewport" content="width=device-width">
	<meta name="robots" content="noindex, nofollow">
	<link rel="stylesheet" href="$MY_CSS">
</head>
<body>
<header>
	<div class="navbar navbar-dark bg-dark shadow-sm">
		<div class="container">
			<a href="#" class="navbar-brand">
				<strong>$MY_TITLE</strong>
				<a href="https://github.com/wzwtt/ikun" target="_blank" class="mdui-btn mdui-btn-icon mdui-ripple mdui-ripple-white" mdui-tooltip="{content: '在 GitHub 上查看本项目'}">
                   <svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 36 36" enable-background="new 0 0 36 36" xml:space="preserve" class="mdui-icon" style="width: 24px;height:24px;">
                      <path fill-rule="evenodd" clip-rule="evenodd" fill="#ffffff" d="M18,1.4C9,1.4,1.7,8.7,1.7,17.7c0,7.2,4.7,13.3,11.1,15.5
  c0.8,0.1,1.1-0.4,1.1-0.8c0-0.4,0-1.4,0-2.8c-4.5,1-5.5-2.2-5.5-2.2c-0.7-1.9-1.8-2.4-1.8-2.4c-1.5-1,0.1-1,0.1-1
  c1.6,0.1,2.5,1.7,2.5,1.7c1.5,2.5,3.8,1.8,4.7,1.4c0.1-1.1,0.6-1.8,1-2.2c-3.6-0.4-7.4-1.8-7.4-8.1c0-1.8,0.6-3.2,1.7-4.4
  c-0.2-0.4-0.7-2.1,0.2-4.3c0,0,1.4-0.4,4.5,1.7c1.3-0.4,2.7-0.5,4.1-0.5c1.4,0,2.8,0.2,4.1,0.5c3.1-2.1,4.5-1.7,4.5-1.7
  c0.9,2.2,0.3,3.9,0.2,4.3c1,1.1,1.7,2.6,1.7,4.4c0,6.3-3.8,7.6-7.4,8c0.6,0.5,1.1,1.5,1.1,3c0,2.2,0,3.9,0,4.5
  c0,0.4,0.3,0.9,1.1,0.8c6.5-2.2,11.1-8.3,11.1-15.5C34.3,8.7,27,1.4,18,1.4z"></path>
                   </svg>
                </a>
			</a>
		</div>
	</div>
</header>
<main class="container">
EOF

### Photos
if [[ $(find $INPUT -maxdepth 1 -type f -name \*.jpg -o -name \*.png | wc -l) -gt 0 ]]; then

echo '<div class="row row-cols-sm-1 row-cols-md-2 row-cols-lg-3 row-cols-xl-4 py-5">' >> "$OUTPUT/$MY_INDEX_HTML_FILE"
## Generate Images
cd $INPUT
MY_NUM_FILES=0
for MY_FILENAME in *.[jJpP][pPnN][gG]; do
	MY_FILELIST[$MY_NUM_FILES]=$MY_FILENAME
	(( MY_NUM_FILES++ ))
	for MY_RES in ${MY_HEIGHTS[*]}; do
		if [[ ! -s $OUTPUT/$MY_THUMBDIR/$MY_RES/$MY_FILENAME ]]; then
			debugOutput "$OUTPUT/$MY_THUMBDIR/$MY_RES/$MY_FILENAME"
			$MY_CONVERT_COMMAND -auto-orient -strip -quality $MY_QUALITY -resize x$MY_RES "$MY_FILENAME" "$OUTPUT/$MY_THUMBDIR/$MY_RES/$MY_FILENAME"
		fi
	done
	cat >> "$OUTPUT/$MY_INDEX_HTML_FILE" << EOF
<div class="col">
	<p>
		<a href="$MY_THUMBDIR/$MY_FILENAME.html"><img src="$VIEW_IMGURL$MY_THUMBDIR/$MY_HEIGHT_SMALL/$MY_FILENAME" alt="Thumbnail: $MY_FILENAME" class="rounded mx-auto d-block"></a>
	</p>
</div>
EOF
done
echo '</div>' >> "$OUTPUT/$MY_INDEX_HTML_FILE"

## Generate the HTML Files for Images in thumbdir
MY_FILE=0
while [[ $MY_FILE -lt $MY_NUM_FILES ]]; do
	MY_FILENAME=${MY_FILELIST[$MY_FILE]}
	MY_PREV=""
	MY_NEXT=""
	[[ $MY_FILE -ne 0 ]] && MY_PREV=${MY_FILELIST[$((MY_FILE - 1))]}
	[[ $MY_FILE -ne $((MY_NUM_FILES - 1)) ]] && MY_NEXT=${MY_FILELIST[$((MY_FILE + 1))]}
	MY_IMAGE_HTML_FILE="$OUTPUT/$MY_THUMBDIR/$MY_FILENAME.html"
	MY_EXIF_INFO=$($MY_EXIF_COMMAND "$MY_FILENAME")
	MY_FILESIZE=$(getFileSize "$MY_FILENAME")
	debugOutput "$MY_IMAGE_HTML_FILE"
	cat > "$MY_IMAGE_HTML_FILE" << EOF
<!DOCTYPE HTML>
<html lang="en">
<head>
<meta charset="utf-8">
<title>$MY_FILENAME</title>
<link rel="shortcut icon" href="../favicon.ico">
<meta name="viewport" content="width=device-width">
<meta name="robots" content="noindex, nofollow">
<link rel="stylesheet" href="$MY_CSS">
</head>
<body>
<header>
	<div class="navbar navbar-dark bg-dark shadow-sm">
		<div class="container">
			<a href="../index.html" class="navbar-brand">
				<strong>返回到 $MY_TITLE</strong>
				<a href="https://github.com/wzwtt/ikun" target="_blank" class="mdui-btn mdui-btn-icon mdui-ripple mdui-ripple-white" mdui-tooltip="{content: '在 GitHub 上查看本项目'}">
                   <svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 36 36" enable-background="new 0 0 36 36" xml:space="preserve" class="mdui-icon" style="width: 24px;height:24px;">
                      <path fill-rule="evenodd" clip-rule="evenodd" fill="#ffffff" d="M18,1.4C9,1.4,1.7,8.7,1.7,17.7c0,7.2,4.7,13.3,11.1,15.5
  c0.8,0.1,1.1-0.4,1.1-0.8c0-0.4,0-1.4,0-2.8c-4.5,1-5.5-2.2-5.5-2.2c-0.7-1.9-1.8-2.4-1.8-2.4c-1.5-1,0.1-1,0.1-1
  c1.6,0.1,2.5,1.7,2.5,1.7c1.5,2.5,3.8,1.8,4.7,1.4c0.1-1.1,0.6-1.8,1-2.2c-3.6-0.4-7.4-1.8-7.4-8.1c0-1.8,0.6-3.2,1.7-4.4
  c-0.2-0.4-0.7-2.1,0.2-4.3c0,0,1.4-0.4,4.5,1.7c1.3-0.4,2.7-0.5,4.1-0.5c1.4,0,2.8,0.2,4.1,0.5c3.1-2.1,4.5-1.7,4.5-1.7
  c0.9,2.2,0.3,3.9,0.2,4.3c1,1.1,1.7,2.6,1.7,4.4c0,6.3-3.8,7.6-7.4,8c0.6,0.5,1.1,1.5,1.1,3c0,2.2,0,3.9,0,4.5
  c0,0.4,0.3,0.9,1.1,0.8c6.5-2.2,11.1-8.3,11.1-15.5C34.3,8.7,27,1.4,18,1.4z"></path>
                   </svg>
                </a>
			</a>
		</div>
	</div>
</header>
<main class="container">
EOF

	# Pager
	echo '<div class="row py-3"><div class="col text-left">' >> "$MY_IMAGE_HTML_FILE"
	if [[ $MY_PREV ]]; then
		echo '<a href="'"$MY_PREV"'.html" accesskey="p" title="⌨️ PC: [Alt]+[Shift]+[P] / MAC: [Control]+[Option]+[P]" class="btn btn-secondary " role="button">&laquo; 上一张</a>' >> "$MY_IMAGE_HTML_FILE"
	else
		echo '<a href="#" class="btn btn-secondary  disabled" role="button" aria-disabled="true">&laquo; 上一张</a>' >> "$MY_IMAGE_HTML_FILE"
	fi
	cat >> "$MY_IMAGE_HTML_FILE" << EOF
</div>
<div class="col d-none d-md-block text-center"><h3>$MY_FILENAME</h3></div>
<div class="col text-right">
EOF
	if [[ $MY_NEXT ]]; then
		echo '<a href="'"$MY_NEXT"'.html" accesskey="n" title="⌨️ PC: [Alt]+[Shift]+[N] / MAC: [Control]+[Option]+[N]" class="btn btn-secondary ">下一张 &raquo;</a>' >> "$MY_IMAGE_HTML_FILE"
	else
		echo '<a href="#" class="btn btn-secondary  disabled" role="button" aria-disabled="true">下一张 &raquo;</a>' >> "$MY_IMAGE_HTML_FILE"
	fi
	echo '</div></div>' >> "$MY_IMAGE_HTML_FILE"

	cat >> "$MY_IMAGE_HTML_FILE" << EOF
<div class="row">
	<div class="col">
		<p><img src="$VIEW_IMGURL$MY_THUMBDIR/$MY_HEIGHT_LARGE/$MY_FILENAME" class="img-fluid" alt="Image: $MY_FILENAME"></p>
	</div>
</div>
<div class="row">
	<div class="col">
		<p><a class="btn btn-primary" href="$SOURCE_IMGURL$MY_FILENAME">查看原图 ($MY_FILESIZE)</a></p>
	</div>
</div>
EOF

	# EXIF
	if [[ $MY_EXIF_INFO ]]; then
		cat >> "$MY_IMAGE_HTML_FILE" << EOF
<div class="row">
<div class="col">
<pre>
$MY_EXIF_INFO
</pre>
</div>
</div>
EOF
	fi

	# Footer
	cat >> "$MY_IMAGE_HTML_FILE" << EOF
</main> <!-- // main container -->
<br>
<footer class="footer mt-auto py-3 bg-light">
	<div class="container">
		<span class="text-muted">$MY_FOOTER $MY_DATETIME</span>
	</div>
</footer>
</body>
</html>
EOF
	(( MY_FILE++ ))
done

fi

### Movies (MOV or MP4)
if [[ $(find . -maxdepth 1 -type f -iname \*.mov  -o -iname '*.mp4' | wc -l) -gt 0 ]]; then
	cat >> "$OUTPUT/$MY_INDEX_HTML_FILE" << EOF
	<div class="row">
		<div class="col">
			<div class="page-header"><h2>Movies</h2></div>
		</div>
	</div>
	<div class="row">
	<div class="col">
EOF
	if [[ $(find . -maxdepth 1 -type f -iname \*.mov | wc -l) -gt 0 ]]; then
	for MY_FILENAME in *.[mM][oO][vV]; do
		MY_FILESIZE=$(getFileSize "$MY_FILENAME")
		cat >> "$OUTPUT/$MY_INDEX_HTML_FILE" << EOF
<a href="$MY_FILENAME" class="btn btn-primary" role="button">$MY_FILENAME ($MY_FILESIZE)</a>
EOF
	done
	fi
	if [[ $(find . -maxdepth 1 -type f -iname \*.mp4 | wc -l) -gt 0 ]]; then
	for MY_FILENAME in *.[mM][pP]4; do
		MY_FILESIZE=$(getFileSize "$MY_FILENAME")
		cat >> "$OUTPUT/$MY_INDEX_HTML_FILE" << EOF
<a href="$MY_FILENAME" class="btn btn-primary" role="button">$MY_FILENAME ($MY_FILESIZE)</a>
EOF
	done
	fi
	echo '</div></div>' >> "$OUTPUT/$MY_INDEX_HTML_FILE"
fi

### Downloads (ZIP)
if [[ $(find . -maxdepth 1 -type f -iname \*.zip | wc -l) -gt 0 ]]; then
	cat >> "$OUTPUT/$MY_INDEX_HTML_FILE" << EOF
	<div class="row">
		<div class="col">
			<div class="page-header"><h2>Downloads</h2></div>
		</div>
	</div>
	<div class="row">
	<div class="col">
EOF
	for MY_FILENAME in *.[zZ][iI][pP]; do
		MY_FILESIZE=$(getFileSize "$MY_FILENAME")
		cat >> "$OUTPUT/$MY_INDEX_HTML_FILE" << EOF
<a href="$MY_FILENAME" class="btn btn-primary" role="button">$MY_FILENAME ($MY_FILESIZE)</a>
EOF
	done
	echo '</div></div>' >> "$OUTPUT/$MY_INDEX_HTML_FILE"
fi

### Footer
cat >> "$OUTPUT/$MY_INDEX_HTML_FILE" << EOF
</main> <!-- // main container -->
<br>
<footer class="footer mt-auto py-3 bg-light">
	<div class="container">
		<span class="text-muted">$MY_FOOTER $MY_DATETIME</span>
	</div>
</footer>
</body>
</html>
EOF

debugOutput "= done"
