#!/bin/bash


MYTOKEN=`cat ~/.ssh/jiratoken`


curl -D- -u jeanne.greulich@onyxpoint.com:$MYTOKEN -X GET "$JIRADATA" -H "Content-Type: application/json" https://simp-project.atlassian.net/rest/api/2/issue/createmeta

