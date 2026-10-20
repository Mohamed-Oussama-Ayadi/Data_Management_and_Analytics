---------------------------------------TP0----------------------------------------------------------------
---------------------------------------Aymen Zouari & Salma Damak-----------------------------------------
---------------------------------------4ERP-BI4-----------------------------------------------------------
--1--
create table Medicament 
(
	code INT NOT NULL, 
	libelle varchar(255) NOT NULL,
	Constraint pk_medicament PRIMARY KEY (code)
);
create table Medecin 
(
	matricule varchar(50) NOT NULL, 
	nom varchar(30) NOT NULL, 
	prenom varchar(30) NOT NULL,
	Constraint pk_medecin PRIMARY KEY (matricule)
);
create table Patient
(
	num_patient INT NOT NULL, 
	nom varchar(30) NOT NULL, 
	prenom varchar(30) NOT NULL,
	age int NOT NULL,
	num_tel int,
	Constraint pk_patient PRIMARY KEY (num_patient)
);
create table Fiche_Consultation
(
	num_consultation INT NOT NULL, 
	date_cons date NOT NULL,
	matricule varchar(50) NOT NULL,
	num_patient int NOT NULL,
	Constraint pk_fiche PRIMARY KEY (num_consultation),
	Constraint k1 FOREIGN KEY (matricule) REFERENCES Medecin(matricule),
	Constraint k2 FOREIGN KEY (num_patient) REFERENCES Patient(num_patient)
);
create table Prescrit 
(
	code int NOT NULL,
	num_consultation int NOT NULL,
	CONSTRAINT k3 FOREIGN KEY (code) REFERENCES Medicament(code),
	CONSTRAINT k4 FOREIGN KEY (num_consultation) REFERENCES Fiche_Consultation (num_consultation),
	CONSTRAINT PK_code PRIMARY KEY (code,num_consultation)
);
--2--
INSERT INTO Medicament VALUES (1, 'Medicament1');
INSERT INTO Medicament VALUES (2, 'Medicament2');
INSERT INTO Medicament VALUES (3, 'Medicament3');

INSERT INTO Medecin VALUES (1, 'Jouni','Ali');
INSERT INTO Medecin VALUES (2, 'Trabelsi','Slim');
INSERT INTO Medecin VALUES (3, 'Tounsi','Jamel');

INSERT INTO Patient VALUES (1, 'Ayari','Sarra',25,NULL);
INSERT INTO Patient VALUES (2, 'Mannai','Amine',30,'78111222');
INSERT INTO Patient VALUES (3, 'Miledi','Nabil',40,'74999333');

UPDATE Fiche_Consultation SET date_cons = TO_DATE(date_cons, 'YYYY-MM-DD');
INSERT INTO Fiche_Consultation VALUES (10, '2008-05-01', 1, 1);
INSERT INTO Fiche_Consultation VALUES (20, '2008-05-10', 2, 2);
INSERT INTO Fiche_Consultation VALUES (30, '2008-04-12', 3, 3);

INSERT INTO Prescrit VALUES (1,10);
INSERT INTO Prescrit VALUES (2,20);
INSERT INTO Prescrit VALUES (1,30);
--3--
UPDATE Patient SET num_tel = '71999222' WHERE num_patient = 1;
--4--
UPDATE Medicament SET libelle = 'Panadol' WHERE code = 1;
--5--
DELETE FROM Medicament WHERE libelle = 'Medicament3';
--6--
SELECT num_patient, nom, prenom FROM Patient WHERE age >= 30;
--7--
SELECT COUNT(*) FROM Patient WHERE num_tel IS NOT NULL;
--8--
SELECT M.nom AS nom_medecin, fc.date_cons AS date_consultation FROM Fiche_Consultation fc
INNER JOIN Medecin M ON fc.matricule = M.matricule
INNER JOIN Patient P ON fc.num_patient = P.num_patient
WHERE P.nom = 'Mannai' AND P.prenom = 'Amine';
--9--
SELECT M.libelle AS nom_medicament FROM Medicament M
INNER JOIN Prescrit Pres ON M.code = Pres.code 
INNER JOIN Fiche_Consultation fc ON Pres.num_consultation = fc.num_consultation
INNER JOIN Patient P ON fc.num_patient = P.num_patient
WHERE P.num_patient = 1;
--10--
CREATE VIEW PatientsNumTel AS SELECT * FROM Patient WHERE num_tel IS NOT NULL;
---------------------------------------FIN--------------------------------------------------------------
