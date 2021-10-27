#!/bin/bash

output_file="./simp_release_stuff_2021_08_08.csv"
GITLAB_ACCESS_TOKEN=`cat ~/.ssh/tokens/simp*gitlab*` \
  GITHUB_ACCESS_TOKEN=`cat ~/.ssh/tokens/simp*github*` \
  bundle exec tools/release/generate_simp_release_status.rb\
  -o $output_file
