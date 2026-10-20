---------------------------------------TP2----------------------------------------------------------------
---------------------------------------Salma Damak--------------------------------------------------------
---------------------------------------4ERP-BI4-----------------------------------------------------------
--1--
create TABLESPACE TBL01
DATAFILE 'C:\oraclexe\app\oracle\product\11.2.0\fd01tbl01.dbf' SIZE 6M,
'C:\oraclexe\app\oracle\product\11.2.0\fd02tbl01.dbf' SIZE 4M;
--2--
ALTER DATABASE DEFAULT TABLESPACE TBL01;
--3--
CREATE TABLESPACE TBL02
DATAFILE 'C:\oraclexe\app\oracle\product\11.2.0\fd01tbl02.dbf' SIZE 10M,
'C:\oraclexe\app\oracle\product\11.2.0\fd02tbl02.dbf' SIZE 10M,
'C:\oraclexe\app\oracle\product\11.2.0\fd0xbl02.dbf' SIZE 5M;
--4--
ALTER TABLESPACE TBL01 ADD DATAFILE 'fd02tbl01.dbf' SIZE 20M;
--5--
ALTER DATABASE RENAME FILE 'fd0xbl02.dbf' TO 'fd03bl02.dbf';
--6--
SELECT tablespace_name FROM dba_tablespaces;
--7--
BEGIN
  FOR ts IN (SELECT tablespace_name, COUNT(file_id) AS num_files
             FROM dba_data_files
             GROUP BY tablespace_name)
  LOOP
    DBMS_OUTPUT.PUT_LINE('Tablespace: ' || ts.tablespace_name || ', Num Files: ' || ts.num_files);
  END LOOP;
END;
--8--
ALTER TABLESPACE TBL01 ADD DATAFILE 'fd04tlb01.dbf' SIZE 2M AUTOEXTEND ON NEXT 1M MAXSIZE 4M;
--9--
CREATE TEMPORARY TABLESPACE MonTemp TEMPFILE 'MonTemp.dbf' SIZE 5M;
ALTER DATABASE DEFAULT TEMPORARY TABLESPACE MonTemp;
--10--
CREATE OR REPLACE FUNCTION FN_NBR_TAB_TEMP RETURN NUMBER IS
  cnt NUMBER;
BEGIN
  SELECT COUNT(*) INTO cnt FROM dba_tablespaces WHERE contents = 'TEMPORARY';
  RETURN cnt;
END;
--11--
CREATE USER TD3 IDENTIFIED BY mot_de_passe DEFAULT TABLESPACE TBL01 TEMPORARY TABLESPACE MonTemp QUOTA UNLIMITED ON TBL01;
--12--
DROP TABLESPACE TBL01 INCLUDING CONTENTS AND DATAFILES;
--13--
CREATE OR REPLACE PROCEDURE PS_DETAILS_TAB IS
BEGIN
  FOR ts IN (SELECT tablespace_name,
                    ROUND(SUM(bytes) / 1024 / 1024, 2) AS total_size_mb,
                    ROUND(SUM(bytes - NVL(blocks * (block_size / 1024), 0)) / 1024 / 1024, 2) AS occupied_size_mb
             FROM dba_data_files
             GROUP BY tablespace_name)
  LOOP
    DBMS_OUTPUT.PUT_LINE('Tablespace: ' || ts.tablespace_name ||
                         ', Total Size: ' || ts.total_size_mb || ' MB' ||
                         ', Occupied Size: ' || ts.occupied_size_mb || ' MB');
  END LOOP;
END;
CONNECT TD3;
--14--
CREATE TABLE Etudiants
(num_etud NUMBER(10) PRIMARY KEY,
 nom_etud VARCHAR2(30),
 moyenne_etud NUMBER(4,2)
);
BEGIN
  FOR i IN 1 .. 10000 LOOP
    INSERT INTO Etudiants (num_etud, nom_etud, moyenne_etud) VALUES (i, 'Etudiant'||i, 10);
  END LOOP;
END;
CONNECT admin;
--15--
EXEC PS_DETAILS_TAB;