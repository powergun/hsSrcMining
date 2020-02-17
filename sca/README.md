# A simple source code analysis program

- traverse a source code repository
- collect information
- aggregate and display information

for the moment it counts the LOC per source-type and uses a black-list
to skip certain sub-directories and files

## How to build and run

```shell
# this install sca-walk to ~/.local/bin; make sure this path is added in $PATH
stack install

# use sca-walk
cd "<some repo>"
# the perl bit is to make sure only the text-like files are passed to the folding stage
# not doing this will cause problem: directory, binary file etc...
git ls-files | perl -wnl -E 'say if (-f $_)' | sca-walk

```
