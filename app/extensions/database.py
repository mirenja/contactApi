from pymongo import MongoClient
import os
from dotenv import load_dotenv

load_dotenv()

def get_database():
    CONNECTION_STRING= os.getenv("MONGODB_URI")
    # print(f"💽💽💽💽THE DATABASE URI is {CONNECTION_STRING}")
    client = MongoClient(CONNECTION_STRING)
    return client.get_default_database()

if __name__ == "__main__":   

   db = get_database()
   print("💽 Connected to API database:")
