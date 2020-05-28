#!/usr/bin/env bash
set -e
if ! [ -x "$(command -v ansible)" ]; then
  pacman -S ansible
fi
ansible-playbook -i ~/dotfiles/hosts ~/dotfiles/dotfiles.yml --ask-become-pass
