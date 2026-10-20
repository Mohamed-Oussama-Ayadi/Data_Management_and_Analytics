---------------------------------------TP3----------------------------------------------------------------
---------------------------------------Salma Damak--------------------------------------------------------
---------------------------------------4ERP-BI4-----------------------------------------------------------

-- 1. Création du profil profil_tp3 :
CREATE PROFILE profil_tp3 LIMIT
  CONNECT_TIME 120,
  IDLE_TIME 3,
  SESSIONS_PER_USER 2,
  FAILED_LOGIN_ATTEMPTS 1,
  PASSWORD_LOCK_TIME 5/1440;

-- 2. Création de l'utilisateur TP3 avec le profil profil_tp3, le tablespace USERS avec un quota de 10M et le tablespace temporaire TEMP :
CREATE USER TP3 IDENTIFIED BY test
  DEFAULT TABLESPACE USERS
  TEMPORARY TABLESPACE TEMP
  QUOTA 10M ON USERS
  PROFILE profil_tp3;

-- 3. Vérification de l'attribution du profil :
SELECT profile FROM DBA_USERS WHERE USERNAME = 'TP3';

-- 4. Liste des noms des utilisateurs créés dans le serveur :
SELECT USERNAME FROM DBA_USERS;

-- 5. Création d'une procédure qui liste les profils créés dans le serveur :
CREATE OR REPLACE PROCEDURE list_profiles AS
BEGIN
  FOR profile_rec IN (SELECT PROFILE FROM DBA_PROFILES) LOOP
    DBMS_OUTPUT.PUT_LINE(profile_rec.PROFILE);
  END LOOP;
END;
/

-- 6. Création de la fonction verif_password :
CREATE OR REPLACE FUNCTION verif_password(p_username VARCHAR2, p_password VARCHAR2) RETURN BOOLEAN IS
BEGIN
  IF LENGTH(p_password) > 6
     AND (INSTR(p_password, '?') > 0 OR INSTR(p_password, '!') > 0 OR INSTR(p_password, '@') > 0)
     AND p_username != p_password THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
END;
/

-- 7. Modification du profil profil_tp3 pour utiliser la fonction verif_password :
ALTER PROFILE profil_tp3 LIMIT PASSWORD_VERIFY_FUNCTION verif_password;

-- 8. Test du profil avec les utilisateurs spécifiés :
CREATE USER testtp31 IDENTIFIED BY testtp31 PROFILE profil_tp3;
CREATE USER testtp32 IDENTIFIED BY system PROFILE profil_tp3;
CREATE USER testtp33 IDENTIFIED BY managers PROFILE profil_tp3;

-- 9. Suppression du profil profil_tp3 et vérification :
DROP PROFILE profil_tp3;
SELECT * FROM DBA_USERS WHERE USERNAME = 'TP3';
