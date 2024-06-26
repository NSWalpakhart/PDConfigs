#!/bin/bash

while :
do
  # Получаем текущую загрузку CPU
  cpuUsage=$(top -bn1 | awk '/Cpu/ { print $2}')

  # Записываем данные в JSON файл
  echo "{ \"cpuUsage\": \"$cpuUsage\" }" > /var/www/html/cpu/stats.json

  # Ждем 1 секунду перед следующим обновлением
  sleep 1
done


