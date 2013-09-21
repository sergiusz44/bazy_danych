rem Utworzenie struktury bazy danych i nadanie praw u¿ytkownikom przez u¿ytkownika developer
dbisql -c uid=dev;pwd=sql .\tworzenie-struktury.sql

rem Wype³nienie pól statycznych  przez u¿ytkownika oper
dbisql -c uid=dev;pwd=sql .\tworzenie-uzytkownikow.sql


rem Oczekiwanie na wciœniêcie dowolnego klawisza - s³u¿y jako sprawdzenie czy skrypt wykona³ siê poprawnie
pause