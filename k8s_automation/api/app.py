from flask import Flask, jsonify, request
from deployment import create_deployment
from health import get_health_status

app = Flask(__name__)

@app.route('/create-deployment', methods=['POST'])
def create_deployment_api():
    data = request.get_json()
    result = create_deployment(data)
    return jsonify(result)

@app.route('/deployment-health/<namespace>/<deployment_id>', methods=['GET'])
def health_status_api(namespace, deployment_id):
    status = get_health_status(namespace, deployment_id)
    return jsonify({'status': status})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
