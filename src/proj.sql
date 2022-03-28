-- SQL skript pro vytvoření základních objektů schématu databáze..
--------------------------------------------------------------------------------
-- Autor: Lucia Makaikova <xmakai00@stud.fit.vutbr.cz>.
-- Autor: Tadeas Kachyna  <xkachy00@stud.fit.vutbr.cz>.



CREATE TABLE multikino
(
    id INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    jmeno VARCHAR(255) NOT NULL,
    adresa VARCHAR(255) NOT NULL, -- mozno jeste rozdelime na ulice,cislo,mesto atd.
    trzby NUMBER DEFAULT 0 NOT NULL
);

CREATE TABLE kinosal
(
    cislo_salu INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    pocet_rad INT NOT NULL,
    velikost INT NOT NULL,
    typ VARCHAR DEFAULT NULL,
    multikino_id INT DEFAULT NULL,
    CONSTRAINT "multikino_id_fk"
    	FOREIGN KEY (multikino_id) REFERENCES multikino (id)
	ON DELETE CASCADE
);

CREATE TABLE promitani
(
    id INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    delka_projekce INT NOT NULL,
    zacatek TIMESTAMP NOT NULL,
    konec TIMESTAMP  NOT NULL,
    typ_projekce VARCHAR DEFAULT '2D' NOT NULL,
    cislo_salu INT DEFAULT 0 NOT NULL,
    film_id INT DEFAULT 0 NOT NULL,
    CONSTRAINT "cislo_salu_id_fk"
    	FOREIGN KEY (cislo_salu) REFERENCES kinosal (cislo_salu)
	ON DELETE CASCADE,
    CONSTRAINT "film_id_fk"
        FOREIGN KEY (film_id) REFERENCES  film(id)
        ON DELETE CASCADE
);

CREATE TABLE film
(
    id  INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    dabing  VARCHAR(64) NOT NULL,
    titulky VARCHAR(64) DEFAULT NULL,
    zanr  VARCHAR(64) NOT NULL
);

CREATE TABLE zamestnanec
(
    id       INT          NOT NULL PRIMARY KEY,
    jmeno    VARCHAR(255) NOT NULL,
    prijmeni VARCHAR(255) NOT NULL,
    adresa   VARCHAR(255) NOT NULL,
    telcislo INT          NOT NULL
);

CREATE TABLE vstupenka
(
    id      INT          NOT NULL PRIMARY KEY,
    cas     VARCHAR(255) NOT NULL,
    rada    INT          NOT NULL,
    sedadlo INT          NOT NULL,
    tarif   VARCHAR(64)  NOT NULL
);

CREATE TABLE online_vstupenka
(
    id          INT         NOT NULL PRIMARY KEY,
    stav_platby VARCHAR(16) NOT NULL
);


CREATE TABLE zakaznik
(
    rc       INT          NOT NULL PRIMARY KEY,
    jmeno    VARCHAR(255) NOT NULL,
    prijmeni VARCHAR(255) NOT NULL,
    adresa   VARCHAR(255) NOT NULL,
    telcislo INT          NOT NULL
);

CREATE TABLE rezervace
(
    id            INT          NOT NULL PRIMARY KEY,
    projekce      VARCHAR(255) NOT NULL,
    zpusob_platby VARCHAR(255) NOT NULL
);

------------------------------------ DROP TABLES --------------------------------------

DROP TABLE MULTIKINO;
DROP TABLE KINOSAL;
DROP TABLE PROMITANI;
DROP TABLE FILM;
DROP TABLE ZAMESTNANEC;
DROP TABLE VSTUPENKA;
DROP TABLE ONLINE_BSTUPENKA;
DROP TABLE PROGRAM;
DROP TABLE ZAKAZNIK;
DROP TABLE REZERVACE;

------------------------------------ INSERT -------------------------------------------

INSERT INTO kinosal
(cislo_salu, pocet_rad, velikost, typ)
VALUES
(12, 10, 250, '2D');

INSERT INTO promitani
(id, cislo_sal, delka_projekce, zacatek, konec, typ_projekce )
VALUES
(02, 12, 250, 250, '20:50', '2D');


SELECT * FROM KINOSAL;
SELECT * FROM PROMITANI;
