list_files_and_contents() {
  if [ "$#" -eq 0 ]; then
    echo "Usage: list_files_and_contents <directory>"
    return 1
  fi

  local directory="$1"

  if [ ! -d "$directory" ]; then
    echo "The specified directory does not exist."
    return 1
  fi

  find "$directory" -type f | while IFS= read -r file; do
    file_type=$(file -b --mime-type "$file")
    if [[ $file_type == text/* ]]; then
      echo "Filename: $file"
      echo "Contents:"
      cat "$file"
      echo "----------------------"
    fi
  done
}
