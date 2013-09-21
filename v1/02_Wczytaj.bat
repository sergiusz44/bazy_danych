//Utworzenie struktury bazy danych i nadanie praw u¿ytkownikom przez u¿ytkownika developer
dbisql -c uid=dev;pwd=sql C:\tmp\tworzenie-struktury.sql

//Wype³nienie pól statycznych  przez u¿ytkownika oper
dbisql -c uid=dev;pwd=sql C:\tmp\tworzenie-uzytkownikow.sql


//Oczekiwanie na wciœniêcie dowolnego klawisza - s³u¿y jako sprawdzenie czy skrypt wykona³ siê poprawnie
pause