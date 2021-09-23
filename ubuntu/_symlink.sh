#!/bin/bash

dotfiles_dir=~/.dotfiles/ubuntu/

# Loop through all directories in the 'ubuntu' directory of the repo
for repo_directory in $(find $dotfiles_dir -type d) ; do
  # Get the directory's path as if it was in the home directory
  new_directory=~/${repo_directory/#$dotfiles_dir}

  # Create the directory in the home directory
  mkdir $new_directory
done

# Loop through all files in the 'ubuntu' directory of the repo
# A flat list is used, ignoring directories
for target_path in $(find $dotfiles_dir -type f) ; do
  # Print a blank line to make the output less messy
  echo

  # Skip files whose name begins with an underscore
  if [[ $target_path == *"/_"* ]] ; then
    echo "Skipping $target_path"
    continue
  fi

  # Decide the symlink's path using Bash magic:
  # 1. Start with the full path to the dotfile in the repo
  # 2. Remove the repo-related parts at the beginning of the path
  # 3. Add the prefix '~/' to get the full path to the desired symlink
  symlink_path=~/${target_path/#$dotfiles_dir}

  # s: Create a symbolic link, not a hard one
  # i: Prompt the user if a file already exists
  # f: Force deleting already existing files if the script was run with the '-f' option
  # v: Print all created symlinks to the terminal
  if [ "$1" == "-f" ] ; then
    ln -sfv $target_path $symlink_path
  else
    ln -siv $target_path $symlink_path
  fi
done