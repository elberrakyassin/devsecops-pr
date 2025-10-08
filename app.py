from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def hello():
    # Solo mostrar un mensaje simple
    return "Hola desde Flask. Este pipeline es seguro!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)