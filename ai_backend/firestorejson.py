import firebase_admin
from firebase_admin import credentials, firestore
import json
from datetime import datetime

cred = credentials.Certificate("hand-sign-app-firebase-adminsdk-fbsvc-9b2fdaf156.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

def convert_to_json_serializable(obj):
    if isinstance(obj, dict):
        return {k: convert_to_json_serializable(v) for k, v in obj.items()}
    elif isinstance(obj, list):
        return [convert_to_json_serializable(i) for i in obj]
    elif hasattr(obj, 'isoformat'):  # Xử lý DatetimeWithNanoseconds
        return obj.isoformat()
    else:
        return obj

def export_firestore_to_json():
    result = {}
    collections = db.collections()

    for collection in collections:
        result[collection.id] = {}
        for doc in collection.stream():
            doc_data = convert_to_json_serializable(doc.to_dict())
            result[collection.id][doc.id] = doc_data

    with open('firestore_export.json', 'w', encoding='utf-8') as f:
        json.dump(result, f, ensure_ascii=False, indent=4)

export_firestore_to_json()
