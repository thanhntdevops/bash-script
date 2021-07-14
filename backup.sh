#!/bin/bash

# add to crontab
## example
### 05 17 * * * bash /path/backup.sh
SHELL_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SHELL_DIR
push_to_git(){
    git add .
    git commit -m "New backup `date +'%Y-%m-%d %H:%M:%S'`"
    git push -u origin master
}
IS_GIT_AVAILABLE="$(git --version)"
if [[ $IS_GIT_AVAILABLE == *"version"* ]]; then
  echo "Git is Available"
else
  echo "Git is not installed"
  exit 1
fi

if git status | grep "nothing to commit, working tree clean";then
    echo "nothing to commit"
    exit 0
fi

echo "push to Github"
push_to_git
echo "bash-script has been up to date"
