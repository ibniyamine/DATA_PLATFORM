🏥 Medical Data Pipeline
1. Présentation

Ce projet met en place une architecture Data Pipeline complète pour la gestion des données médicales à partir de sources legacy MySQL, API de petient et fichiers CSV, avec stockage objet MinIO.

Le pipeline suit le modèle Bronze → Silver → Gold pour l’ingestion, la transformation et la mise à disposition des données pour l’analyse.

Technologies utilisées :

Docker & Docker Compose

Apache Spark / PySpark

PostgreSQL

MySQL (Source Legacy)

MinIO (Stockage Objet)

API REST pour la récupération des visites médicales

Delta Lake pour la couche Gold

2. Structure du projet
project-root/
│
├── docker/                  # Dockerfiles et configurations spécifiques
│   └── python-spark/Dockerfile
│
├── notebooks/               # Notebooks Jupyter pour Bronze, Silver, Gold
│
├── scripts/
│   ├── init.sql             # Initialisation PostgreSQL
│   ├── init-mysql.sql       # Initialisation MySQL
│   └── init-minio.sh        # Création des buckets MinIO
│
├── data/                    # Données locales à charger dans MinIO
│
├── api/                     # Code de l’API REST pour les visites médicales
│   └── Dockerfile
│
└── docker-compose.yml       # Définition des services

3. Services Docker
Service	Description
postgres 	: source de stockage des donnes patients (PostgreSQL).

mysql	: Source de données legacy pour les patients.

phpmyadmin	 : Interface graphique pour visualiser les données MySQL.

minio	 : Stockage objet pour Bronze / Silver / Gold.

minio-init :  Initialisation des buckets MinIO.

python-spark	: Environnement Jupyter avec PySpark pour l’ingestion et la transformation.

api-medical	API REST fournissant les données de visites médicales.
4. Pré-requis

Docker ≥ 20.x

Docker Compose ≥ 2.x

Au moins 8GB RAM pour Spark et MinIO

Python 3.10+ (pour exécution locale si nécessaire)


5. Déploiement
5.1. Lancer tous les services
docker-compose up --build

5.2. Vérifier l’état des conteneurs
docker-compose ps

5.3. Accéder aux interfaces



Jupyter Notebook / PySpark : http://localhost:8888

MinIO Console : http://localhost:9001 
user: medicaladmin
mdp : MedicalSecurePass123!

PHPMyAdmin : http://localhost:8081

API Visites : http://localhost:8000/visits


6. Pipeline de données
6.1. Bronze

Ingestion brute des fichiers CSV, API et  des tables MySQL

Stockage des données dans MinIO (format Parquet).

6.2. Silver

Nettoyage des données (dates, doublons, nulls).

Uniformisation des formats et jointure entre les donnees patients de l'API et ceux de la db Mysql.

6.3. Gold

Modèle en étoile (Star Schema) pour analytics et reporting :

Fact Table : fact_visits

Dimensions : dim_patient, dim_medecin, dim_date

