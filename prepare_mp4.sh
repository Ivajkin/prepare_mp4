#!/bin/bash

# Set input and output file paths
input_folder="./mp3_files"
image_path="./background.png"
output_folder="./output"

# Create output folder if it doesn't exist
mkdir -p $output_folder

# Loop through each mp3 file in the input folder
for input_file in "${input_folder}"/*.mp3; do
    # Get the filename without the extension
    filename=$(basename -- "$input_file")
    filename="${filename%.*}"
    
    # Get the duration of the input audio file using ffprobe
    duration=$(ffprobe -i "$input_file" -show_entries format=duration -v quiet -of csv="p=0")

    # Use the duration of the audio file to set the duration of the output video
    ffmpeg -loop 1 -i "${image_path}" -i "${input_file}" -c:a copy -c:v libx264 -t "${duration}" -shortest "${output_folder}/${filename}.mp4"
done

echo "Conversion complete!"
