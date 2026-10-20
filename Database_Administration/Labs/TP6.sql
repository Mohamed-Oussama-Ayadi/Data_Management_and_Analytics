---------------------------------------TP6----------------------------------------------------------------
---------------------------------------Salma Damak--------------------------------------------------------
---------------------------------------4ERP-BI4-----------------------------------------------------------

-- Partie 1: impdp / expdp

-- 1. Créer deux utilisateurs : user1/pwd1, user2/pwd2 
CREATE USER user1 IDENTIFIED BY pwd1;
CREATE USER user2 IDENTIFIED BY pwd2;

-- 2. Accorder les privilèges nécessaires à user1 et user2 
GRANT CREATE SESSION, CREATE TABLE, EXP_FULL_DATABASE, IMP_FULL_DATABASE TO user1, user2;

-- 3. Créer 2 tables sous le schéma user1
-- Connecter en tant que user1/pwd1
CREATE TABLE user1.Test1 (a1 NUMBER, b1 NUMBER);
CREATE TABLE user1.Test2 (a2 NUMBER, b2 NUMBER);

-- 4. Insérer 3 lignes dans chacune des tables 
-- Connecter en tant que user1/pwd1
INSERT INTO user1.Test1 VALUES (1, 2);
INSERT INTO user1.Test1 VALUES (3, 4);
INSERT INTO user1.Test1 VALUES (5, 6);

INSERT INTO user1.Test2 VALUES (7, 8);
INSERT INTO user1.Test2 VALUES (9, 10);
INSERT INTO user1.Test2 VALUES (11, 12);

-- 5. Créer un Directory Oracle sous le chemin ‘C:\oraclexe\app\oracle’ 
CREATE DIRECTORY oracle_dir AS 'C:\oraclexe\app\oracle';

-- 6. Accorder aux 2 users les privilèges de lecture/écriture dans le directory Oracle créé.
GRANT READ, WRITE ON DIRECTORY oracle_dir TO user1, user2;

-- 7. Exporter les 2 tables du schéma user1 dans un fichier nommé « user1.dump » 
EXPDP user1/pwd1@SID DUMPFILE=user1.dump DIRECTORY=oracle_dir TABLES=user1.Test1, user1.Test2

-- 8. Importer la table Test1, méta data seulement, au schéma user2. 
IMPDP user2/pwd2@SID DIRECTORY=oracle_dir DUMPFILE=user1.dump REMAP_SCHEMA=user1:user2 CONTENT=METADATA_ONLY

-- 9. Que doit afficher ces requêtes en se connectant sous le schéma user2 et pourquoi ? 
-- Les requêtes devraient afficher les informations sur la table importée (Test1) dans le schéma user2
SELECT * FROM tab; 
SELECT * FROM user2.Test1;

-- 10. Importer la table Test2, Metadata et Datas, au schéma user2. 
IMPDP user2/pwd2@SID DIRECTORY=oracle_dir DUMPFILE=user1.dump REMAP_SCHEMA=user1:user2 CONTENT=ALL

-- 11. Que doit afficher, maintenant, ces requêtes en se connectant sous le schéma user2 : 
-- Les requêtes devraient afficher les informations sur les tables importées (Test1 et Test2) dans le schéma user2
SELECT * FROM tab; 
SELECT * FROM user2.Test2;

-- Partie 2: SQL*Loader

-- 1. Créer la table Artiste
CREATE TABLE Artiste (
   identifiant NUMBER,
   nom VARCHAR2(30),
   prenom VARCHAR2(30),
   pays VARCHAR2(30)
);

-- 2. Ecrire le fichier de contrôle artiste.ctl
LOAD DATA
INFILE 'artiste.txt'
INTO TABLE Artiste
WHEN (1) = '0'
FIELDS TERMINATED BY ','
(identifiant, nom, prenom, pays)

-- 3. Charger le fichier emp.dat dans une table modified_data
LOAD DATA
INFILE 'emp.dat'
INTO TABLE modified_data
FIELDS TERMINATED BY ''
(rec_no SEQUENCE(1,1),
 region CHAR(31),
 load_date DATE "YYMMDD",
 data1 INTEGER EXTERNAL,
 data2 "UPPER(:data2)",
 data3 DATE "YYMMDD"
)

-- 4. Charger le fichier emp1.dat dans la table Emp selon les critères donnés
LOAD DATA
INFILE 'emp1.dat'
INTO TABLE Emp
WHEN (5:14) = 'B'
   AND (15:22) = '19990112'
FIELDS TERMINATED BY ''
(col1, col2, col3)








