import os
from flask import Flask, jsonify, request

app = Flask(__name__)
VERSION = "v1"
UNIT_PRICE = 10
COMMIT = os.environ.get("APP_COMMIT", "development")


def total_price(quantity):
    if quantity < 1 or quantity > 1000:
        raise ValueError("quantity must be between 1 and 1000")
    return UNIT_PRICE * quantity


@app.get("/")
def index():
    return jsonify(service="Startup Pricing", version=VERSION, commit=COMMIT)


@app.get("/health")
def health():
    return jsonify(status="ok", version=VERSION)


@app.get("/price")
def price():
    try:
        quantity = int(request.args.get("quantity", "1"))
        total = total_price(quantity)
    except ValueError as error:
        return jsonify(error=str(error)), 400
    return jsonify(quantity=quantity, total=total, currency="USD")
