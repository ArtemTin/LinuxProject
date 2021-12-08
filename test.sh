#!/bin/bash
echo 'Hello, world!'

test() {
  if [ $comm  -ge 15 ]; then
    echo "ok"
  else
    echo "not ok"
  fi
}

read comm
test
