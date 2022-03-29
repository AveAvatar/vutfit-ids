-- SQL skript pro vytvoření základních objektů schématu databáze..
--------------------------------------------------------------------------------
-- Autor: Lucia Makaikova <xmakai00@stud.fit.vutbr.cz>.
-- Autor: Tadeas Kachyna  <xkachy00@stud.fit.vutbr.cz>.



CREATE TABLE multikino
(
    id INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    jmeno VARCHAR(20) NOT NULL,
    ulice VARCHAR(20) NOT NULL,
    mesto VARCHAR(20) NOT NULL,
    psc INT NOT NULL
	CHECK(REGEXP_LIKE(
			"psc", '^[0-9]{5}$', 'i'
		)),
    trzby NUMBER DEFAULT 0 NOT NULL,
    vedouci_id INT DEFAULT NULL,
    CONSTRAINT "vedouci_multikino_id_fk"
    	FOREIGN KEY (vedouci_id) REFERENCES vedouci (id)
	ON DELETE CASCADE
);

CREATE TABLE kinosal
(
    cislo_salu INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    pocet_rad INT NOT NULL,
    -- počet sedadiel?
    velikost INT NOT NULL,
    typ VARCHAR(10) DEFAULT NULL,
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
    typ_projekce VARCHAR(10) DEFAULT '2D' NOT NULL,
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
    id  INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    jmeno       VARCHAR(255) NOT NULL,
    prijmeni    VARCHAR(255) NOT NULL,
    ulice       VARCHAR(20)  NOT NULL,
    mesto       VARCHAR(20)  NOT NULL,
    psc         INT          NOT NULL
	CHECK(REGEXP_LIKE(
			"psc", '^[0-9]{5}$', 'i'
		)),
    telcislo INT        NOT NULL,
    typ      INT        NOT NULL,
    multikino_id INT DEFAULT NULL,
    CONSTRAINT "multikino_id_fk"
    	FOREIGN KEY (multikino_id) REFERENCES multikino (id)
	ON DELETE CASCADE,
    vedouci_id INT DEFAULT NULL,
	CONSTRAINT "vedouci_zamestnanec_id_fk"
		FOREIGN KEY (vedouci_id) REFERENCES vedouci (id)
		ON DELETE SET NULL
);

CREATE TABLE vedouci
(
    id  INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY
);

CREATE TABLE vstupenka
(
    id  INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    cas TIMESTAMP NOT NULL,
    rada    INT          NOT NULL,
    sedadlo INT          NOT NULL,
    tarif   VARCHAR(64)  NOT NULL,
    typ      INT        NOT NULL, --specializace online vstupenka
    stav_platby VARCHAR(16) NOT NULL,
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

CREATE TABLE zakaznik
(
    rc       INT          NOT NULL PRIMARY KEY,
    jmeno    VARCHAR(255) NOT NULL,
    prijmeni VARCHAR(255) NOT NULL,
    ulice       VARCHAR(20)  NOT NULL,
    mesto       VARCHAR(20)  NOT NULL,
    psc         INT          NOT NULL
	CHECK(REGEXP_LIKE(
			"psc", '^[0-9]{5}$', 'i'
		)),
	email VARCHAR(255),
    telcislo INT          NOT NULL
);

CREATE TABLE rezervace
(
    id  INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    zpusob_platby VARCHAR(255) NOT NULL,
    zakaznik_id INT DEFAULT 0 NOT NULL,
    CONSTRAINT "zakaznik_id_fk"
    	FOREIGN KEY (zakaznik_id) REFERENCES zakaznik (rc)
	ON DELETE CASCADE
);

------------------------------------ DROP TABLES --------------------------------------

DROP TABLE MULTIKINO;
DROP TABLE KINOSAL;
DROP TABLE PROMITANI;
DROP TABLE FILM;
DROP TABLE ZAMESTNANEC;
DROP TABLE VSTUPENKA;
DROP TABLE ZAKAZNIK;
DROP TABLE REZERVACE;

------------------------------------ INSERT -------------------------------------------
INSERT INTO multikino
(jmeno, ulice, mesto, psc, trzby)
VALUES
('Mlyny', 'Mlynska', 'Brno', 94302, 3065.10);

INSERT INTO kinosal
(cislo_salu, pocet_rad, velikost, typ)
VALUES
(12, 10, 250, '2D');

INSERT INTO promitani
(id, cislo_salu, delka_projekce, zacatek, konec, typ_projekce )
VALUES
(02, 12, 250, 250, '20:50', '2D');


SELECT * FROM KINOSAL;
SELECT * FROM PROMITANI;
