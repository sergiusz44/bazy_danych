rem Utworzenie po��czenia z ODBC
dbdsn -w serge2465_ODBC -c "UID=dev;PWD=sql;ENG=serge2465_Serwer;ASTOP=YES;INT=NO;DBG=NO;DMRF=NO;LINKS='SharedMemory,TCPIP{host=PC-name;port=2638}';COMP=NO"


rem Oczekiwanie na wci�ni�cie dowolnego klawisza - s�u�y jako sprawdzenie czy skrypt wykona� si� poprawnie
pause