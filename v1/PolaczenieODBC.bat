rem Utworzenie po³¹czenia z ODBC
dbdsn -w serge2465_ODBC -c "UID=dev;PWD=sql;ENG=serge2465_Serwer;ASTOP=YES;INT=NO;DBG=NO;DMRF=NO;LINKS='SharedMemory,TCPIP{host=PC-name;port=2638}';COMP=NO"


rem Oczekiwanie na wciœniêcie dowolnego klawisza - s³u¿y jako sprawdzenie czy skrypt wykona³ siê poprawnie
pause