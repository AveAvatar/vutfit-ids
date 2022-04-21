-- SQL skript pro vytvoření základních objektů schématu databáze
--------------------------------------------------------------------------------
-- Autor: Lucia Makaiková <xmakai00@stud.fit.vutbr.cz>
-- Autor: Tadeáš Kachyňa  <xkachy00@stud.fit.vutbr.cz>

-------------------------------- SMAZÁNÍ TABULEK -------------------------------

DROP TABLE VSTUPENKA;
DROP TABLE REZERVACE;
DROP TABLE ZAKAZNIK;
DROP TABLE ZAMESTNANEC;
DROP TABLE PROMITANI;
DROP TABLE FILM;
DROP TABLE KINOSAL;
DROP TABLE MULTIKINO;
DROP TABLE VEDOUCI;

------------------------------- VYTVOŘENÍ TABULEK ------------------------------

CREATE TABLE vedouci
(
    id INT NOT NULL PRIMARY KEY
);

CREATE TABLE multikino
(
    id INT NOT NULL PRIMARY KEY,
    jmeno VARCHAR(255) NOT NULL,
    mesto VARCHAR(255) NOT NULL,
    ulice VARCHAR(255) NOT NULL,
    cislo_domu INT NOT NULL,
    trzby NUMBER DEFAULT 0 NOT NULL,
    vedouci_id INT DEFAULT NULL UNIQUE,
    CONSTRAINT "vedouci_multikino_id_fk"
    	FOREIGN KEY (vedouci_id) REFERENCES vedouci (id)
	        ON DELETE SET NULL
);

CREATE TABLE kinosal
(
    cislo_salu INT  default NULL PRIMARY KEY,
    pocet_rad INT NOT NULL,
    pocet_sedadel INT NOT NULL,
    typ VARCHAR(16) DEFAULT '2D' NOT NULL,
    multikino_id INT NOT NULL,
    CONSTRAINT "multikino_id_fk"
    	FOREIGN KEY (multikino_id) REFERENCES multikino (id)
	        ON DELETE CASCADE
);

CREATE TABLE film
(
    id  INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    nazev VARCHAR(255) NOT NULL,
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
    mesto   VARCHAR(255) NOT NULL,
    ulice  VARCHAR(255) NOT NULL,
    cislo_domu INT NOT NULL,
    mzda INT NOT NULL,
    email VARCHAR(255)
	    CHECK(REGEXP_LIKE(
		    email, '^[a-z]+[a-z0-9\.]*@[a-z0-9\.-]+\.[a-z]{2,}$', 'i')),
    telcislo INT NOT NULL
        CHECK(REGEXP_LIKE(
            telcislo , '^((420|421)[0-9]{9})$', 'i')),
    multikino_id INT DEFAULT NULL,
    CONSTRAINT "multikino_id__fk"
    	FOREIGN KEY (multikino_id) REFERENCES multikino (id)
	        ON DELETE SET NULL,
    vedouci_id INT DEFAULT NULL, --ak null, zamestnanec neni vedouci
	CONSTRAINT "vedouci_zamestnanec_id__fk"
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
    mesto VARCHAR(255) NOT NULL,
    ulice VARCHAR(255)  NOT NULL,
    cislo_domu INT NOT NULL,
	email VARCHAR(255)
	    CHECK(REGEXP_LIKE(
		    email, '^[a-z]+[a-z0-9\.]*@[a-z0-9\.-]+\.[a-z]{2,}$', 'i')),
    telcislo INT NOT NULL
        CHECK(REGEXP_LIKE(
            telcislo , '^((420|421)[0-9]{9})$', 'i'))
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
    id INT GENERATED AS IDENTITY NOT NULL PRIMARY KEY,
    rada INT NOT NULL,
    sedadlo INT NOT NULL,
    tarif  VARCHAR(255) NOT NULL,
        CONSTRAINT tarif CHECK(tarif= 'Dospely' or tarif= 'Dite' or tarif= 'Student'),
    typ VARCHAR(255), --specializace online vstupenka
        CONSTRAINT typ CHECK(typ = 'Online' or typ = ''),
    stav_platby VARCHAR(255) NOT NULL,
        CONSTRAINT stav_platby CHECK(stav_platby= 'Zaplaceno' or stav_platby = 'Nezaplaceno'),
    rezervace_id INT DEFAULT NULL,
    zamestnanec_id INT DEFAULT NULL,
    promitani_id INT DEFAULT NULL, --pri zruseni promitani se uchovaji data o predanych vstupenkach
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

INSERT INTO VEDOUCI (id)
VALUES (1);
INSERT INTO VEDOUCI (id)
VALUES (2);

INSERT INTO MULTIKINO (id, jmeno, mesto,ulice, cislo_domu, trzby, vedouci_id)
VALUES (1000, 'OC OLYMPIA' , 'Modřice', 'U Dálnice ', 3, 123456, 1);
INSERT INTO MULTIKINO (id, jmeno, mesto, ulice, cislo_domu, trzby, vedouci_id)
VALUES (2000, 'OC Velky Špalíček' , 'Brno', 'Mečová 695', 43, 456687, 2);

INSERT INTO KINOSAL (pocet_rad, pocet_sedadel, multikino_id)
VALUES (15, 250, 1000);
INSERT INTO KINOSAL (pocet_rad, pocet_sedadel, typ, multikino_id)
VALUES (20, 300, '3D', 1000);
INSERT INTO KINOSAL (pocet_rad, pocet_sedadel, typ, multikino_id)
VALUES (15, 250, '2D', 1000);
INSERT INTO KINOSAL (pocet_rad, pocet_sedadel, typ, multikino_id)
VALUES (15, 250, '2D', 2);
INSERT INTO KINOSAL (pocet_rad, pocet_sedadel, typ, multikino_id)
VALUES (20, 300, '3D', 2);
INSERT INTO KINOSAL (pocet_rad, pocet_sedadel, typ, multikino_id)
VALUES (15, 250, '2D', 2);

INSERT INTO FILM (nazev, dabing, zanr)
VALUES ('FILM XYZ','český', 'komedie');
INSERT INTO FILM (nazev, dabing, titulky, zanr)
VALUES ('FILM ABC', 'anglický', 'české', 'komedie');
INSERT INTO FILM (nazev,dabing, zanr)
VALUES ('FILM LMN', 'český', 'drama');
INSERT INTO FILM (nazev,dabing, titulky, zanr)
VALUES ('FILM PQR', 'německý', 'české','drama');

INSERT INTO promitani( delka_projekce, zacatek, konec, cislo_salu, film_id)
VALUES (120, '21-12-2021 12:00:00', '21-12-2021 14:00:00', 2, 1);
INSERT INTO promitani( delka_projekce, zacatek, konec, cislo_salu, film_id)
VALUES (90, '21-12-2021 14:00:00', '21-12-2021 15:30:00', 4, 2);
INSERT INTO promitani( delka_projekce, zacatek, konec, cislo_salu, film_id)
VALUES (180, '22-12-2021 18:00:00', '22-12-2021 21:00:00', 5, 4);
INSERT INTO promitani( delka_projekce, zacatek, konec, cislo_salu, film_id)
VALUES (180, '22-12-2021 12:00:00', '23-12-2021 15:00:00', 2, 4);
INSERT INTO promitani( delka_projekce, zacatek, konec, cislo_salu, film_id)
VALUES (180, '23-12-2021 14:00:00', '23-12-2021 17:00:00', 4, 4);
INSERT INTO promitani( delka_projekce, zacatek, konec, cislo_salu, film_id)
VALUES (100, '23-12-2021 11:00:00', '23-12-2021 12:40:00', 5, 3);

INSERT INTO zamestnanec(jmeno, prijmeni, mesto, ulice, cislo_domu, mzda, email, telcislo, multikino_id, vedouci_id)
VALUES('Pan', 'A', 'Modřice', 'Husova', 33, 45555, 'vedouci@multikino2.cz', 420111111111, 2, 2);
INSERT INTO zamestnanec(jmeno, prijmeni, mesto, ulice, cislo_domu, mzda, email, telcislo, multikino_id, vedouci_id)
VALUES('Pan', 'B', 'Brno', 'Česká', 23,  55655, 'vedouci@multikino1.cz', 420111111111, 1, 1);
INSERT INTO zamestnanec(jmeno, prijmeni, mesto, ulice, cislo_domu, mzda, email, telcislo, multikino_id)
VALUES('Paní', 'C', 'Brno', 'Hlavní', 30,  15555, 'zamestnanec3@multikino1.cz', 420111111111, 1);
INSERT INTO zamestnanec(jmeno, prijmeni, mesto, ulice, cislo_domu, mzda, email, telcislo, multikino_id)
VALUES('Pan', 'D', 'Brno', 'Jánská', 40,  25555, 'zamestnanec4@multikino1.cz', 420111111111, 1);

INSERT INTO zakaznik(rc, jmeno, prijmeni, mesto, ulice, cislo_domu, email, telcislo)
VALUES(7204250999 ,'Pan', 'Y', 'Brno', 'Hlavní', 12, 'panx@seznam.cz', 420111111111);
INSERT INTO zakaznik(rc, jmeno, prijmeni, mesto, ulice, cislo_domu, email, telcislo)
VALUES(6162256386 ,'Paní', 'Y', 'Praha', 'Masarykova', 24, 'paniy@email.cz', 420222222222);
INSERT INTO zakaznik(rc, jmeno, prijmeni, mesto, ulice, cislo_domu, email, telcislo)
VALUES(8160080610 ,'Paní', 'Z', 'Praha', 'Masarykova', 25, 'paniy@email.cz', 420222222222);

INSERT INTO rezervace(zpusob_platby, zakaznik_id)
VALUES ('Hotove', 7204250999);
INSERT INTO rezervace(zpusob_platby, zakaznik_id)
VALUES ('Hotove', 7204250999);
INSERT INTO  rezervace(zpusob_platby, zakaznik_id)
VALUES ('Online', 7204250999);
INSERT INTO  rezervace(zpusob_platby, zakaznik_id)
VALUES ('Online', 6162256386);

INSERT INTO VSTUPENKA (rada, sedadlo, tarif, typ, stav_platby, rezervace_id, zamestnanec_id, promitani_id )
VALUES (4, 9, 'Dospely', '', 'Zaplaceno', 1, 2, 2);
INSERT INTO VSTUPENKA (rada, sedadlo, tarif, typ, stav_platby, rezervace_id, zamestnanec_id, promitani_id )
VALUES (4, 8, 'Dospely', '', 'Zaplaceno', 1, 2, 2);
INSERT INTO VSTUPENKA (rada, sedadlo, tarif, typ, stav_platby, rezervace_id, zamestnanec_id, promitani_id )
VALUES (4, 10, 'Dite', '', 'Zaplaceno', 1, 2, 2);
INSERT INTO VSTUPENKA (rada, sedadlo, tarif, typ, stav_platby, rezervace_id, zamestnanec_id, promitani_id )
VALUES (5, 12, 'Student', '', 'Zaplaceno', 2, 4, 5);
INSERT INTO VSTUPENKA (rada, sedadlo, tarif, typ, stav_platby, rezervace_id, zamestnanec_id, promitani_id )
VALUES (5, 11, 'Dospely', '', 'Zaplaceno', 2, 4, 5);
INSERT INTO VSTUPENKA (rada, sedadlo, tarif, typ, stav_platby, rezervace_id, zamestnanec_id, promitani_id )
VALUES (10, 1, 'Dite', '', 'Zaplaceno', 1, 3, 3);
INSERT INTO VSTUPENKA (rada, sedadlo, tarif, typ, stav_platby, rezervace_id,  promitani_id )
VALUES (5, 22, 'Dospely', 'Online', 'Zaplaceno', 2, 1);
INSERT INTO VSTUPENKA (rada, sedadlo, tarif, typ, stav_platby, rezervace_id, promitani_id )
VALUES (4, 23, 'Student', 'Online', 'Nezaplaceno', 3, 1);

----------------------------------------- TRIGGERS -----------------------------------------


CREATE SEQUENCE salCislo START WITH 10 increment by 10;
CREATE OR REPLACE TRIGGER znaceni_salu
    BEFORE INSERT ON KINOSAL
    FOR EACH ROW
BEGIN
    IF :NEW.cislo_salu IS NULL THEN

        :NEW.cislo_salu :=  :NEW.multikino_id + salCislo.currval ;
    end if;

END;

CREATE OR REPLACE TRIGGER prevod_na_eura
  BEFORE INSERT ON multikino
  FOR EACH ROW
BEGIN
    :NEW.trzby := :NEW.trzby / 27;
END;

SELECT * FROM multikino;


CREATE OR REPLACE TRIGGER kontrolaRodnehoCisla
        BEFORE INSERT OR UPDATE OF rc ON zakaznik
        FOR EACH ROW
DECLARE
        rc zakaznik.rc%TYPE;
        rok VARCHAR(4);
        mesic VARCHAR(2);
        den VARCHAR(2);
        koncovka VARCHAR(4);
        boolRC BOOLEAN;
        boolECP BOOLEAN;
BEGIN
        rc := :NEW.rc;
        rok := SUBSTR(rc, 1, 2);
        mesic := SUBSTR(rc, 3, 2);
        den := SUBSTR(rc, 5, 2);

        -- Kontrola na numericke znaky
        IF (LENGTH(TRIM(TRANSLATE(rc, '0123456789', ' '))) != NULL) THEN
                RAISE_APPLICATION_ERROR(-20203, 'Neplatne znaky v rodnem cisle!');
        END IF;

        -- Koncovka ma 4
        IF (LENGTH(rc) = 10) THEN
            koncovka := SUBSTR(rc, 7, 4);

            -- musi byt delitelna 11
            IF (MOD(rc,11) != 0) THEN
                    RAISE_APPLICATION_ERROR(-20203, 'Rodne cislo neni delitelne 11!');
            END IF;

            IF (rok > 53) THEN
                rok := rok + 1900;
            ELSE
                rok := rok + 2000;
            END IF;

        ELSIF (LENGTH(rc) = 9) THEN
            koncovka := SUBSTR(rc, 7, 3);

            IF (koncovka = 000) THEN
                    RAISE_APPLICATION_ERROR(-20203, 'Nespravny pocet znaku pro rodne cislo!');
            END IF;

        ELSE
                RAISE_APPLICATION_ERROR(-20203, 'Nespravny pocet znaku pro rodne cislo!');
        END IF;

        IF (mesic > 50) THEN
            mesic := mesic - 50;
        END IF;

        IF (mesic > 20) THEN
            boolRC := TRUE;
            mesic := mesic - 20;
        END IF;

        IF (den > 40) THEN
            boolECP := TRUE;
            den := den - 40;
        END IF;

        IF (boolECP = TRUE AND boolRC = TRUE) THEN
            RAISE_APPLICATION_ERROR(-20203, 'Neplatne cislo ECP/RC');
        END IF;
        ---------------------------------------
        IF (mesic <= 0 AND mesic > 12) THEN
            RAISE_APPLICATION_ERROR(-20203, 'Mesic mimo rozsah');
        END IF;

        IF (mesic <= 0 AND mesic > 31) THEN
            RAISE_APPLICATION_ERROR(-20203, 'Den mimo rozsah');
        END IF;

        IF ((mesic = 4 OR mesic = 6 OR mesic = 9 OR mesic = 11) AND den > 30) THEN
            RAISE_APPLICATION_ERROR(-20203, 'Den mimo rozsah');
        ELSIF (mesic = 2) THEN
            IF(den > 29) THEN
                RAISE_APPLICATION_ERROR(-20203, 'Den mimo rozsah');
            ELSIF (den = 29) THEN
                IF (MOD(rok, 4) != 0) THEN
                    IF (MOD(rok, 400) != 0) THEN
                        RAISE_APPLICATION_ERROR(-20203, 'Rok nebyl prestupny');
                    END IF;
                ELSIF (((MOD(rok, 4) = 0) OR (MOD(rok, 400) = 0)) AND (MOD(rok,100) = 0)) THEN
				    Raise_Application_Error (-20203, 'rok ' || rok ||' nebol priestupny!');
			    END IF;


            END IF;
        END IF;

END kontrolaRodnehoCisla;

--------------------------------------- PROCEDURY ------------------------------------------

-- dalsi procedura -- nejvice prodanych vsutpenek dle tarifu / kolik to je ze vsech plus kolik tvori online a hotove zaplacene


CREATE OR REPLACE PROCEDURE prumernaMzda
IS
CURSOR pracovnik IS SELECT * FROM ZAMESTNANEC;
act_row Zamestnanec%ROWTYPE;
plat INT;
pocet INT;
BEGIN
plat := 0;
pocet := 0;
OPEN pracovnik;
LOOP
FETCH pracovnik INTO act_row;
EXIT WHEN pracovnik%NOTFOUND;
plat := plat + act_row.mzda;
pocet := pocet + 1;
END LOOP;
DBMS_OUTPUT.PUT_LINE('Prumerna mzda zamestnance v kine je CZK ' || ROUND(plat/pocet));
EXCEPTION
WHEN ZERO_DIVIDE THEN
DBMS_OUTPUT.PUT_LINE('Sit multikin nema zadne zamestnance');
end;


----------------------------------------- SELECTS ------------------------------------------

-- Kdy byly promítané jednotlivé filmy (seřazené podle začátku promítání)
-- spojení dvou tabulek
-- (název filmy, začátek promítání, konec promítání)
SELECT F.nazev,
       P.zacatek,
       P.konec,
       P.id AS cislo_promitani
FROM PROMITAni P, FILM F
WHERE F.id = P.film_id
ORDER BY P.zacatek;

-- Kteří zaměstnanci pracují v multikinu Olympia?
-- spojení dvou tabulek
-- (id, jméno, příjmení)
SELECT  Z.id,
        Z.jmeno,
        Z.prijmeni
FROM MULTIKINO M
JOIN ZAMESTNANEC Z ON M.id = Z.multikino_id
WHERE M.jmeno = 'OC OLYMPIA'
ORDER BY M.jmeno, Z.prijmeni;

-- Kolik promítání proběhlo v jednotlivích multikinech
-- spojení tří tabulek
-- (jméno, počet promítání)
SELECT
    M.jmeno,
    COUNT(P.id) AS pocet_promitani
FROM MULTIKINO M, KINOSAL K, PROMITANI P
WHERE P.cislo_salu = K.cislo_salu
  AND K.multikino_id = M.id
GROUP BY M.jmeno
ORDER BY pocet_promitani DESC;

-- Zaměstnanci kteří prodali více než 1 vstupenku, a kolik jich prodali
-- klauzule GROUP BY s použitím agregační funkce
-- (id, jméno, příjmení, počet prodaných vstupenek)
SELECT
    Z.jmeno,
    Z.prijmeni,
    COUNT(V.id) AS pocet_vstupenek
FROM ZAMESTNANEC Z
JOIN VSTUPENKA V ON Z.id = V.zamestnanec_id
GROUP BY Z.jmeno, Z.prijmeni
HAVING COUNT(V.id) > 1
ORDER BY Z.jmeno, Z.prijmeni;

-- Na který se film se prodalo kolik vstupenek
-- klauzule GROUP BY s použitím agregační funkce
-- (id filmu, název filmu, počet prodaných vstupenek)
SELECT
    F.id,
    F.nazev,
    COUNT(V.id) as pocet_vstupenek
FROM VSTUPENKA V, PROMITANI P, FILM F
WHERE V.promitani_id = P.id AND P.film_id = F.id
GROUP BY F.id, F.nazev
HAVING COUNT(V.id) >= ALL (
        SELECT COUNT(F1.id)
        FROM  FILM F1
        GROUP BY F1.id
    );

-- Kteří zaměstnanci prodali alespoň nějakou vstupenku a nejsou zároveň vedoucím multikina
-- predikát EXIST
-- (id, jméno, příjmení)
SELECT
    Z.id,
    Z.jmeno,
    Z.prijmeni
FROM ZAMESTNANEC Z
WHERE EXISTS(
        SELECT *
        FROM VSTUPENKA V
        WHERE z.id = v.zamestnanec_id)
AND vedouci_id IS NULL
ORDER BY Z.id;

-- Který zákazník nemá žádné rezervace
-- predikát IN s vnořeným SELECT
-- (rodné číslo, jméno, příjmení)
SELECT
    Z.rc,
    Z.jmeno,
    Z.prijmeni
FROM ZAKAZNIK Z
WHERE z.rc NOT IN (
    SELECT r.zakaznik_id
    FROM REZERVACE R
);
------------------------------------------- RIGHTS ------------------------------------------

GRANT ALL ON FILM TO XMAKAI00;
GRANT ALL ON KINOSAL TO XMAKAI00;
GRANT ALL ON MULTIKINO TO XMAKAI00;
GRANT ALL ON PROMITANI TO XMAKAI00;
GRANT ALL ON REZERVACE TO XMAKAI00;
GRANT ALL ON TRANSAKCE TO XMAKAI00;
GRANT ALL ON VEDOUCI TO XMAKAI00;
GRANT ALL ON VSTUPENKA TO XMAKAI00;
GRANT ALL ON ZAKAZNIK TO XMAKAI00;
GRANT ALL ON ZAMESTNANEC TO XMAKAI00;

----------------------------------- MATERIALIZOVANY POHLED ----------------------------------
-- still lotta work, TBD

CREATE MATERIALIZED VIEW LOG ON ZAMESTNANEC WITH PRIMARY KEY, ROWID(jmeno, prijmeni, email, telcislo) INCLUDING NEW VALUES ;
CREATE MATERIALIZED VIEW seznamZamestancu
BUILD IMMEDIATE
REFRESH FAST ON COMMIT
ENABLE QUERY REWRITE
AS
SELECT ZAMESTNANEC.jmeno, zamestnanec.prijmeni, zamestnanec.id, zamestnanec.mzda
FROM ZAMESTNANEC;

DELETE FROM seznamZamestancu WHERE prijmeni = 'A';
SELECT * FROM ZAMESTNANEC;

commit ;
SELECT * FROM seznamZamestancu;

BEGIN
prumernaMzda;
END;
------------------------------------ ZOBRAZENÍ TABULEK --------------------------------------

SELECT * FROM VEDOUCI;
SELECT * FROM MULTIKINO;
SELECT * FROM KINOSAL;
SELECT * FROM FILM;
SELECT * FROM PROMITANI;
SELECT * FROM ZAMESTNANEC;
SELECT * FROM REZERVACE;
SELECT * FROM VSTUPENKA;
SELECT * FROM ZAKAZNIK;
