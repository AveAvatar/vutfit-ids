-- SQL skript pro vytvoření základních objektů schématu databáze..
--------------------------------------------------------------------------------
-- Autor: Lucia Makaikova <xmakai00@stud.fit.vutbr.cz>.
-- Autor: Tadeas Kachyna  <xkachy00@stud.fit.vutbr.cz>.

-------------------------------- SMAZANI TABULEK -------------------------------
DROP TABLE VSTUPENKA;
DROP TABLE REZERVACE;
DROP TABLE ZAKAZNIK;
DROP TABLE ZAMESTNANEC;
DROP TABLE PROMITANI;
DROP TABLE FILM;
DROP TABLE KINOSAL;
DROP TABLE MULTIKINO;
DROP TABLE VEDOUCI;

------------------------------- VYTVORENI TABULEK ------------------------------

CREATE TABLE vedouci
(
    id INT NOT NULL PRIMARY KEY
);

CREATE TABLE multikino
(
    id INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    jmeno VARCHAR(255) NOT NULL,
    ulice VARCHAR(255) NOT NULL,
    mesto VARCHAR(255) NOT NULL,
    trzby NUMBER DEFAULT 0 NOT NULL,
    vedouci_id INT DEFAULT NULL UNIQUE,
    CONSTRAINT "vedouci_multikino_id_fk"
    	FOREIGN KEY (vedouci_id) REFERENCES vedouci (id)
	        ON DELETE SET NULL
);

CREATE TABLE kinosal
(
    cislo_salu INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    pocet_rad INT NOT NULL,
    pocet_sedadel INT NOT NULL,
    typ VARCHAR(16) DEFAULT '2D' NOT NULL,
    multikino_id INT DEFAULT NULL,
    CONSTRAINT "multikino_id_fk"
    	FOREIGN KEY (multikino_id) REFERENCES multikino (id)
	        ON DELETE CASCADE
);

CREATE TABLE film
(
    id  INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    dabing  VARCHAR(255) NOT NULL,
    titulky VARCHAR(255) DEFAULT NULL,
    zanr  VARCHAR(255) NOT NULL
);

CREATE TABLE promitani
(
    id INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    delka_projekce INT NOT NULL,
    zacatek TIMESTAMP NOT NULL,
    konec TIMESTAMP  NOT NULL,
    cislo_salu INT NOT NULL,
    film_id INT NOT NULL,
    CONSTRAINT "cislo_salu_id_fk"
    	FOREIGN KEY (cislo_salu) REFERENCES kinosal (cislo_salu)
	        ON DELETE CASCADE,
    CONSTRAINT "film_id_fk"
        FOREIGN KEY (film_id) REFERENCES  film(id)
            ON DELETE CASCADE
);

CREATE TABLE zamestnanec
(
    id  INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    jmeno  VARCHAR(255) NOT NULL,
    prijmeni  VARCHAR(255) NOT NULL,
    ulice  VARCHAR(20) NOT NULL,
    mesto   VARCHAR(20) NOT NULL,
    email VARCHAR(255)
	    CHECK(REGEXP_LIKE(
		email, '^[a-z]+[a-z0-9\.]*@[a-z0-9\.-]+\.[a-z]{2,}$', 'i'
		)),
    telcislo INT NOT NULL
        CHECK(REGEXP_LIKE(
                telcislo , '^((420|421)[0-9]{9})$', 'i'
            )),
    typ VARCHAR(255) NOT NULL,
        CONSTRAINT  typ_zamestnance CHECK(typ = 'Vedouci' or typ = 'Zamestnanec'),
    multikino_id INT DEFAULT NULL,
    CONSTRAINT "multikino_idd_fk"
    	FOREIGN KEY (multikino_id) REFERENCES multikino (id)
	        ON DELETE CASCADE,
    vedouci_id INT DEFAULT NULL,
	CONSTRAINT "vedouci_zamestnanec_idd_fk"
		FOREIGN KEY (vedouci_id) REFERENCES vedouci (id)
		    ON DELETE SET NULL
);

CREATE TABLE zakaznik
(
    rc INT NOT NULL PRIMARY KEY
        CHECK(REGEXP_LIKE(
		rc , '^(([0-9]{2})(((0[1-9])|10|11|12)|(5[1-9]|60|61|62))(0[1-9]|[12][0-9]|3[01])(((?!000)[0-9]{3})|[0-9]{4}))$', 'i'
		))
        CONSTRAINT RC_CHECK
            check(MOD(RC, 11) = 0),
    jmeno VARCHAR(255) NOT NULL,
    prijmeni VARCHAR(255) NOT NULL,
    ulice VARCHAR(20)  NOT NULL,
    mesto VARCHAR(20)  NOT NULL,
	email VARCHAR(255)
	    CHECK(REGEXP_LIKE(
		email, '^[a-z]+[a-z0-9\.]*@[a-z0-9\.-]+\.[a-z]{2,}$', 'i'
		)),
    telcislo INT NOT NULL
        CHECK(REGEXP_LIKE(
                telcislo , '^((420|421)[0-9]{9})$', 'i'
            ))
);

CREATE TABLE rezervace
(
    id  INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    zpusob_platby VARCHAR(255) NOT NULL,
        CONSTRAINT zpusob_zaplaceni CHECK(zpusob_platby = 'Online' or zpusob_platby = 'Hotove'),
    zakaznik_id INT DEFAULT 0 NOT NULL,
    CONSTRAINT "zakaznik_id_fk"
    	FOREIGN KEY (zakaznik_id) REFERENCES zakaznik (rc)
	        ON DELETE CASCADE
);

CREATE TABLE vstupenka
(
    id  INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    rada    INT          NOT NULL,
    sedadlo INT          NOT NULL,
    tarif   VARCHAR(255)  NOT NULL,
        CONSTRAINT tarif CHECK(tarif= 'Dospely' or tarif= 'Dite' or tarif= 'Student'),
    typ     VARCHAR(255), --specializace online vstupenka
        CONSTRAINT typ CHECK(typ = 'Online' or typ = ''),
    stav_platby VARCHAR(255) NOT NULL,
        CONSTRAINT stav_platby CHECK(stav_platby= 'Zaplaceno' or stav_platby = 'Nezaplaceno'),
    rezervace_id INT DEFAULT 0 NOT NULL,
    zamestnanec_id INT DEFAULT 0,
    promitani_id INT DEFAULT 0, --pri zruseni premietania sa uchovaju data o predanych vstupenkach
    CONSTRAINT "rezervace_id_fk"
    	FOREIGN KEY (rezervace_id) REFERENCES rezervace (id)
	        ON DELETE CASCADE,
    CONSTRAINT "zamestnanec_id_fk"
    	FOREIGN KEY (zamestnanec_id) REFERENCES zamestnanec (id)
	        ON DELETE SET NULL,
    CONSTRAINT "promitani_id_fk"
    	FOREIGN KEY (promitani_id) REFERENCES promitani (id)
	        ON DELETE SET NULL
);

------------------------------------ VLOZENI HODNOT --------------------------------------

INSERT INTO VEDOUCI (id) VALUES (1);
INSERT INTO VEDOUCI (id) VALUES (2);

INSERT INTO MULTIKINO (jmeno, ulice, mesto, trzby, vedouci_id)
VALUES ('OC OLYMPIA' , 'U Dálnice ', 'Modřice', '123456', 1);

INSERT INTO MULTIKINO (jmeno, ulice, mesto, trzby, vedouci_id)
VALUES ('OC Velky Špalicek' , 'Mečová 695', 'Brno', '456687', 2);

INSERT INTO KINOSAL (pocet_rad, pocet_sedadel, typ, multikino_id) VALUES (15, 250, '2D', 1);
INSERT INTO KINOSAL (pocet_rad, pocet_sedadel, typ, multikino_id) VALUES (20, 300, '3D', 1);
INSERT INTO KINOSAL (pocet_rad, pocet_sedadel, typ, multikino_id) VALUES (15, 250, '2D', 1);

INSERT INTO KINOSAL (pocet_rad, pocet_sedadel, typ, multikino_id) VALUES (15, 250, '2D', 2);
INSERT INTO KINOSAL (pocet_rad, pocet_sedadel, typ, multikino_id) VALUES (20, 300, '3D', 2);
INSERT INTO KINOSAL (pocet_rad, pocet_sedadel, typ, multikino_id) VALUES (15, 250, '2D', 2);

INSERT INTO FILM (dabing, zanr) VALUES ('cesky', 'komedie');
INSERT INTO FILM (dabing, titulky, zanr) VALUES ('anglicky', 'cesky', 'komedie');
INSERT INTO FILM (dabing, zanr) VALUES ('cesky', 'drama');

INSERT INTO promitani( delka_projekce, zacatek, konec, cislo_salu, film_id)
VALUES (120, '10:10:10', '10:10:10' , 2 ,1 );

INSERT INTO zamestnanec(jmeno, prijmeni, ulice, mesto, email, telcislo, typ, multikino_id, vedouci_id)
VALUES('X', 'Y', 'Hlavni', 'Brno', 'vedouci@multikino.cz', 420111111111, 'Zamestnanec', 2, 2);

INSERT INTO zakaznik(rc, jmeno, prijmeni, ulice, mesto, email, telcislo)
VALUES(7204250999 ,'X', 'Y', 'Hlavni', 'Brno', 'vedouci@multikino.cz', 420111111111);

INSERT INTO  rezervace(zpusob_platby, zakaznik_id)
VALUES ('Hotove', 7204250999);

INSERT INTO  rezervace(zpusob_platby, zakaznik_id)
VALUES ('Online', 7204250999);

INSERT INTO VSTUPENKA (rada, sedadlo, tarif, typ, stav_platby, rezervace_id, zamestnanec_id, promitani_id )
VALUES (4, 10, 'Dospely', '', 'Zaplaceno', 1, 1, 1);

------------------------------------ ZOBRAZENI TABULEK --------------------------------------

SELECT * FROM VEDOUCI;
SELECT * FROM MULTIKINO;
SELECT * FROM KINOSAL;
SELECT * FROM FILM;
SELECT * FROM PROMITANI;
SELECT * FROM ZAMESTNANEC;
SELECT * FROM REZERVACE;
SELECT * FROM VSTUPENKA;
SELECT * FROM ZAKAZNIK;
