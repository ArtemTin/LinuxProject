#!/bin/bash
echo 'Hello, world!'

if [ "$(id -u)" -eq 0 ]; then
  echo 'Please, run this script from non-admin user' >&2
  exit 1
fi

func showTmp {
  echo 'not implemeted'
}

func redefineTmp {
  echo 'not implemented'
}

func addTmp {
  echo 'not implemented'
}

func removeTmp {
  echo 'not implemented'
}

func showWorking {

}

func redefineWorking {

}

func addWorking {

}

func showCWD {

}

func changeCWD {

}

func cleanupTmp {

}

func execProg {

}

func changeProg {

}

func showLinesAndWords {

}

func showForEveryWorking {

}

func showJunkSize {

}
