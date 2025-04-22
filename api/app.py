from flask import Flask, request, jsonify
from job import Job


# serve files from ../web
app = Flask(
    __name__,
    static_folder="../web",
    static_url_path=""
)
app.debug = True

# serve index.html
@app.route("/", methods=["GET"])
def index():
    return app.send_static_file("index.html")


@app.route('/generate', methods=['POST'])
def generate():
    data = request.get_json() or {}
    prompt = data.get('prompt', '')

    job = Job(param={'prompt': prompt, 'max_score': 10})
    job.run()
    job.calculate_score()

    return jsonify({
        'title': job.output.get('title', ''),
        'code':  '\n'.join(job.output.get('code', [])),
        'score': job.score
    }), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
