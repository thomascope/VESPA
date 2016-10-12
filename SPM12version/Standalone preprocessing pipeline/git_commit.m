function git_commit(filename, message)

!git config --global user.name "thomascope"
!git config --global user.email 'thomascope@gmail.com'
eval(['!git add ''./' filename])
eval(['!git commit ''./' filename ''' -m ''' message ''''])