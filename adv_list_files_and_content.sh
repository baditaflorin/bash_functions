#!/bin/sh

# Function to parse command-line arguments
parse_arguments() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      -d|--directory)
        directory="$2"
        shift 2
        ;;
      --ignore-dir)
        ignore_dirs="$ignore_dirs,$2"
        shift 2
        ;;
      --ignore-ext)
        ignore_exts="$ignore_exts,$2"
        shift 2
        ;;
      --include-ext)
        include_exts="$include_exts,$2"
        shift 2
        ;;
      *)
        echo "Unknown option: $1"
        echo "Usage: list_files_and_contents -d <directory> [--ignore-dir <dir,dir,...>] [--ignore-ext <ext,ext,...>] [--include-ext <ext,ext,...>]"
        return 1
        ;;
    esac
  done
}

# Function to validate the directory argument
validate_directory() {
  if [ -z "$directory" ]; then
    echo "Directory not specified."
    echo "Usage: list_files_and_contents -d <directory> [--ignore-dir <dir,dir,...>] [--ignore-ext <ext,ext,...>] [--include-ext <ext,ext,...>]"
    return 1
  fi

  if [ ! -d "$directory" ]; then
    echo "The specified directory does not exist."
    return 1
  fi
}

# Function to construct the find command based on ignore directories
construct_find_command() {
  find_command="find \"$directory\" -type f"
  IFS=',' set -- $ignore_dirs
  for dir; do
    find_command="$find_command ! -path \"$directory/$dir/*\""
  done
  echo "$find_command"
}

# Function to check if a file should be included based on its extension
should_include_file() {
  file="$1"
  ext="${file##*.}"

  case ",$ignore_exts," in
    *",$ext,"*) return 1 ;;
  esac

  if [ -n "$include_exts" ]; then
    case ",$include_exts," in
      *",$ext,"*) ;;
      *) return 1 ;;
    esac
  fi

  return 0
}

# Function to display the contents of a text file
display_file_contents() {
  file="$1"
  file_type=$(file -b --mime-type "$file")

  case "$file_type" in
    text/*)
      echo "Filename: $file"
      echo "Contents:"
      cat "$file"
      echo "------"
      ;;
  esac
}

# Main function to list files and their contents
list_files_and_contents() {
  directory=""
  ignore_dirs=""
  ignore_exts=""
  include_exts=""

  parse_arguments "$@"
  validate_directory || exit 1

  find_command=$(construct_find_command)

  eval "$find_command" | while IFS= read -r file; do
    if should_include_file "$file"; then
      display_file_contents "$file"
    fi
  done
}

# Execute the main function
#list_files_and_contents "$@"
