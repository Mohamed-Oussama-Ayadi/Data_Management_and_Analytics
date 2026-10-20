---------------------------------------TP4----------------------------------------------------------------
---------------------------------------Salma Damak--------------------------------------------------------
---------------------------------------4ERP-BI4-----------------------------------------------------------

-- 1. Créez un rôle ROLE_TP3 regroupant les privilèges spécifiés :
CREATE ROLE ROLE_TP3;

GRANT CREATE SESSION TO ROLE_TP3;
GRANT CREATE TABLE TO ROLE_TP3;
GRANT CREATE ROLE TO ROLE_TP3;
GRANT CREATE PROCEDURE TO ROLE_TP3;
GRANT CREATE FUNCTION TO ROLE_TP3;
GRANT CREATE ANY PROCEDURE TO ROLE_TP3 WITH ADMIN OPTION;
GRANT CREATE ANY FUNCTION TO ROLE_TP3 WITH ADMIN OPTION;
GRANT SELECT, INSERT ON HR.EMPLOYEES TO ROLE_TP3;
GRANT SELECT, INSERT ON HR.DEPARTMENTS TO ROLE_TP3;


-- 2. Attribuez le rôle ROLE_TP3 à l'utilisateur TP3 :
GRANT ROLE_TP3 TO TP3;

-- 3. Connectez-vous avec TP3 et créez la table Etudiants :
CONNECT TP3
CREATE TABLE Etudiants (
  Matricule VARCHAR2(20) PRIMARY KEY,
  Nom VARCHAR2(50),
  Prenom VARCHAR2(50),
  Tel VARCHAR2(15),
  DateNaissance DATE
);

-- 4. Créez un utilisateur TP3_2 avec un quota de 5M sur USERS et attribuez-lui le profil profil_tp3 :
CREATE USER TP3_2 IDENTIFIED BY your_password
  DEFAULT TABLESPACE USERS
  QUOTA 5M ON USERS
  PROFILE profil_tp3;

-- 5. Attribuez le rôle ROLE_TP3 à l'utilisateur TP3_2 :
GRANT ROLE_TP3 TO TP3_2;

-- 6. Accordez à l'utilisateur TP3_2 les privilèges spécifiés :
GRANT SELECT, INSERT ON TP3.Etudiants TO TP3_2;

-- 7. Créez une procédure stockée qui affiche la liste des privilèges systèmes pour un utilisateur donné :
CREATE OR REPLACE PROCEDURE list_system_privileges(p_username VARCHAR2) AS
BEGIN
  FOR priv_rec IN (SELECT PRIVILEGE FROM DBA_SYS_PRIVS WHERE GRANTEE = p_username) LOOP
    DBMS_OUTPUT.PUT_LINE(priv_rec.PRIVILEGE);
  END LOOP;
END;
/

-- 8. Créez une procédure stockée qui affiche la liste des privilèges objets pour un rôle donné :
CREATE OR REPLACE PROCEDURE list_object_privileges(p_role VARCHAR2) AS
BEGIN
  FOR priv_rec IN (SELECT PRIVILEGE, TABLE_NAME FROM DBA_TAB_PRIVS WHERE GRANTEE = p_role) LOOP
    DBMS_OUTPUT.PUT_LINE(priv_rec.PRIVILEGE || ' on ' || priv_rec.TABLE_NAME);
  END LOOP;
END;
/

-- Tests
-- 7. Testez avec TP3 :
EXEC list_system_privileges('TP3');

-- 8. Testez avec ROLE_TP3 :
EXEC list_object_privileges('ROLE_TP3');














