//Utworzenie nowej bazy
dbinit -p 2048 -dba dev,sql -z 1250POL serge2465_Baza.db

//Uruchomienie serwera z utworzon� baz� danych
start=dbsrv11 -n serge2465_Serwer serge2465_Baza.db

//Oczekiwanie na wci�ni�cie dowolnego klawisza - s�u�y jako sprawdzenie czy skrypt wykona� si� poprawnie
pause