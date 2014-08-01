BashTools
=========

Nifty bash tricks and tools

waitfor
---
Waits for another process to finish, then run a command
    waitfor yum yum install -y something

relentlessly
---
Runs and re-runs a command until it returns success
    relentlessly apt-get install something

source\_filter
---
Utility function for removing commonly changing compiled files from a stream of file names
    

latest\_change
---
Utility function to get the epoch of the most recent change for a file or any file in a directory

trigger
---
When a given file or directory changes, run a command
    trigger main.py python main.py

retrigger
---
When a given file or directory changes, kill the previously run command and start a new one
    retrigger sinatra_main.rb ruby sinatra_main.rb

make-add-path-func
---
TODO: doc this

