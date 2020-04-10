#!/bin/bash
x="mystuff"
y="yourstuff"

IFS='' read -r -d '' STUFF <<EOF
#cat <<'EOF'
{
  "x": "$x"
  "y": $y
}
EOF

echo $STUFF
