## Скрипт - парсер данных через Selenium на [сайте](www.nseindia.com)


#### 1. Парсинг данных:
  - заходит на сайт
  - наводится на MARKET DATA
  - кликает по ссылке Pre-Open Market
  - прокручивает страницу до таблицы
  - парсит данные 'Final Price' из таблицы по всем позициям в file.csv [name, price]


#### 2. Имитация пользовательского сценария
  - заходит на главную страницу сайта
  - прокручивает страницу до графика
  - выбирает тип графика NIFTY BANK
  - кликает ссылку 'View All' под таблицей 'TOP 5 STOCKS - NIFTY BANK'
  - прокручивает страницу до таблицы 
  - в селекторе выбирает 'NIFTY ALPHA 50'
  
 ### Запуск скрипта
 Для правильной работы, необходимо установить:
  - Ruby 2.7
  - браузер Google Chrome
  - [SeleniumWebDriver](https://www.selenium.dev/documentation/en/selenium_installation/installing_selenium_libraries/) 
  
    запускаем в терминале команду
    ```
    gem install selenium-webdriver
    ```
  - [ChromeDriver](https://sites.google.com/chromium.org/driver/)
 
 ##### Запуск:
 
  - открываем Терминал
  - переходим в папку со скриптом
    ``` 
     $ cd path/to/script
    ```
 
  - запускаем скрипт
    ``` 
    $ ruby main.rb
    ```
 
