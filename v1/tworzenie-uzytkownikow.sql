CREATE USER serg_manager_group;
GRANT GROUP TO serg_manager_group;

CREATE USER serg_sprzedawca_group;
GRANT GROUP TO serg_sprzedawca_group;

CREATE USER serg_edytor_group;
GRANT GROUP TO serg_edytor_group;

GRANT SELECT, INSERT, UPDATE, DELETE ON faktury_naglowek TO serg_sprzedawca_group;
GRANT SELECT, INSERT, UPDATE, DELETE ON produkty TO serg_edytor_group;
GRANT SELECT ON produkty TO  serg_sprzedawca_group; 
GRANT SELECT, INSERT, UPDATE, DELETE ON dostawcy TO serg_edytor_group;
GRANT SELECT ON dostawcy TO  serg_sprzedawca_group; 
GRANT SELECT, INSERT, UPDATE ON klient TO serg_sprzedawca_group;
GRANT SELECT, INSERT, UPDATE, DELETE ON pozycja_faktury TO serg_sprzedawca_group;
GRANT SELECT ON MENADZER_KLIENCI_VIEW TO serg_manager_group;
GRANT SELECT ON MENADZER_PRODUKTY_VIEW TO serg_manager_group;
GRANT SELECT ON FAKTURY_Z_LICZBA_POZYCJI_VIEW TO serg_sprzedawca_group;

CREATE USER serg_man1 IDENTIFIED BY '1';
GRANT MEMBERSHIP IN GROUP serg_manager_group TO serg_man1;

CREATE USER serg_spr1 IDENTIFIED BY '1';
GRANT MEMBERSHIP IN GROUP serg_sprzedawca_group TO serg_spr1;

CREATE USER serg_edy1 IDENTIFIED BY '1';
GRANT MEMBERSHIP IN GROUP serg_edytor_group TO serg_edy1;
