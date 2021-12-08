#!/bin/bash
echo 'Hello, world!'


showLinesAndWords() {
  echo "file: $filename"
  linesdirty=$(wc -l $filename)
  lines=($linesdirty)
  wordsdirty=$(wc -w $filename)
  words=($wordsdirty)
}

showForEveryWorking() {
  extensions=$(sed -n '2p' 'conf.myconfig')
  for ext in $extensions; do
    files=$(find . -type f -name "$ext")
    for file in $files; do
      filename=$file
      showLinesAndWords
      echo $lines
      echo $words
    done
  done
}


showForEveryWorking
