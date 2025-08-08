from flask import Flask, request, jsonify
from flask_cors import CORS
import os
from dotenv import load_dotenv
from extensions.database import get_database
load_dotenv()


db = get_database()
collection = db["contacts"]


app = Flask(__name__)
app.config.from_object('config')
frontend_origin = os.getenv("FRONTEND_ORIGIN")
port = int(os.environ.get('PORT'))
# print(f"frontend origin {frontend_origin}")

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





if __name__ == '__main__':
  app.run(host="0.0.0.0", port=port, debug=True)