#!/bin/bash
echo 'Hello, world!'

# Проверка структуры файла конфигурации
# params: configFileName, cwd
checkConfig() {
  echo 'config check not implemented'
  return
}

# Создание нового файла конфигурации, если его не было или он поврежден
# params: cwd
initConfig() {
  touch conf.myconfig
  '*.log\n' >> conf.myconfig
  '*.txt\n' >> conf.myconfig
  'grep error* last.txt>last.log' >> conf.myconfig
}

startupConfig() { # Проверка/инициализация файла конфигурации
  if [ -e "conf.myconfig" ]; then
    echo 'config file exists'
    if [ checkConfig ]; then
      'config file is OK'
    else
      'config file is damaged, restoring default state'
      initConfig
  else
    echo 'no config file'
    initConfig
  fi
}

# Проверка корректности ввода номера команды
# params: comm
commCorrect() {
  if [ comm -ge 1 -a comm -le 9 ]; then
    return 0
  else
    return 1
  fi
}


# Показывает список расширений временных файлов
showTmp() {
  sed -n '1p' 'conf.myconfig'
}

# Вбить список расширений временных файлов заново
redefineTmp() {
  #prev_tmp=$(sed -n '1p' 'conf.myconfig')
  echo -n 'Введите новый список расширений временных файлов: '
  read new_tmp
  new_tmp=$new_tmp" "
  sed -i '' "1s/.*/$new_tmp/g" 'conf.myconfig'
}

# Добавить расширение в список расширений временных файлов
addTmp() {
  prev_tmp=$(sed -n '1p' 'conf.myconfig')
  echo "Список расширений сейчас: $prev_tmp"
  echo -n 'Введите расширение, которое надо добавить: '
  read new_tmp
  tmp=$prev_tmp"$new_tmp "
  sed -i '' "1s/.*/$tmp/g" 'conf.myconfig'
}

# Удалить расширение из списка расширений временных файлов
# params: configFileName, cwd
removeTmp() {
  prev_tmp=$(sed -n '1p' 'conf.myconfig')
  echo "Список расширений сейчас: $prev_tmp"
  echo -n 'Введите расширение, которое надо удалить: '
  read del_tmp
  del_tmp=$del_tmp" "
  sed -i '' "1s/$del_tmp//g" 'conf.myconfig'
}

# Показать список расширений рабочих файлов
# params: configFileName, cwd
showWorking() {
  sed -n '2p' 'conf.myconfig'
}

# Перезадать список расширений рабочих файлов
# params: configFileName, cwd
redefineWorking() {
  echo -n 'Введите новый список расширений временных файлов: '
  read new_wrk
  new_wrk=$new_wrk" "
  sed -i '' "2s/.*/$new_wrk/g" 'conf.myconfig'

}

# Добавить расширение в список расширений рабочих файлов
# params: configFileName, cwd
addWorking() {
  prev_wrk=$(sed -n '2p' 'conf.myconfig')
  echo "Список расширений сейчас: $prev_wrk"
  echo -n 'Введите расширение, которое надо добавить: '
  read new_wrk
  wrk=$prev_wrk"$new_wrk "
  sed -i '' "2s/.*/$wrk/g" 'conf.myconfig'
}

# Удалить расширение из списка расширений рабочих файлов
# params: configFileName, cwd
removeWorking() {
  prev_wrk=$(sed -n '2p' 'conf.myconfig')
  echo "Список расширений сейчас: $prev_wrk"
  echo -n 'Введите расширение, которое надо удалить: '
  read del_wrk
  del_wrk=$del_wrk" "
  sed -i '' "2s/$del_wrk//g" 'conf.myconfig'
}

# Показывает текущую рабочую директорию скрипта
showCWD() {
  echo "Текущий каталог: $(PWD)"
}

# Изменяет текущую рабочую директорию скрипта
changeCWD() {
  echo -n 'Введите полный или относительный путь новой директории (как для cd): '
  read newwd
  cd $newwd
}

# Удаляет все файлы, подходящие по расширению как "временные"
cleanupTmp() {
  extensions=$(sed -n '1p' 'conf.myconfig')
  for ext in $extensions; do
    find . -type f -name "$ext" -delete
  done
}

# Исполняет команду в рабочей директории
execProg() {
  prog=$(sed -n '3p' 'conf.myconfig')
  exec $prog
}

# Изменяет исполняемую команду
changeProg() {
  prog=$(sed -n '3p' 'conf.myconfig')
  echo "Текущая команда: $prog"
  echo -n "Введите новую команду: "
  read newcomm
  sed -i '' "3s/.*/$$newcomm/g" 'conf.myconfig'
}

# Показывает кол-во строк и слов в текстовом файле
# params: filename
showLinesAndWords() {
  echo "file: $filename"
  linesdirty=$(wc -l $filename)
  lines=($linesdirty)
  wordsdirty=$(wc -w $filename)
  words=($wordsdirty)
}

# Для каждого файла, подходящего по расширению как "рабочий", показывает кол-во строк и слов
showForEveryWorking() {
  extensions=$(sed -n '2p' 'conf.myconfig')
  for ext in $extensions; do
    files=$(find . -type f -name "$ext")
    for file in $files; do
      filename=$file
      showLinesAndWords
      echo "lines: $lines"
      echo "lines: $words"
    done
  done
}

# Для каждого файла, подходящего по расширению как "временный", показывает его размер
# params: configFileName, cwd
showJunkSize() {

}


# Проверка, от чьего имени запущена программа
if [ "$(id -u)" -eq 0 ]; then
  echo 'Please, run this script from non-admin user' >&2
  exit 1
fi

# Проверка, что кол-во аргументов правильное
name = `basename $0`
if [ $# -le 0 ]; then
  echo 'Использование: $name --interactive либо $name --action [1-9]' >&2
  exit 1
fi


# Работа в интерактивном режиме
if [ $1 -eq '--interactive']; then
  printmenu
  echo -n "Введите команду: "
  read comm
  while [ comm -ne 10 ]; do
    until commCorrect; do
      echo -n 'Неверная команда, повторите ввод'
      read comm
    doCommand
    printmenu
    echo -n "Введите команду: "
    read comm
  echo 'Завершение.'
  done
else # работа в тихом режиме (выполнение одной команды)
  if ! silentArgsCorrect; then
    echo 'Неверные аргументы' >&2
    echo 'Использование: $name либо $name --action [1-9]' >&2
    exit 1
  else
    echo ''
  fi
fi

startupConfig
