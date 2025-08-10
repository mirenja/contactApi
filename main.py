import functions_framework
from flask import Flask, request, jsonify
from flask_cors import CORS
import os
from dotenv import load_dotenv
from pymongo import MongoClient
from pymongo.errors import ConnectionFailure

load_dotenv()


app = Flask(__name__)

MONGODB_URI = os.getenv("MONGODB_URI")
FRONTEND_ORIGIN = os.getenv("FRONTEND_ORIGIN")

def get_database():
    # print(f"💽💽💽💽THE DATABASE URI is {CONNECTION_STRING}")
    client = MongoClient(MONGODB_URI)
    return client.get_default_database()

try:
    if not MONGODB_URI:
        raise Exception("MONGODB_URI environment variable is not set.")
    db = get_database()
    collection = db["contacts"]
    print("💽 Connected to API database:")
except Exception as e:
    print(f"An unexpected error occurred during database connection: {e}")
    

CORS(app,
     supports_credentials=True,
     resources={r"/api/*": {
         "origins": FRONTEND_ORIGIN,
         "methods": ["POST", "OPTIONS"],
         "allow_headers": ["Content-Type", "Authorization"],
     }})

@app.route("/api/contact", methods=["POST","OPTIONS"])
def contact():
    if request.method == "OPTIONS":
        return jsonify({"ok": True}), 200

    data = request.json
    required_fields = ["firstName", "lastName", "companyEmail", "phone", "companyName", "companySize"]
    missing = [f for f in required_fields if not data.get(f)]
    if missing:
        return jsonify({"error": f"Missing fields: {', '.join(missing)}"}), 400

    submission = data.copy()
    submission["status"] = "pending"

    collection.insert_one(submission)

    #Send confirmation email

    return jsonify({"message": "Contact submission received"}), 200

@functions_framework.http
def entry_point(request):
    with app.request_context(request.environ):
        return app.full_dispatch_request()
