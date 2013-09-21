//Utworzenie nowej bazy
dbinit -p 2048 -dba dev,sql -z 1250POL serge2465_Baza.db

//Uruchomienie serwera z utworzon¹ baz¹ danych
start=dbsrv11 -n serge2465_Serwer serge2465_Baza.db

//Oczekiwanie na wciœniêcie dowolnego klawisza - s³u¿y jako sprawdzenie czy skrypt wykona³ siê poprawnie
pause