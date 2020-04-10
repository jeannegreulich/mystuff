#! /bin/bash

FILENAME=$1

if [ -f $FILENAME ]; then
 CONTENT=$(sed -e 's/\r//' -e's/\t/\\t/g' -e 's/"/\\"/g' "${FILENAME}" | awk '{ printf($0 "\\n") }')

  read -r -d '' DESC <<EOF
  {
    "description": "Files to configure multi tier LDAP on SIMP",
    "public": true,
    "files": {
      "${FILENAME}": {
        "content": "${CONTENT}"
      }
    }
  }
EOF

  # 3. Use curl to send a POST request
  curl -u jeannegreulich -X POST -d "${DESC}" "https://api.github.com/gists"

fi
