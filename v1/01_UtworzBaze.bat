SET PLIK_BAZA=C:\tmp\baza\serge2465_Baza.db

rem Utworzenie nowej bazy
dbinit -p 2048 -dba dev,sql -z 1250POL %PLIK_BAZA%

rem Uruchomienie serwera z utworzon¹ baz¹ danych
start=dbsrv11 -n serge2465_Serwer %PLIK_BAZA%

rem Oczekiwanie na wciœniêcie dowolnego klawisza - s³u¿y jako sprawdzenie czy skrypt wykona³ siê poprawnie
pause