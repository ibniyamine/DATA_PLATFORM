-- =====================================================
-- SCHÉMAS
-- =====================================================
CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;

-- =====================================================
-- TABLE DES PATIENTS (Gold)
-- =====================================================
DROP TABLE IF EXISTS gold.patients CASCADE;

CREATE TABLE gold.patients (
    patient_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    birth_date DATE,
    gender CHAR(1) CHECK (gender IN ('M', 'F', 'O')),
    blood_type VARCHAR(5),
    city VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Données patients
INSERT INTO gold.patients (first_name, last_name, birth_date, gender, blood_type, city, phone, email) VALUES
('Jean', 'Martin', '1978-05-12', 'M', 'A+', 'Paris', '0612345678', 'jean.martin@email.fr'),
('Marie', 'Bernard', '1985-09-23', 'F', 'O-', 'Lyon', '0698765432', 'marie.bernard@email.fr'),
('Pierre', 'Dubois', '1990-03-15', 'M', 'B+', 'Marseille', '0654321987', 'pierre.dubois@email.fr'),
('Sophie', 'Thomas', '1975-11-08', 'F', 'AB+', 'Toulouse', '0678912345', 'sophie.thomas@email.fr'),
('Michel', 'Robert', '1982-07-30', 'M', 'A-', 'Nice', '0632165498', 'michel.robert@email.fr'),
('Christine', 'Petit', '1988-12-04', 'F', 'O+', 'Nantes', '0645678912', 'christine.petit@email.fr'),
('Philippe', 'Durand', '1970-01-18', 'M', 'B-', 'Strasbourg', '0689123456', 'philippe.durand@email.fr'),
('Nathalie', 'Leroy', '1995-06-25', 'F', 'A+', 'Montpellier', '0612987654', 'nathalie.leroy@email.fr');

-- =====================================================
-- TABLE DES VISITES (Gold)
-- =====================================================
DROP TABLE IF EXISTS gold.visits;

CREATE TABLE gold.visits (
  visit_id SERIAL PRIMARY KEY,
  patient_id INT NOT NULL REFERENCES gold.patients(patient_id),
  date_visite TIMESTAMP NOT NULL,
  motif TEXT,
  diagnostic TEXT,
  medecin VARCHAR(100),
  type_visite VARCHAR(50),
  duree_minutes INT
);

-- Données visites
INSERT INTO gold.visits (patient_id, date_visite, motif, diagnostic, medecin, type_visite, duree_minutes) VALUES
(1, '2024-01-05 09:30:00', 'Fièvre', 'Paludisme', 'Dr. Ndiaye', 'consultation', 20),
(2, '2024-01-06 11:00:00', 'Toux persistante', 'Bronchite', 'Dr. Ba', 'consultation', 25),
(3, '2024-01-07 14:15:00', 'Douleurs abdominales', 'Gastro-entérite', 'Dr. Sow', 'urgence', 40),
(4, '2024-01-08 10:00:00', 'Suivi grossesse', 'Grossesse normale', 'Dr. Diouf', 'consultation', 30),
(5, '2024-01-09 16:45:00', 'Fièvre', 'Grippe', 'Dr. Faye', 'consultation', 15),
(6, '2024-01-10 08:30:00', 'Douleurs thoraciques', 'Angine', 'Dr. Ndiaye', 'urgence', 35),
(7, '2024-01-11 13:00:00', 'Vaccination', 'RAS', 'Dr. Camara', 'consultation', 10),
(8, '2024-01-12 09:00:00', 'Bilan sanguin', 'Anémie légère', 'Dr. Gaye', 'consultation', 20);
