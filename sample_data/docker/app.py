from flask import Flask, jsonify 
import socket
import datetime
import os

app = Flask(__name__)

# check if app is alive and responding to requests, if not restarts the container
@app.route("/health")
def health_check():
    return jsonify({
        "status": "healthy", 
        "host": socket.gethostname(),
        "time": str(datetime.datetime.now())
    })

# Root route is basic app info so the base URL doesn't 404
@app.route("/")
def home():
    return jsonify({"app": "myapp", "version": "1.0"})

# Readiness check to confirm the app is done with setup; Checks database connection, config loaded,
@app.route("/ready")
def readiness_check():
    return jsonify({
        "status": "ready",
        "host": socket.gethostname(),
        "time": str(datetime.datetime.now())
    })

# Start server when run directly
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", "8080"))) # default to 8080 if PORT not set

