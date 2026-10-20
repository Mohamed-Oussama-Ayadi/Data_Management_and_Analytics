---------------------------------------TP1----------------------------------------------------------------
---------------------------------------Salma Damak--------------------------------------------------------
---------------------------------------4ERP-BI4-----------------------------------------------------------
--1--
desc dict
SELECT table_name
FROM dict 
ORDER BY table_name;
--2--
SELECT USERNAME, CREATED 
FROM DBA_USERS ;
ORDER BY USERNAME;
--3--
SELECT username
FROM v$session
WHERE type = 'USER';
--4--
SELECT SUM(value)
FROM v$sga;
--connecter hr--
connect HR/HR;
--5--
SELECT object_name, object_type, created, last_ddl_time
FROM all_objects
WHERE owner = 'HR';
--6--
SELECT table_name
FROM all_tab_privs
WHERE grantee = 'HR';
--7--
CREATE OR REPLACE PROCEDURE afficher_tables_proprietaire(p_username IN VARCHAR2) AS
BEGIN
  FOR r IN (SELECT table_name FROM all_tables WHERE owner = p_username) LOOP
    DBMS_OUTPUT.PUT_LINE(r.table_name);
  END LOOP;
END;
--Exécution--
SET SERVEROUTPUT ON;
EXEC afficher_tables_proprietaire('HR');
--8--
SELECT COUNT(*) AS total_tables
FROM all_tables;
--9--
SELECT COUNT(*) AS total_tables_hr
FROM all_tables
WHERE owner = 'HR';
--10--
CREATE OR REPLACE FUNCTION nombre_objets(p_username IN VARCHAR2) RETURN NUMBER IS
  v_count NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO v_count
  FROM all_objects
  WHERE owner = p_username;
  
  RETURN v_count;
END;
--11--
--PARTIE DECLARATION--
DECLARE
  obj_count NUMBER;
BEGIN
  obj_count := nombre_objets('HR');
  DBMS_OUTPUT.PUT_LINE('Nombre d''objets pour HR : ' || obj_count);
END;
--PROCEDURE--
CREATE OR REPLACE PROCEDURE lister_tables_utilisateur(p_username IN VARCHAR2) AS
BEGIN
  FOR r IN (SELECT table_name FROM all_tables WHERE owner = p_username) LOOP
    DBMS_OUTPUT.PUT_LINE(r.table_name);
  END LOOP;
END;
--Exécution--
SET SERVEROUTPUT ON;
EXEC lister_tables_utilisateur('HR');
---------------------------------------FIN--------------------------------------------------------------
