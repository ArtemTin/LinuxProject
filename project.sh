#!/bin/bash

# (вспомогательная) Создание нового файла конфигурации, если его не было или он поврежден
initConfig() {
  touch "$configLocation"
  echo "*.log " > "$configLocation"
  echo "*.txt " >> "$configLocation"
  echo "ls -la" >> "$configLocation"
}

# Проверка существования и корректности файла конфигурации
startupConfig() {
  if [ -e "$configLocation" ]; then
    echo "$(tput setaf 2)config file found $(tput sgr 0)"
  else
    echo "$(tput setaf 2) config file created $(tput sgr 0)"
    initConfig
  fi
}


# Проверка корректности ввода номера команды
# params: comm
commCorrect() {
  if ! echo "$comm" | grep -Eq "^[0-9][0-9]*$" ; then
    return 1
  elif [ "$comm" -ge 0 -a "$comm" -le 18 ]; then
    return 0
  else
    return 1
  fi
}


# Показывает список расширений временных файлов
showTmp() {
  extensions=$(sed -n '1p' "$configLocation")
  echo "$(tput setaf 5)Расширения временных файлов: $(tput sgr 0)$extensions"
}


# Вбить список расширений временных файлов заново
redefineTmp() {
  echo -n 'Введите новый список расширений временных файлов: '
  read new_tmp
  new_tmp=$new_tmp" "
  sed -i'.backup' "1s/.*/$new_tmp/g" "$configLocation"
}


# Добавить расширение в список расширений временных файлов
addTmp() {
  prev_tmp=$(sed -n '1p' "$configLocation")
  echo "Список расширений сейчас: $prev_tmp"
  echo -n 'Введите расширение, которое надо добавить: '
  read new_tmp
  tmp=$prev_tmp"$new_tmp "
  sed -i'.backup' "1s/.*/$tmp/g" "$configLocation"
}


# Удалить расширение из списка расширений временных файлов
removeTmp() {
  prev_tmp=$(sed -n '1p' "$configLocation")
  echo "Список расширений сейчас: $prev_tmp"
  echo -n 'Введите расширение, которое надо удалить: '
  read del_tmp
  del_tmp=$del_tmp" "
  sed -i'.backup' "1s/$del_tmp//g" "$configLocation"
}


# Показать список расширений рабочих файлов
showWorking() {
  extensions=$(sed -n '2p' "$configLocation")
  echo "$(tput setaf 5)  Расширения рабочих файлов: $(tput sgr 0)$extensions"
}


# Перезадать список расширений рабочих файлов
redefineWorking() {
  echo -n 'Введите новый список расширений временных файлов: '
  read new_wrk
  new_wrk=$new_wrk" "
  sed -i'.backup' "2s/.*/$new_wrk/g" "$configLocation"

}


# Добавить расширение в список расширений рабочих файлов
addWorking() {
  prev_wrk=$(sed -n '2p' "$configLocation")
  echo "Список расширений сейчас: $prev_wrk"
  echo -n 'Введите расширение, которое надо добавить: '
  read new_wrk
  wrk=$prev_wrk"$new_wrk "
  sed -i'.backup' "2s/.*/$wrk/g" "$configLocation"
}


# Удалить расширение из списка расширений рабочих файлов
removeWorking() {
  prev_wrk=$(sed -n '2p' "$configLocation")
  echo "Список расширений сейчас: $prev_wrk"
  echo -n 'Введите расширение, которое надо удалить: '
  read del_wrk
  del_wrk=$del_wrk" "
  sed -i'.backup' "2s/$del_wrk//g" "$configLocation"
}


# Показывает текущую рабочую директорию скрипта
showCWD() {
  echo "$(tput setaf 5)            Текущий каталог: $(tput sgr 0)$(PWD)"
}


# Изменяет текущую рабочую директорию скрипта
changeCWD() {
  prev_wd=$(PWD)
  echo "Текущий полный путь: $prev_wd"
  echo -n "Введите полный или относительный путь новой директории (как для cd): "
  read newwd
  cd $newwd
  echo "Новая папка: $(PWD)"
}


# Удаляет все файлы, подходящие по расширению как "временные"
cleanupTmp() {
  extensions=$(sed -n '1p' "$configLocation")
  for ext in $extensions; do
    find . -type f -maxdepth 1 -name "$ext" -delete
  done
}


# Исполняет команду в рабочей директории
execProg() {
  prog=$(sed -n '3p' "$configLocation")
  $prog
}


# Изменяет исполняемую команду
changeProg() {
  prog=$(sed -n '3p' "$configLocation")
  echo "Текущая команда: $prog"
  echo -n "Введите новую команду: "
  read newcomm
  sed -i'.backup' "3s/.*/$newcomm/g" "$configLocation"
}


# (вспомогательная) Показывает кол-во строк и слов в текстовом файле
showLinesAndWords() {
  linesdirty=$(wc -l $filename)
  lines=($linesdirty)
  wordsdirty=$(wc -w $filename)
  words=($wordsdirty)
  filebase=$(basename $filename)
  echo "$filebase words: $words lines: $lines"
}


# Для каждого файла, подходящего по расширению как "рабочий", показывает кол-во строк и слов
showForEveryWorking() {
  extensions=$(sed -n '2p' "$configLocation")
  for ext in $extensions; do
    files=$(find . -type f -maxdepth 1 -name "$ext")
    if [ -z "$files" ]; then
      echo "Файлов с расширением $ext не нашлось"
    fi
    for file in $files; do
      filename=$file
      showLinesAndWords
    done
  done
}


# Для каждого файла, подходящего по расширению как "временный", показывает его размер
showJunkSize() {
  extensions=$(sed -n '1p' "$configLocation")
  for ext in $extensions; do
    files=$(find . -type f -maxdepth 1 -name "$ext")
    if [ -z "$files" ]; then
      echo "Файлов с расширением $ext не нашлось"
    fi
    for file in $files; do
      du $file
    done
  done
}


# Показать записанную программу
showProg() {
  prog=$(sed -n '3p' "$configLocation")
  echo "$(tput setaf 5)         Записанная команда: $(tput sgr 0)$prog"
}

showConfigLocation() {
  echo "          Файл конфигурации: $configLocation"
}


printmenu() {
  echo
  echo "-- Временные файлы"
  echo -e "\t$(tput setaf  6)1.$(tput setaf  3) Перезадать список расширений ВРЕМЕННЫХ файлов$(tput sgr 0)"
  echo -e "\t$(tput setaf 6)2.$(tput setaf  3) Добавить расширение в список расширений ВРЕМЕННЫХ файлов$(tput sgr 0)"
  echo -e "\t$(tput setaf 6)3.$(tput setaf  3) Удалить расширение из списка расширений ВРЕМЕННЫХ файлов (по имени)$(tput sgr 0)"
  echo -e "\t$(tput setaf 6)4.$(tput setaf  3) Показать размер каждого ВРЕМЕННОГО файла$(tput sgr 0)"
  echo -e "\t$(tput setaf 6)5.$(tput setaf  3) Удалить все ВРЕМЕННЫЕ файлы$(tput sgr 0)"
  echo "-- Рабочие файлы"
  echo -e "\t$(tput setaf 6)6.$(tput setaf  3) Перезадать список расширений РАБОЧИХ файлов$(tput sgr 0)"
  echo -e "\t$(tput setaf 6)7.$(tput setaf  3) Добавить расширение в список расширений РАБОЧИХ файлов$(tput sgr 0)"
  echo -e "\t$(tput setaf 6)8.$(tput setaf  3) Удалить расширение из списка расширений РАБОЧИХ файлов (по имени)$(tput sgr 0)"
  echo -e "\t$(tput setaf 6)9.$(tput setaf  3) Показать кол-во слов и строк для каждого РАБОЧЕГО файла$(tput sgr 0)"
  echo "-- Рабочая команда"
  echo -e "\t$(tput setaf 6)10.$(tput setaf  3) Исполнить команду из файла конфигурации$(tput sgr 0)"
  echo -e "\t$(tput setaf 6)11.$(tput setaf  3) Изменить выполняемую команду$(tput sgr 0)"
  echo "-- Остальное"
  echo -e "\t$(tput setaf 6)12.$(tput setaf  3) Сменить рабочую директорию$(tput sgr 0)"
  echo -e "\t$(tput setaf 1)0.$(tput setaf  3) Завершение программы $(tput sgr 0)$(tput sgr 0)"
  echo
}


printFullMenu() {
  echo
  echo "-- Временные файлы"
  echo -e "\t$(tput setaf  6)1.$(tput setaf  3) Перезадать список расширений ВРЕМЕННЫХ файлов$(tput sgr 0)"
  echo -e "\t$(tput setaf 6)2.$(tput setaf  3) Добавить расширение в список расширений ВРЕМЕННЫХ файлов$(tput sgr 0)"
  echo -e "\t$(tput setaf 6)3.$(tput setaf  3) Удалить расширение из списка расширений ВРЕМЕННЫХ файлов (по имени)$(tput sgr 0)"
  echo -e "\t$(tput setaf 6)4.$(tput setaf  3) Показать размер каждого ВРЕМЕННОГО файла$(tput sgr 0)"
  echo -e "\t$(tput setaf 6)5.$(tput setaf  3) Удалить все ВРЕМЕННЫЕ файлы$(tput sgr 0)"
  echo "-- Рабочие файлы"
  echo -e "\t$(tput setaf 6)6.$(tput setaf  3) Перезадать список расширений РАБОЧИХ файлов$(tput sgr 0)"
  echo -e "\t$(tput setaf 6)7.$(tput setaf  3) Добавить расширение в список расширений РАБОЧИХ файлов$(tput sgr 0)"
  echo -e "\t$(tput setaf 6)8.$(tput setaf  3) Удалить расширение из списка расширений РАБОЧИХ файлов (по имени)$(tput sgr 0)"
  echo -e "\t$(tput setaf 6)9.$(tput setaf  3) Показать кол-во слов и строк для каждого РАБОЧЕГО файла$(tput sgr 0)"
  echo "-- Рабочая команда"
  echo -e "\t$(tput setaf 6)10.$(tput setaf  3) Исполнить команду из файла конфигурации$(tput sgr 0)"
  echo -e "\t$(tput setaf 6)11.$(tput setaf  3) Изменить выполняемую команду$(tput sgr 0)"
  echo "-- Остальное"
  echo -e "\t$(tput setaf 6)12.$(tput setaf  3) Сменить рабочую директорию$(tput sgr 0)"
  echo -e "\t$(tput setaf 1)0.$(tput setaf  3) Завершение программы $(tput sgr 0)$(tput sgr 0)"
  echo "-- Доступно в тихом режиме"
  echo -e "\t$(tput setaf 6)13.$(tput setaf  3) Показать расширения временных файлов$(tput sgr 0)"
  echo -e "\t$(tput setaf 6)14.$(tput setaf  3) Показать расширения рабочих файлов$(tput sgr 0)"
  echo -e "\t$(tput setaf 6)15.$(tput setaf  3) Показать рабочую команду$(tput sgr 0)"
  echo -e "\t$(tput setaf 6)16.$(tput setaf  3) Показать рабочую директорию$(tput sgr 0)"
  echo -e "\t$(tput setaf 6)17.$(tput setaf  3) Показать расположение файла конфигурации$(tput sgr 0)"
  echo -e "\t$(tput setaf 6)18.$(tput setaf  3) Показать меню$(tput sgr 0)"
  echo
}


commandSelector() {
  commm=$1
  if [ $commm -eq 1 ]; then
    redefineTmp
  elif [ $commm -eq 2 ]; then
    addTmp
  elif [ $commm -eq 3 ]; then
    removeTmp
  elif [ $commm -eq 4 ]; then
    showJunkSize
  elif [ $commm -eq 5 ]; then
    cleanupTmp
  elif [ $commm -eq 6 ]; then
    redefineWorking
  elif [ $commm -eq 7 ]; then
    addWorking
  elif [ $commm -eq 8 ]; then
    removeWorking
  elif [ $commm -eq 9 ]; then
    showForEveryWorking
  elif [ $commm -eq 10 ]; then
    execProg
  elif [ $commm -eq 11 ]; then
    changeProg
  elif [ $commm -eq 12 ]; then
    changeCWD
  elif [ $commm -eq 13 ]; then
    showTmp
  elif [ $commm -eq 14 ]; then
    showWorking
  elif [ $commm -eq 15 ]; then
    showProg
  elif [ $commm -eq 16 ]; then
    showCWD
  elif [ $comm -eq 17 ]; then
    showConfigLocation
  elif [ $comm -eq 18 ]; then
    printFullMenu
  elif [ $comm -eq 0 ]; then
    echo "$(tput setaf 2)Завершение. $(tput sgr 0)"
    exit
  fi

}



# Проверка, от чьего имени запущена программа
if [ "$(id -u)" -eq 0 ]; then
  echo 'Данный скрипт нельзя запустить от имени администратора' >&2
  exit 1
fi

name=$(basename $0)
configLocation="$(PWD)/conf.myconfig"


if [ "$1" == "--help" ]; then # вывод справки
  echo "Использование: ./$name"
  echo "          либо ./$name --action [0-18]? [0-18]*"
  echo "          либо ./$name --help , чтобы показать это сообщение и меню"
  printFullMenu
elif [ "$1" == "--action" ]; then # тихий режим
  startupConfig
  comm=$2
  until [ "$comm" == "" ]; do
    if commCorrect; then
      echo "$(tput setaf 3)Выполнение команды $comm$(tput sgr 0)"
      commandSelector $comm
    else
      echo "$(tput setaf 1)Неверный номер команды:$(tput sgr 0) $comm" >&2
      exit 1
    fi
    shift
    comm=$2
  done
else # интерактивный режим
  startupConfig

  printFullMenu
  showConfigLocation
  showTmp
  showWorking
  showCWD
  showProg

  echo -n "$(tput setaf 4)Введите команду: $(tput sgr 0)"
  read comm
  until commCorrect; do
    echo -n "$(tput setaf 1)Неверная команда,$(tput sgr 0) $(tput setaf 4)повторите ввод: $(tput sgr 0)"
    printmenu
    read comm
  done

  while [ "$comm" -ne 0 ]; do
    commandSelector $comm

    printmenu
    showConfigLocation
    showTmp
    showWorking
    showCWD
    showProg

    echo -n "$(tput setaf 4)Введите команду: $(tput sgr 0)"
    read comm
    until commCorrect; do
      printmenu
      echo -n "$(tput setaf 1)Неверная команда,$(tput sgr 0) $(tput setaf 4)повторите ввод: $(tput sgr 0)"
      read comm
    done
  done
  echo "$(tput setaf 2)Завершение. $(tput sgr 0)"
fi
