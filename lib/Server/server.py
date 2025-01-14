from flask import Flask, request, jsonify
from openai import OpenAI
# from dotenv import load_dotenv, find_dotenv
import os

client = OpenAI( api_key="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")
app = Flask(__name__)

@app.route('/ChatPrompt', methods=['POST'])
def chat():
    if request.method == 'POST':
        response = client.chat.completions.create(
            model = 'gpt-4o-mini',
            messages=[{'role':'user', 'content':"whats up gpt"}],
            max_tokens = 10,
            temperature = 0.5,
        )
        d = {}
        d['body'] = str(response.choices[0].message.content)
        return jsonify(d)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')