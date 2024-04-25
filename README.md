# Flutter Sensor Data Collector

Проект Flutter Sensor Data Collector представляет собой мобильное приложение, разработанное на Flutter, которое собирает данные с встроенных сенсоров устройства, таких как акселерометр, гироскоп и магнитометр. Приложение также включает функциональность определения геолокации пользователя с использованием GPS.

## Основные функции:

- **Сбор данных с сенсоров**: Отслеживание данных акселерометра, гироскопа и магнитометра в реальном времени.

- **Определение геолокации**: Получение текущих координат пользователя с использованием GPS.

- **Сохранение данных**: Автоматическое сохранение собранных данных в базе данных для последующего анализа или использования в исследовательских целях.

## Технологии:

- **Flutter**: Кроссплатформенный фреймворк для разработки мобильных приложений.

- **Firebase**: Используется для хранения и управления данными сенсоров и геолокации.

- **Geolocator и Sensors пакеты**: Для работы с геолокацией и сенсорами устройства соответственно.

## Установка и использование:

Для установки приложения на мобильное устройство выполните следующие шаги:

1. Клонирование репозитория:
   `git clone https://github.com/Valery223/flutter-sensor-app.git`
2. Коннект девайса(Должны быть в одной сети) (либо использовать имуляторы):
   adb.exe connect "ip:port"
3. Запуск приложения:
   flutter run
   
## Дополнительные команды для сборки:
- Сборка APK файла:
  `flutter build apk`