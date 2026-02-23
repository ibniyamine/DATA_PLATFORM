from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from datetime import datetime
import psycopg2
import os

app = FastAPI(
    title="Medical Data API",
    description="API connectée à PostgreSQL (port 5433 externe, 5432 interne)",
    version="1.0.0"
)

# Configuration base de données
DATABASE_URL = os.getenv(
    "DATABASE_URL", 
    "postgresql://medical_user:MedicalDB_Pass2024!@postgres:5432/medical_datawarehouse"
)

def get_db_connection():
    """Crée une connexion à PostgreSQL"""
    return psycopg2.connect(DATABASE_URL)

# =====================================================
# MODÈLES DE DONNÉES
# =====================================================

class Patient(BaseModel):
    patient_id: str
    first_name: str
    last_name: str
    birth_date: str | None = None
    gender: str | None = None
    blood_type: str | None = None
    city: str | None = None
    phone: str | None = None
    email: str | None = None

class PatientCreate(BaseModel):
    first_name: str
    last_name: str
    birth_date: str | None = None
    gender: str | None = None
    blood_type: str | None = None
    city: str | None = None
    phone: str | None = None
    email: str | None = None

class Visit(BaseModel):
    visit_id: str
    patient_id: str
    visit_date: str
    visit_type: str
    diagnosis_description: str | None = None
    cost: float

# =====================================================
# ENDPOINTS
# =====================================================

@app.get("/")
def root():
    return {
        "message": "Medical Data API - PostgreSQL connecté",
        "status": "OK",
        "database": "medical_datawarehouse",
        "timestamp": datetime.now().isoformat()
    }

@app.get("/health")
def health_check():
    """Vérifie la connexion PostgreSQL"""
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("SELECT version();")
        version = cur.fetchone()[0]
        cur.close()
        conn.close()
        return {
            "status": "healthy",
            "database": "connected",
            "postgres_version": version
        }
    except Exception as e:
        return {"status": "unhealthy", "error": str(e)}

@app.get("/patients")
def get_all_patients():
    """Récupère tous les patients"""
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("""
            SELECT patient_id, first_name, last_name, birth_date, 
                   gender, blood_type, city, phone, email 
            FROM gold.patients 
            ORDER BY last_name, first_name
        """)
        
        columns = [desc[0] for desc in cur.description]
        patients = [dict(zip(columns, row)) for row in cur.fetchall()]
        
        cur.close()
        conn.close()
        
        return {"count": len(patients), "patients": patients}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/patients/{patient_id}")
def get_patient(patient_id: str):
    """Récupère un patient par son ID"""
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("""
            SELECT patient_id, first_name, last_name, birth_date, 
                   gender, blood_type, city, phone, email 
            FROM gold.patients 
            WHERE patient_id = %s
        """, (patient_id,))
        
        row = cur.fetchone()
        cur.close()
        conn.close()
        
        if not row:
            raise HTTPException(status_code=404, detail="Patient non trouvé")
        
        columns = ["patient_id", "first_name", "last_name", "birth_date", 
                   "gender", "blood_type", "city", "phone", "email"]
        return dict(zip(columns, row))
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/patients")
def create_patient(patient: PatientCreate):
    """Crée un nouveau patient"""
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("""
            INSERT INTO gold.patients (first_name, last_name, birth_date, gender, 
                                      blood_type, city, phone, email)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            RETURNING patient_id
        """, (patient.first_name, patient.last_name, patient.birth_date,
              patient.gender, patient.blood_type, patient.city, 
              patient.phone, patient.email))
        
        patient_id = cur.fetchone()[0]
        conn.commit()
        cur.close()
        conn.close()
        
        return {"message": "Patient créé", "patient_id": patient_id}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/visits")
def get_all_visits(limit: int = 100):
    """Récupère les visites (limité par défaut)"""
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("""
            SELECT v.visit_id, v.patient_id, p.first_name || ' ' || p.last_name as patient_name,
                   v.visit_date, v.visit_type, v.diagnosis_description, v.cost
            FROM gold.visits v
            JOIN gold.patients p ON v.patient_id = p.patient_id
            ORDER BY v.visit_date DESC
            LIMIT %s
        """, (limit,))
        
        columns = [desc[0] for desc in cur.description]
        visits = [dict(zip(columns, row)) for row in cur.fetchall()]
        
        cur.close()
        conn.close()
        
        return {"count": len(visits), "visits": visits}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/stats/summary")
def get_statistics():
    """Statistiques globales"""
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        
        stats = {}
        
        # Nombre de patients
        cur.execute("SELECT COUNT(*) FROM gold.patients")
        stats["total_patients"] = cur.fetchone()[0]
        
        # Nombre de visites
        cur.execute("SELECT COUNT(*) FROM gold.visits")
        stats["total_visits"] = cur.fetchone()[0]
        
        # Coût total
        cur.execute("SELECT COALESCE(SUM(cost), 0) FROM gold.visits")
        stats["total_revenue"] = float(cur.fetchone()[0])
        
        # Visites par type
        cur.execute("""
            SELECT visit_type, COUNT(*) as count 
            FROM gold.visits 
            GROUP BY visit_type
        """)
        stats["visits_by_type"] = {row[0]: row[1] for row in cur.fetchall()}
        
        cur.close()
        conn.close()
        
        return stats
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))