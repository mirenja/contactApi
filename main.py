import functions_framework
from flask import Flask, request, jsonify
from flask_cors import CORS
import os
from dotenv import load_dotenv
from .extensions.database import get_database

load_dotenv()


app = Flask(__name__)

db = get_database()
collection = db["contacts"]


CORS(app,
     supports_credentials=True,
     resources={r"/api/*": {
         "origins": frontend_origin,
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
