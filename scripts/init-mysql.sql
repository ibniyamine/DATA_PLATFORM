-- =====================================================
-- MYSQL - SOURCE EXTERNE (Système Hospitalier Legacy)
-- Port: 3307 | Database: hospital_legacy
-- =====================================================

USE hospital_legacy;

-- =====================================================
-- TABLE: PATIENTS (système legacy)
-- Données brutes d'un autre système hospitalier
-- =====================================================
CREATE TABLE IF NOT EXISTS patients_legacy (
  patient_id INT PRIMARY KEY,
  nom VARCHAR(50),
  prenom VARCHAR(50),
  date_naissance DATE,
  sexe CHAR(1),
  adresse TEXT,
  ville VARCHAR(50),
  code_postal VARCHAR(10),
  telephone VARCHAR(20),
  date_creation DATE
);

INSERT INTO patients_legacy (patient_id, nom, prenom, date_naissance, sexe, adresse, ville, code_postal, telephone, date_creation) VALUES
(1, 'Diallo', 'Aminata', '1985-06-12', 'F', 'Rue des Manguiers 12', 'Dakar', '11000', '771234567', '2020-01-15'),
(2, 'Ba', 'Moussa', '1978-03-22', 'M', 'Avenue Blaise Diagne', 'Thiès', '21000', '772345678', '2019-11-03'),
(3, 'Sow', 'Fatou', '1990-09-10', 'F', 'Rue 4, Médina', 'Dakar', '11000', '773456789', '2021-05-20'),
(4, 'Ndiaye', 'Ibrahima', '1982-12-01', 'M', 'Cité Keur Gorgui', 'Dakar', '11000', '774567890', '2018-07-12'),
(5, 'Fall', 'Awa', '1995-04-18', 'F', 'Rue des Jardins', 'Saint-Louis', '32000', '775678901', '2022-02-28'),
(6, 'Diop', 'Cheikh', '1975-08-30', 'M', 'Rue 10, Pikine', 'Dakar', '11000', '776789012', '2017-09-05'),
(7, 'Camara', 'Mariama', '1988-11-25', 'F', 'Rue des Palmiers', 'Ziguinchor', '44000', '777890123', '2020-06-17'),
(8, 'Gueye', 'Abdou', '1980-02-14', 'M', 'Rue 3, Liberté 6', 'Dakar', '11000', '778901234', '2016-03-10'),
(9, 'Kane', 'Seynabou', '1992-07-07', 'F', 'Rue des Acacias', 'Kaolack', '23000', '779012345', '2021-10-01'),
(10, 'Faye', 'Alioune', '1983-01-19', 'M', 'Rue 8, Parcelles', 'Dakar', '11000', '770123456', '2015-12-22'),
(11, 'Mbaye', 'Khady', '1991-05-05', 'F', 'Rue des Baobabs', 'Louga', '33000', '771234568', '2020-04-14'),
(12, 'Thiam', 'Mamadou', '1979-10-30', 'M', 'Rue 2, HLM', 'Dakar', '11000', '772345679', '2019-08-09'),
(13, 'Sy', 'Aissatou', '1986-03-17', 'F', 'Rue des Orangers', 'Fatick', '24000', '773456780', '2021-01-27'),
(14, 'Cissé', 'Ousmane', '1984-07-23', 'M', 'Rue 6, Ouakam', 'Dakar', '11000', '774567891', '2018-06-30'),
(15, 'Barry', 'Ndeye', '1993-12-11', 'F', 'Rue des Hibiscus', 'Tambacounda', '35000', '775678902', '2022-03-19'),
(16, 'Seck', 'Babacar', '1977-09-09', 'M', 'Rue 1, Grand Yoff', 'Dakar', '11000', '776789013', '2017-11-25'),
(17, 'Sarr', 'Aminata', '1989-04-04', 'F', 'Rue des Cocotiers', 'Kolda', '36000', '777890124', '2020-08-08'),
(18, 'Lo', 'Moussa', '1981-06-06', 'M', 'Rue 5, Fass', 'Dakar', '11000', '778901235', '2016-02-14'),
(19, 'Ndoye', 'Fatou', '1994-02-28', 'F', 'Rue des Tamariniers', 'Matam', '37000', '779012346', '2021-11-11'),
(20, 'Tall', 'Abdoulaye', '1987-11-03', 'M', 'Rue 7, Sacré-Cœur', 'Dakar', '11000', '770123457', '2015-10-05');
;