-- SQL skript pro vytvoření základních objektů schématu databáze..
--------------------------------------------------------------------------------
-- Autor: Lucia Makaikova <xmakai00@stud.fit.vutbr.cz>.
-- Autor: Tadeas Kachyna  <xkachy00@stud.fit.vutbr.cz>.



CREATE TABLE multikino
(
    id          INT  NOT NULL PRIMARY KEY,
    jmeno       VARCHAR(255) NOT NULL,
    adresa      VARCHAR(255) NOT NULL,
    trzby       NUMBER       NOT NULL
);

CREATE TABLE kinosal
(
    cislo_salu NUMBER(2)    NOT NULL PRIMARY KEY,
    pocet_rad  NUMBER       NOT NULL,
    velikost   NUMBER       NOT NULL,
    typ        VARCHAR(255) NOT NULL
);

CREATE TABLE promitani
(
    id             INT          NOT NULL PRIMARY KEY,
    cislo_sal      INT          NOT NULL,
    delka_projekce INT          NOT NULL,
    zacatek        INT          NOT NULL,
    konec          VARCHAR(255) NOT NULL,
    typ_projekce   VARCHAR(8)   NOT NULL,
    CONSTRAINT "cislo_salu_id_fk"
		FOREIGN KEY (cislo_sal) REFERENCES kinosal (cislo_salu)
		ON DELETE CASCADE
);

CREATE TABLE film
(
    id      INT         NOT NULL PRIMARY KEY,
    dabing  VARCHAR(64) NOT NULL,
    titulky VARCHAR(64) NOT NULL,
    zanr    VARCHAR(64) NOT NULL
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

CREATE TABLE program
(
    id               INT          NOT NULL PRIMARY KEY,
    vernostni_akce   VARCHAR(255) NOT NULL,
    nabidka_projekci VARCHAR(255) NOT NULL,
    vekove_kategorie VARCHAR(255) NOT NULL
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
