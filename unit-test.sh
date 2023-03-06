#!/bin/bash

# Set up test data
test_data_dir="./unit-tests-data"
input_folder="${test_data_dir}/input"
image_path="${test_data_dir}/input/background.png"
output_folder="${test_data_dir}/output"

# Remove any existing temporary MP4 files
rm -f "${output_folder}"/*.mp4

# Run the script with test data arguments
./prepare_mp4.sh --input "${input_folder}" --image "${image_path}" --output "${output_folder}"

# Check that output files were created
IFS=$'\n' read -d '' -r -a expected_files <<< "Track 3 MP3 Reflection.mp4
Track 4 MP3 Relaxing Road.mp4
Track 9 MP3 Spirit Dance.mp4"
IFS=$'\n' read -d '' -r -a output_files <<< "$(ls "${output_folder}")"
if [[ "${output_files[@]}" != "${expected_files[@]}" ]]; then
    echo "Test failed: incorrect output file names"
    echo "Expected: ${expected_files[@]}"
    echo "Actual: ${output_files[@]}"
    diff -u <(printf '%s\n' "${expected_files[@]}") <(printf '%s\n' "${output_files[@]}")
    exit 1
fi

# Check that output files are not empty
for output_file in $output_files; do
    file_size=$(wc -c <"${output_folder}/${output_file}")
    if [ "${file_size}" -lt 1000 ]; then
        echo "Test failed: ${output_file} is empty or too small"
        exit 1
    fi
done

echo "All tests passed!"
