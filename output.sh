git checkout output
git pull
cp FNA*.docx ~/Downloads/tmpr

f="`ls -t ~/Downloads/tmpr/*.docx | head -1`"
basedocxFILE=${f##*/};  
open $basedocxFILE

git checkout main

