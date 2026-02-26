#!/bin/sh

mc alias set myminio http://minio:9000 medicaladmin MedicalSecurePass123!
mc mb -p myminio/bronze
mc mb -p myminio/silver
mc mb -p myminio/gold
