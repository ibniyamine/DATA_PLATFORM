-- Création des schémas
CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;

-- =====================================================
-- TABLE DES PATIENTS (Couche Gold)
-- =====================================================
CREATE TABLE IF NOT EXISTS gold.patients (
    patient_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
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

-- =====================================================
-- TABLE DES VISITES MÉDICALES
-- =====================================================
CREATE TABLE IF NOT EXISTS gold.visits (
    visit_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID REFERENCES gold.patients(patient_id),
    visit_date DATE DEFAULT CURRENT_DATE,
    visit_type VARCHAR(50) DEFAULT 'Consultation',
    diagnosis_code VARCHAR(20),
    diagnosis_description TEXT,
    cost DECIMAL(10,2) DEFAULT 0.0,
    duration_minutes INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- DONNÉES DE TEST
-- =====================================================

-- Insertion de patients
INSERT INTO gold.patients (first_name, last_name, birth_date, gender, blood_type, city, phone, email) VALUES
('Jean', 'Martin', '1978-05-12', 'M', 'A+', 'Paris', '0612345678', 'jean.martin@email.fr'),
('Marie', 'Bernard', '1985-09-23', 'F', 'O-', 'Lyon', '0698765432', 'marie.bernard@email.fr'),
('Pierre', 'Dubois', '1990-03-15', 'M', 'B+', 'Marseille', '0654321987', 'pierre.dubois@email.fr'),
('Sophie', 'Thomas', '1975-11-08', 'F', 'AB+', 'Toulouse', '0678912345', 'sophie.thomas@email.fr'),
('Michel', 'Robert', '1982-07-30', 'M', 'A-', 'Nice', '0632165498', 'michel.robert@email.fr'),
('Christine', 'Petit', '1988-12-04', 'F', 'O+', 'Nantes', '0645678912', 'christine.petit@email.fr'),
('Philippe', 'Durand', '1970-01-18', 'M', 'B-', 'Strasbourg', '0689123456', 'philippe.durand@email.fr'),
('Nathalie', 'Leroy', '1995-06-25', 'F', 'A+', 'Montpellier', '0612987654', 'nathalie.leroy@email.fr');

-- Insertion de visites médicales
INSERT INTO gold.visits (patient_id, visit_date, visit_type, diagnosis_code, diagnosis_description, cost, duration_minutes)
SELECT 
    p.patient_id,
    CURRENT_DATE - (random() * 365)::integer,
    CASE (random() * 3)::integer 
        WHEN 0 THEN 'Consultation'
        WHEN 1 THEN 'Urgence'
        WHEN 2 THEN 'Suivi'
        ELSE 'Contrôle'
    END,
    'ICD10-' || (100 + (random() * 900)::integer),
    CASE (random() * 5)::integer
        WHEN 0 THEN 'Hypertension artérielle'
        WHEN 1 THEN 'Diabète type 2'
        WHEN 2 THEN 'Bronchite aiguë'
        WHEN 3 THEN 'Migraine chronique'
        ELSE 'Anxiété généralisée'
    END,
    (random() * 500 + 25)::decimal(10,2),
    (random() * 60 + 15)::integer
FROM gold.patients p
CROSS JOIN generate_series(1, 3 + (random() * 5)::integer);

-- =====================================================
-- VUES POUR L'API
-- =====================================================

-- Vue synthèse patient
CREATE OR REPLACE VIEW gold.vw_patient_summary AS
SELECT 
    p.patient_id,
    p.first_name || ' ' || p.last_name AS full_name,
    p.city,
    p.blood_type,
    COUNT(v.visit_id) AS total_visits,
    COALESCE(SUM(v.cost), 0) AS total_cost,
    MAX(v.visit_date) AS last_visit_date
FROM gold.patients p
LEFT JOIN gold.visits v ON p.patient_id = v.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name, p.city, p.blood_type;

-- Vue statistiques mensuelles
CREATE OR REPLACE VIEW gold.vw_monthly_stats AS
SELECT 
    TO_CHAR(visit_date, 'YYYY-MM') AS month,
    visit_type,
    COUNT(*) AS visit_count,
    AVG(cost) AS avg_cost,
    SUM(cost) AS total_revenue
FROM gold.visits
GROUP BY TO_CHAR(visit_date, 'YYYY-MM'), visit_type
ORDER BY month DESC;

-- Création d'un utilisateur readonly pour l'API (optionnel)
-- CREATE USER api_reader WITH PASSWORD 'readonly_pass';
-- GRANT SELECT ON ALL TABLES IN SCHEMA gold TO api_reader;