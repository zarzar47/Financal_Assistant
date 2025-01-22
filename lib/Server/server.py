from flask import Flask, request, jsonify
from openai import OpenAI
# from dotenv import load_dotenv, find_dotenv
import os

client = OpenAI(api_key=os.getenv('OPEN_AI_KEY', 'No API Key Found'))
app = Flask(__name__)

@app.route('/ChatPrompt', methods=['POST'])
def chat():
    if request.method == 'POST':
        data = request.get_json()
        user_message = data.get('message', "You are cute")
        response = client.chat.completions.create(
            model = 'gpt-4o-mini',
            messages=[{'role':'user', 'content':user_message}],
            max_tokens = 10,
            temperature = 0.5,
        )
        d = {}
        d['body'] = str(response.choices[0].message.content)
        return jsonify(d)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')