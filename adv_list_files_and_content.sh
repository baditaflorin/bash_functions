list_files_and_contents() {
  # Initialize variables
  local directory=""
  local ignore_dirs=""
  local ignore_exts=""
  local include_exts=""

  # Parse command-line arguments
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

  # Check if directory is specified and exists
  if [ -z "$directory" ]; then
    echo "Directory not specified."
    echo "Usage: list_files_and_contents -d <directory> [--ignore-dir <dir,dir,...>] [--ignore-ext <ext,ext,...>] [--include-ext <ext,ext,...>]"
    return 1
  fi

  if [ ! -d "$directory" ]; then
    echo "The specified directory does not exist."
    return 1
  fi

  # Construct the find command
  find_command="find \"$directory\" -type f"
  IFS=',' read -r _ignore_dirs <<< "$ignore_dirs"
  for dir in $_ignore_dirs; do
    find_command="$find_command ! -path \"$directory/$dir/*\""
  done

  # Execute the find command and process files
  eval "$find_command" | while IFS= read -r file; do
    # Check file extension
    ext="${file##*.}"
    case ",$ignore_exts," in
      *,"$ext",*) continue ;;
    esac

    if [ -n "$include_exts" ]; then
      case ",$include_exts," in
        *,"$ext",*) ;;
        *) continue ;;
      esac
    fi

    file_type=$(file -b --mime-type "$file")
    if [ "${file_type%/*}" = "text" ]; then
      echo "Filename: $file"
      echo "Contents:"
      cat "$file"
      echo "------"
    fi
  done
}
