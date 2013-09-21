CREATE TABLE DOSTAWCY 
(
                ID_DOSTAWCY                                               INTEGER              NOT NULL UNIQUE,
                NAZWA_DOSTAWCY                                    TEXT                      NULL,
                CONSTRAINT "PK_REGION"       PRIMARY KEY ( "ID_DOSTAWCY" ),
                CONSTRAINT "UQ_DOSTAWCY_ID_DOSTAWCY" UNIQUE ( "ID_DOSTAWCY")
);

CREATE TABLE KLIENT 
(
                ID_KLIENTA                                                      INTEGER              NOT NULL UNIQUE,
                NAZWA                                                                              VARCHAR(50) NULL,
                ULICA                                                                  VARCHAR(50) NULL,
                KOD                                                                     VARCHAR(50) NULL,
                MIASTO                                                                             VARCHAR(40) NULL,
                KRAJ                                                                    VARCHAR(50) NULL,
                TELEFON                                                            VARCHAR(10) NULL,
                CONSTRAINT "PK_KLIENT" PRIMARY KEY ( "ID_KLIENTA")
               
);

CREATE TABLE PRODUKTY
(
                ID_PRODUKTU                                               INTEGER              NOT NULL UNIQUE,
                ID_DOSTAWCY                                                INTEGER              NOT NULL ,
                ID_TYPU_PRODUKTU                   INTEGER              NOT NULL,
                NAZWA                                                                              VARCHAR(50) NULL,
                KOD_KRESKOWY                                            VARCHAR(50) NULL,
                CENA                                                                   INTEGER              NOT NULL,
                CONSTRAINT "PK_PRODUKTY" PRIMARY KEY ( "ID_PRODUKTU"),
                CONSTRAINT "FK_PRODUKTY_DOSTAWCY" FOREIGN KEY ( "ID_DOSTAWCY") REFERENCES "DOSTAWCY" ( "ID_DOSTAWCY")
                
);


CREATE TABLE FAKTURY_NAGLOWEK 
(
                ID_FAKTURY                                                     INTEGER NOT NULL DEFAULT AUTOINCREMENT UNIQUE,
                ID_KLIENTA                                                      INTEGER NOT NULL,
                DATA_SPRZED                                               DATETIME NULL,
                DATA_WYST                                                  DATETIME NULL,
                WARTOSC                                                          MONEY NULL,
                ODDZIAL                                                            VARCHAR(50) NULL,
                TERMIN_ZAPL                                  DATETIME NULL,
                CONSTRAINT PK_FAKTURY_NAGLOWEK PRIMARY KEY ( "ID_FAKTURY" ),
                CONSTRAINT "FK_FAKTURY_NAGLOWEK_KLIENT" FOREIGN KEY ( "ID_KLIENTA"   ) REFERENCES "KLIENT" ( "ID_KLIENTA" ),
                CONSTRAINT "UQ_FAKTURY_NAGLOWEK_ID_FAKTURY" UNIQUE ( "ID_FAKTURY")
);

CREATE TABLE POZYCJA_FAKTURY 
(
                ID_FAKTURY                                                     INTEGER              NOT NULL,
                NR_POZYCJI_FAKTURY                                INTEGER              NOT NULL,
                ID_PRODUKTU                                                INTEGER              NOT NULL,
                ILOSC                                                                   INTEGER              NULL,
                CENA                                                                   MONEY                               NULL,
                CONSTRAINT "PK_POZYCJA_FAKTURY" PRIMARY KEY ( "ID_FAKTURY"  , "NR_POZYCJI_FAKTURY"),
                CONSTRAINT "FK_POZYCJA_FAKTURY_FAKTURY_NAGLOWEK"  FOREIGN KEY ( "ID_FAKTURY") REFERENCES "FAKTURY_NAGLOWEK" ( "ID_FAKTURY" ),
                CONSTRAINT "FK_POZYCJA_FAKTURY_PRODUKTY" FOREIGN KEY ( "ID_PRODUKTU" ) REFERENCES "PRODUKTY" ( "ID_PRODUKTU" )
);



//TRIGGERY


CREATE TRIGGER "TR_POZYCJA_FAKTURY_UPDATE" AFTER INSERT, UPDATE
ON POZYCJA_FAKTURY
REFERENCING NEW AS NEW_POZYCJA
FOR EACH ROW
BEGIN
    UPDATE "FAKTURY_NAGLOWEK" 
        SET WARTOSC = (SELECT SUM(ILOSC * CENA) FROM POZYCJA_FAKTURY WHERE ID_FAKTURY = NEW_POZYCJA.ID_FAKTURY)
        WHERE ID_FAKTURY = NEW_POZYCJA.ID_FAKTURY
END;


//PROCEDURY


/////////////GENERATOR FAKTURY


CREATE PROCEDURE "GENERUJ_POZYCJE_FAKTURY"(IN @ID_FAKTURY INTEGER, IN @NR_POZYCJI_FAKTURY INTEGER)
AS
BEGIN
   DECLARE @ID_PRODUKTU INTEGER
   DECLARE @ILOSC INTEGER
   DECLARE @CENA MONEY
   SET @ID_PRODUKTU = (SELECT TOP 1 ID_PRODUKTU FROM PRODUKTY ORDER BY RAND())
   SET @ILOSC = 1 + 9 * RAND()
   SET @CENA = 1 + CAST(999 * RAND() AS decimal(9, 2))
   INSERT INTO POZYCJA_FAKTURY (ID_FAKTURY, NR_POZYCJI_FAKTURY, ID_PRODUKTU, ILOSC, CENA)
       VALUES (@ID_FAKTURY, @NR_POZYCJI_FAKTURY, @ID_PRODUKTU, @ILOSC, @CENA)
END;
//COMMENT ON PROCEDURE ."GENERUJ_POZYCJE_FAKTURY" IS 'Generuje losowa pozycje faktury dla podanego identyfikatora faktury.';



CREATE PROCEDURE "GENERUJ_FAKTURE"()
AS
BEGIN
    DECLARE @ID_KLIENTA INTEGER
                DECLARE @DATA_SPRZED DATETIME
                DECLARE @DATA_WYST DATETIME
                DECLARE @WARTOSC INTEGER
                DECLARE @ODDZIAL VARCHAR(50)
                DECLARE @TERMIN_ZAPL DATETIME
    DECLARE @ID_FAKTURY INTEGER
    DECLARE @NR_POZYCJI_FAKTURY INTEGER
    DECLARE @ILOSC_POZYCJI_FAKTURY INTEGER
    
    SET @ID_KLIENTA = (SELECT TOP 1 ID_KLIENTA FROM KLIENT ORDER BY RAND())
    SET @DATA_SPRZED = DATE(getdate())
    SET @DATA_WYST = DATE(getdate() + CAST(RAND() * 10 AS INTEGER))
    SET @WARTOSC = 0
    SET @ODDZIAL = 'GLOWNY'
    SET @TERMIN_ZAPL = DATE(getdate() + 14)

                INSERT INTO "FAKTURY_NAGLOWEK" (ID_KLIENTA, DATA_SPRZED, DATA_WYST, WARTOSC, ODDZIAL, TERMIN_ZAPL)
        VALUES (@ID_KLIENTA, @DATA_SPRZED, @DATA_WYST, @WARTOSC, @ODDZIAL, @TERMIN_ZAPL)

    SET @ID_FAKTURY = (SELECT @@IDENTITY)
    SET @NR_POZYCJI_FAKTURY = 1
    SET @ILOSC_POZYCJI_FAKTURY = 1 + 6 * RAND()

    WHILE @NR_POZYCJI_FAKTURY <= @ILOSC_POZYCJI_FAKTURY
        BEGIN
            EXEC GENERUJ_POZYCJE_FAKTURY @ID_FAKTURY, @NR_POZYCJI_FAKTURY
            SET @NR_POZYCJI_FAKTURY = @NR_POZYCJI_FAKTURY + 1
        END
   
END;
//COMMENT ON PROCEDURE ."GENERUJ_FAKTURE" IS 'Generuje losowa fakture.';


create or replace view MENADZER_KLIENCI_VIEW as 

    select k.nazwa, k.ulica, k.miasto, k.kraj, count(f.id_faktury) as 'Liczba faktur',
        sum(f.wartosc) as 'Suma faktur', avg(f.wartosc) as 'Srednia wart. fak'
    from klient k left outer join faktury_naglowek f
        on k.id_klienta = f.id_klienta 
    group by k.nazwa, k.ulica, k.miasto, k.kraj;          


create or replace view MENADZER_PRODUKTY_VIEW as

    select fn.data_sprzed, p.nazwa, p.kod_kreskowy, d.nazwa_dostawcy, 
            sum(pf.ilosc), sum(pf.cena*pf.ilosc) as 'Laczna wart. sprzed.'
    from produkty p join dostawcy d 
        on p.id_dostawcy = d.id_dostawcy
        join pozycja_faktury pf on p.id_produktu = pf.id_produktu
        join faktury_naglowek fn on pf.id_faktury = fn.id_faktury
    group by fn.data_sprzed, p.nazwa, p.kod_kreskowy, d.nazwa_dostawcy 
    order by sum(pf.cena*pf.ilosc) desc, nazwa 


create or replace view FAKTURY_Z_LICZBA_POZYCJI_VIEW as

    select fn.data_sprzed, k.nazwa, k.miasto, k.ulica, fn.wartosc, count(*) as 'Liczba pozycji'
    from faktury_naglowek fn join klient k on fn.id_klienta = k.id_klienta
        join pozycja_faktury pf on fn.id_faktury = pf.id_faktury
    group by fn.data_sprzed, k.nazwa, k.miasto, k.ulica, fn.wartosc
    order by fn.data_sprzed, k.nazwa

	
////////£ADOWANIE PLIKÓW 

INSERT INTO KLIENT VALUES
(2,'Nowak','Wizowa43','Warszawa','45-784','Polska','745123658');
INSERT INTO KLIENT VALUES
(3,'Wisniewski','Dzielna5','45-877','Warszawa','Polska','412587456');
INSERT INTO KLIENT VALUES
(4,'Walewski','Ogrodowa5','45-568','Warszawa','Polska','415365465');
INSERT INTO KLIENT VALUES
(5,'Kalicki','Obozowa4','78-5165','Warszawa','Polska','413354654');


INSERT INTO "DOSTAWCY" VALUES
(1,'Aaaaaaaaaaaaa');

INSERT INTO "DOSTAWCY" VALUES
(2,'Bbbbbbbbbbbbb');

INSERT INTO "DOSTAWCY" VALUES
(3,'Ccccccccccccc');

INSERT INTO "DOSTAWCY" VALUES
(4,'Ddddddddddddd');



INSERT INTO "PRODUKTY" (ID_PRODUKTU, ID_DOSTAWCY, ID_TYPU_PRODUKTU, NAZWA, KOD_KRESKOWY, CENA) VALUES (1,2,44,'Ksiazka1','123456789',12);
INSERT INTO "PRODUKTY" (ID_PRODUKTU, ID_DOSTAWCY, ID_TYPU_PRODUKTU, NAZWA, KOD_KRESKOWY, CENA) VALUES (2,4,44,'Ksiazka2','987654321',55);
INSERT INTO "PRODUKTY" (ID_PRODUKTU, ID_DOSTAWCY, ID_TYPU_PRODUKTU, NAZWA, KOD_KRESKOWY, CENA) VALUES (3,3,55,'Klawiatura','456789123',20);
INSERT INTO "PRODUKTY" (ID_PRODUKTU, ID_DOSTAWCY, ID_TYPU_PRODUKTU, NAZWA, KOD_KRESKOWY, CENA) VALUES (4,1,55,'Monitor','147852363',700);
INSERT INTO "PRODUKTY" (ID_PRODUKTU, ID_DOSTAWCY, ID_TYPU_PRODUKTU, NAZWA, KOD_KRESKOWY, CENA) VALUES (5,1,55,'Obudowa','258789123',200);
INSERT INTO "PRODUKTY" (ID_PRODUKTU, ID_DOSTAWCY, ID_TYPU_PRODUKTU, NAZWA, KOD_KRESKOWY, CENA) VALUES (6,4,55,'Zasilacz','456797456',200);
INSERT INTO "PRODUKTY" (ID_PRODUKTU, ID_DOSTAWCY, ID_TYPU_PRODUKTU, NAZWA, KOD_KRESKOWY, CENA) VALUES (7,3,44,'Pendrive','321321654',40);
INSERT INTO "PRODUKTY" (ID_PRODUKTU, ID_DOSTAWCY, ID_TYPU_PRODUKTU, NAZWA, KOD_KRESKOWY, CENA) VALUES (8,1,44,'Ksiazka3','789987852',60);
INSERT INTO "PRODUKTY" (ID_PRODUKTU, ID_DOSTAWCY, ID_TYPU_PRODUKTU, NAZWA, KOD_KRESKOWY, CENA) VALUES (9,4,55,'Myszka','745698587',20);
INSERT INTO "PRODUKTY" (ID_PRODUKTU, ID_DOSTAWCY, ID_TYPU_PRODUKTU, NAZWA, KOD_KRESKOWY, CENA) VALUES (10,2,55,'Laptop','123456582',20);

commit;

CREATE EVENT "Generator_faktur"
SCHEDULE "Generator" BETWEEN '00:00' AND '23:59' EVERY 15 SECONDS
HANDLER
BEGIN
    CALL GENERUJ_FAKTURE;
END;

