#!/bin/bash
echo 'Hello, world!'

# Проверка, от чьего имени запущена программа
if [ "$(id -u)" -eq 0 ]; then
  echo 'Please, run this script from non-admin user' >&2
  exit 1
fi

# Проверка, что кол-во аргументов правильное
name = `basename $0`
if [ $# != 2 -o $# != 1 ]; then
  echo 'Использование: $name --interactive либо $name --action [1-9]' >&2
  exit 1
fi

startupConfig

# Работа в интерактивном режиме
if [ $# -eq 0 ]; then
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
else # работа в тихом режиме (выполнение одной команды)
  if ! silentArgsCorrect; then
    echo 'Неверные аргументы'
    echo 'Использование: $name либо $name --action [1-9]' >&2
    exit 1
  else
    echo ''
  fi


func startupConfig { # Проверка/инициализация файла конфигурации
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
func commCorrect {
  if [ comm -ge 1 -a comm -le 9 ]; then
    return 0
  else
    return 1
  fi
}

# Проверка структуры файла конфигурации
# params: configFileName, cwd
func checkConfig {
  echo 'config check not implemented'
  return
}

# Создание нового файла конфигурации, если его не было или он поврежден
# params: cwd
func initConfig {
  touch conf.myconfig
  '*.log\n' >> conf.mycofing
  '*.txt\n' >> conf.myconfig
  'grep error* last.txt>last.log' >> conf.myconfig
}


# Показывает список расширений временных файлов
# params: configFileName, cwd
func showTmp {
  echo 'not implemeted'
}

# Вбить список расширений временных файлов заново
# params: configFileName, cwd
func redefineTmp {
  echo 'not implemented'
}

# Добавить расширение в список расширений временных файлов
# params: configFileName, cwd
func addTmp {
  echo 'not implemented'
}

# Удалить расширение из списка расширений временных файлов
# params: configFileName, cwd
func removeTmp {
  echo 'not implemented'
}

# Показать список расширений рабочих файлов
# params: configFileName, cwd
func showWorking {

}

# Перезадать список расширений рабочих файлов
# params: configFileName, cwd
func redefineWorking {

}

# Добавить расширение в список расширений рабочих файлов
# params: configFileName, cwd
func addWorking {

}

# Удалить расширение из списка расширений рабочих файлов
# params: configFileName, cwd
func removeWorking {

}

# Показывает текущую рабочую директорию скрипта
# params: None
func showCWD {
  echo 'Текущий каталог: $(PWD)'
}

# Изменяет текущую рабочую директорию скрипта
# params: None
func changeCWD {
  echo -n 'Введите полный или относительный путь новой директории (как для cd): '
  read newwd
  cd newwd
}

# Удаляет все файлы, подходящие по расширению как "временные"
# params: configFileName, cwd
func cleanupTmp {

}

# Исполняет команду в рабочей директории
# params: configFileName, cwd
func execProg {

}

# Изменяет исполняемую команду
# params: configFileName, cwd
func changeProg {

}

# Показывает кол-во строк и слов в текстовом файле
# params: cwd, filename
func showLinesAndWords {

}

# Для каждого файла, подходящего по расширению как "рабочий", показывает кол-во строк и слов
# params: configFileName, cwd
func showForEveryWorking {

}

# Для каждого файла, подходящего по расширению как "временный", показывает его размер
# params: configFileName, cwd
func showJunkSize {

}
