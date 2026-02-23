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
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_code VARCHAR(50) UNIQUE NOT NULL,  -- Code interne legacy
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    date_of_birth DATE,
    gender ENUM('M', 'F', 'Other'),
    address VARCHAR(255),
    city VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    insurance_id VARCHAR(50),
    registration_date DATE,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =====================================================
-- TABLE: ADMISSIONS (historique des hospitalisations)
-- =====================================================
CREATE TABLE IF NOT EXISTS admissions (
    admission_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_code VARCHAR(50) NOT NULL,
    admission_date DATE NOT NULL,
    discharge_date DATE,
    department VARCHAR(100),
    room_number VARCHAR(20),
    bed_number VARCHAR(10),
    diagnosis_code VARCHAR(20),
    diagnosis_name VARCHAR(200),
    doctor_name VARCHAR(100),
    total_cost DECIMAL(10,2),
    status ENUM('Active', 'Discharged', 'Transferred') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- TABLE: PHARMACY (prescriptions médicaments)
-- =====================================================
CREATE TABLE IF NOT EXISTS pharmacy (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_code VARCHAR(50) NOT NULL,
    medication_name VARCHAR(200),
    dosage VARCHAR(50),
    frequency VARCHAR(50),
    start_date DATE,
    end_date DATE,
    prescribed_by VARCHAR(100),
    cost DECIMAL(8,2),
    status ENUM('Active', 'Completed', 'Cancelled') DEFAULT 'Active'
);

-- =====================================================
-- DONNÉES DE TEST (simulation système externe)
-- =====================================================

-- Patients du système legacy
INSERT INTO patients_legacy (patient_code, first_name, last_name, date_of_birth, 
                             gender, address, city, phone, email, insurance_id, registration_date)
VALUES 
    ('LEG001', 'Ahmed', 'Benali', '1980-03-15', 'M', '12 Rue de la Paix', 'Casablanca', '0611223344', 'ahmed.b@email.com', 'INS-45678', '2020-01-10'),
    ('LEG002', 'Fatima', 'Zahra', '1975-07-22', 'F', '45 Avenue Hassan II', 'Rabat', '0622334455', 'fatima.z@email.com', 'INS-56789', '2019-05-15'),
    ('LEG003', 'Omar', 'Idrissi', '1990-11-08', 'M', '78 Boulevard Mohammed V', 'Marrakech', '0633445566', 'omar.i@email.com', 'INS-67890', '2021-03-20'),
    ('LEG004', 'Yasmine', 'Tazi', '1985-09-30', 'F', '23 Rue des Oliviers', 'Tanger', '0644556677', 'yasmine.t@email.com', 'INS-78901', '2018-08-05'),
    ('LEG005', 'Karim', 'Fassi', '1978-12-12', 'M', '56 Avenue des FAR', 'Fès', '0655667788', 'karim.f@email.com', 'INS-89012', '2022-01-18');

-- Admissions historiques
INSERT INTO admissions (patient_code, admission_date, discharge_date, department, 
                        room_number, bed_number, diagnosis_code, diagnosis_name, 
                        doctor_name, total_cost, status)
VALUES 
    ('LEG001', '2024-01-10', '2024-01-15', 'Cardiologie', 'A-101', 'A', 'I25', 'Cardiopathie ischémique', 'Dr. Alami', 12500.00, 'Discharged'),
    ('LEG002', '2024-02-05', NULL, 'Neurologie', 'B-205', 'C', 'G43', 'Migraine chronique', 'Dr. Bennani', 8500.00, 'Active'),
    ('LEG003', '2024-01-20', '2024-01-22', 'Urgences', 'URG-01', '1', 'S72', 'Fracture fémur', 'Dr. Chraibi', 4500.00, 'Discharged'),
    ('LEG001', '2024-03-01', NULL, 'Cardiologie', 'A-103', 'B', 'I50', 'Insuffisance cardiaque', 'Dr. Alami', 15000.00, 'Active'),
    ('LEG004', '2023-12-15', '2024-01-05', 'Oncologie', 'C-301', 'A', 'C78', 'Métastases hépatiques', 'Dr. Daoudi', 35000.00, 'Discharged');

-- Prescriptions pharmacy
INSERT INTO pharmacy (patient_code, medication_name, dosage, frequency, 
                      start_date, end_date, prescribed_by, cost, status)
VALUES 
    ('LEG001', 'Aspirine', '100mg', '1x/jour', '2024-01-10', '2024-04-10', 'Dr. Alami', 45.00, 'Active'),
    ('LEG001', 'Atorvastatine', '20mg', '1x/soir', '2024-01-10', '2024-07-10', 'Dr. Alami', 120.00, 'Active'),
    ('LEG002', 'Sumatriptan', '50mg', 'Au besoin', '2024-02-05', '2024-05-05', 'Dr. Bennani', 85.00, 'Active'),
    ('LEG003', 'Paracétamol', '1g', '3x/jour', '2024-01-20', '2024-01-27', 'Dr. Chraibi', 15.00, 'Completed'),
    ('LEG004', 'Morphine', '10mg', '2x/jour', '2023-12-15', '2024-01-05', 'Dr. Daoudi', 250.00, 'Completed');

-- =====================================================
-- INDEXES POUR PERFORMANCE
-- =====================================================
CREATE INDEX idx_patients_code ON patients_legacy(patient_code);
CREATE INDEX idx_admissions_patient ON admissions(patient_code);
CREATE INDEX idx_admissions_date ON admissions(admission_date);
CREATE INDEX idx_pharmacy_patient ON pharmacy(patient_code);

-- =====================================================
-- UTILISATEUR LECTURE (pour future connexion ETL)
-- =====================================================
-- Déjà créé via MYSQL_USER, mais on peut ajouter des privilèges
GRANT SELECT ON hospital_legacy.* TO 'source_reader'@'%';
FLUSH PRIVILEGES;