#!/bin/bash

for g in `gem list| cut -f1 -d ' '`; do gem cleanup $g; done

