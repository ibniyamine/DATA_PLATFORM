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

DATABASE_URL = os.getenv(
    "DATABASE_URL", 
    "postgresql://medical_user:MedicalDB_Pass2024!@postgres:5432/medical_datawarehouse"
)

def get_db_connection():
    return psycopg2.connect(DATABASE_URL)

class Patient(BaseModel):
    patient_id: int
    first_name: str
    last_name: str
    birth_date: str | None = None
    gender: str | None = None
    blood_type: str | None = None
    city: str | None = None
    phone: str | None = None
    email: str | None = None

class Visit(BaseModel):
    visit_id: int
    patient_id: int
    date_visite: str
    type_visite: str
    motif: str | None = None
    diagnostic: str | None = None
    medecin: str | None = None
    duree_minutes: int | None = None

@app.get("/")
def root():
    return {
        "message": "Medical Data API - PostgreSQL connecté",
        "status": "OK",
        "database": "medical_datawarehouse",
        "timestamp": datetime.now().isoformat()
    }

@app.get("/patients")
def get_all_patients():
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

@app.get("/visits")
def get_all_visits(limit: int = 100):
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("""
            SELECT visit_id, patient_id, date_visite, type_visite, motif, diagnostic, medecin, duree_minutes
            FROM gold.visits
            ORDER BY date_visite DESC
            LIMIT %s
        """, (limit,))
        columns = [desc[0] for desc in cur.description]
        visits = [dict(zip(columns, row)) for row in cur.fetchall()]
        cur.close()
        conn.close()
        return {"count": len(visits), "visits": visits}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
