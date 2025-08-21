from flask import Flask

app = Flask(__name__)


@app.route('/')
def hello_world():  # put application's code here
    return 'Hello World!'


@app.route('/healthz')
def healthz():
    # Simple health check endpoint for Kubernetes or load balancers
    return 'OK', 200


if __name__ == '__main__':
    app.run()
