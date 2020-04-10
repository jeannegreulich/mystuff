#!/bin/bash


MYTOKEN=`cat ~/.ssh/jiratoken`

for x in `cat ./module_list`; do
IFS='' read -r -d ''  JIRADATA <<EOF
{
  "fields": {
    "project": {
      "key": "SIMP"
    },
    "parent": {
      "key": "SIMP-7456"
    },
    "components": [ { "name": "$x" } ],
    "summary": "Update $x to EL8 - simp extras",
    "description": "Update the module to support El8 as described in parent ticket. Make sure all tests unit and acceptance run",
    "issuetype": {
      "id": "5"
    }
  }
}
EOF

curl -D- -u jeanne.greulich@onyxpoint.com:$MYTOKEN -X POST --data "$JIRADATA" -H "Content-Type: application/json" https://simp-project.atlassian.net/rest/api/2/issue/

done
