#! /bin/bash

token=`cat ~/.ssh/github.token`

curl -u jeannegreulich:$token  -H "User-Agent: Mozilla/55.0" https://api.github.com/repos/simp/simp-core/git/trees/master?recursive=1
