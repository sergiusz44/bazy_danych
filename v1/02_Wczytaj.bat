//Utworzenie struktury bazy danych i nadanie praw u�ytkownikom przez u�ytkownika developer
dbisql -c uid=dev;pwd=sql C:\tmp\tworzenie-struktury.sql

//Wype�nienie p�l statycznych  przez u�ytkownika oper
dbisql -c uid=dev;pwd=sql C:\tmp\tworzenie-uzytkownikow.sql


//Oczekiwanie na wci�ni�cie dowolnego klawisza - s�u�y jako sprawdzenie czy skrypt wykona� si� poprawnie
pause