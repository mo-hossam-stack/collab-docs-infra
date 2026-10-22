#!/bin/bash

read -p "How many comments to add? " count

for i in $(seq 1 "$count"); do
  echo "// comment $i" >> auto-comments.txt
  git add auto-comments.txt
  git commit -m "add comment $i"
done

echo "Done. $count comments committed (not pushed)."
