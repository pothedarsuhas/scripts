'''
requirements
- git
- remote git repo


note
- this backup script works like an overwrite, works recursively

syntax
> python backup2git.py <directorypath> <username> <token> <reponame>

example
> python backup2git.py /Users/suhaspothedar/Desktop/cs/scripts/test_dir/ pothedarsuhas c241a7025bb0ffed2dfaa80027098cc927e1105c blog 

'''

import sys
import os

dir_path = sys.argv[1]
git_username = sys.argv[2]
git_token = sys.argv[3]
git_repo = sys.argv[4]

os.system("git config --global github.user " + git_username +'; '
        + " git config --global github.token " + git_token + ';'
        + " cd "+ dir_path +';' 
        + " git init;"
        + " git add "+ dir_path +'/.;'
        + ' git commit -m "commiting the directory in the git to master";'
        + ' git remote add origin https://github.com/' + git_username + '/' + git_repo + '.git;'
        + ' git push -u origin master;')





