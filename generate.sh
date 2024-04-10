#!/bin/bash

# Default values
fps=25
times=()
mantissaDigits=2
upperFont=600
lowerFont=100

# Function to show usage
function usage {
    echo "Usage: $0 -t <time1,time2,...> [--fps <fps>]"
    echo "Options:"
    echo "  -t, --time <time1,time2,...>    List of times in seconds for the countdown (comma-separated)"
    echo "  --fps <fps>                     Frames per second (default: 25)"
    exit 1
}

# Parse command line options
options=$(getopt -o t: --long time:,fps: -- "$@")
eval set -- "$options"
while true; do
    case "$1" in
        -t|--time)
        IFS=',' read -r -a seconds <<< "$2"
        shift 2
        ;;
        --fps)
        fps="$2"
        shift 2
        ;;
        --)
        shift
        break
        ;;
        *)
        echo "Unknown option: $1"
        usage
        ;;
    esac
done

# Check if seconds is provided
if [ ${#seconds[@]} -eq 0 ]; then
    echo "Error: List of times in seconds is required."
    usage
fi
echo ${seconds[@]}

for sec in "${seconds[@]}"; do
  echo "Generating video for $sec seconds";
	ffmpeg -y -loop 1 -i assets/transparent_image.png -c:v libx264 -r $fps -t $sec -pix_fmt yuv420p -vf "fps=$fps,drawtext=fontfile='/usr/share/fonts/urw-base35/C059-Bold.otf':fontcolor=white:fontsize=$upperFont:x=(w-text_w)/2:y=(h-text_h)/2:text='%{eif\:(t)\:d}.%{eif\:(mod(t, 1)*pow(10,$mantissaDigits))\:d\:$mantissaDigits}',drawtext=fontfile='/usr/share/fonts/urw-base35/C059-Bold.otf':fontcolor=white:fontsize=$lowerFont:x=(w-text_w)/2:y=((h-text_h)/2)+$upperFont:text=''" "countdown_timer.mp4";

	final_time=$sec;
	ffmpeg -y -loop 1 -i assets/transparent_image.png -c:v libx264 -r $fps -t 1 -pix_fmt yuv420p -vf "fps=$fps,drawtext=fontfile='/usr/share/fonts/urw-base35/C059-Bold.otf':fontcolor=white:fontsize=$upperFont:x=(w-text_w)/2:y=(h-text_h)/2:text='%{eif\:($final_time)\:d}.%{eif\:(round(mod($final_time, 1)*pow(10,$mantissaDigits)))\:d\:$mantissaDigits}',drawtext=fontfile='/usr/share/fonts/urw-base35/C059-Bold.otf':fontcolor=white:fontsize=$lowerFont:x=(w-text_w)/2:y=((h-text_h)/2)+$upperFont:text=''" "final_time.mp4";

	# Concatenate the two videos
	file_name=${sec}"_timer.mp4"
	ffmpeg -y -i countdown_timer.mp4 -i final_time.mp4 -filter_complex "[0:v:0][1:v:0]concat=n=2:v=1:a=0[outv]" -map "[outv]" $file_name;

  # Delete the intermediate files
  rm countdown_timer.mp4 final_time.mp4;

done;
