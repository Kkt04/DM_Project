from flask import Flask, render_template, request, jsonify
import pandas as pd
import os
import sys
import ast
import base64
from io import BytesIO
from wordcloud import WordCloud
import matplotlib.pyplot as plt

# Add project root to path to allow imports
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
if project_root not in sys.path:
    sys.path.insert(0, project_root)

from src.utils.data_loader import load_processed_data

app = Flask(__name__)

# Load data once when the app starts
try:
    # Load data, using mock=False to use the processed sample
    df = load_processed_data(mock=False)
    # Ensure 'main_categories' is a list of strings
    df['main_categories'] = df['main_categories'].apply(lambda x: ast.literal_eval(x) if isinstance(x, str) else x)
    # Combine titles and abstracts for word cloud
    df['text_content'] = df['title'] + ' ' + df['abstract']
except FileNotFoundError:
    df = pd.DataFrame({'title': [], 'abstract': [], 'text_content': []})
    print("Warning: Could not load data. Dashboard functionality will be limited.")

def generate_word_cloud(text):
    """Generates a word cloud image from text and returns it as a base64 string."""
    if not text:
        return ""
        
    # Simple stop words list; a more comprehensive one would be used in a real project
    stop_words = set(['the', 'and', 'of', 'to', 'in', 'a', 'is', 'that', 'for', 'on', 'with', 'this', 'paper', 'analysis', 'using', 'which', 'from', 'study', 'research', 'novel', 'technique', 'approach'])
    
    wordcloud = WordCloud(width=800, height=400, background_color='white', stopwords=stop_words).generate(text)
    
    # Convert to PNG image in memory
    img = BytesIO()
    plt.figure(figsize=(10, 5))
    plt.imshow(wordcloud, interpolation='bilinear')
    plt.axis("off")
    plt.tight_layout(pad=0)
    plt.savefig(img, format='png')
    plt.close()
    img.seek(0)
    
    # Encode to base64 string
    img_base64 = base64.b64encode(img.getvalue()).decode('utf8')
    return f"data:image/png;base64,{img_base64}"

@app.route('/')
def index():
    """Main dashboard page."""
    # In a full dashboard, you would pass summary statistics or initial plots here
    return render_template('index.html')

@app.route('/wordcloud', methods=['POST'])
def wordcloud_endpoint():
    """Endpoint to generate the interactive word cloud."""
    w1 = request.form.get('word', '').strip().lower()
    
    if not w1:
        return jsonify({'error': 'Please enter a word (w1).'}), 400

    # Filter papers where w1 is present in the title or abstract
    filtered_df = df[df['text_content'].str.contains(r'\b' + w1 + r'\b', case=False, na=False)]
    
    if filtered_df.empty:
        return jsonify({'error': f'No papers found containing the word "{w1}".'}), 404

    # Combine all text content from the filtered papers
    combined_text = " ".join(filtered_df['text_content'].tolist())
    
    # Generate the word cloud
    img_data = generate_word_cloud(combined_text)
    
    return jsonify({'image': img_data, 'count': len(filtered_df)})

if __name__ == '__main__':
    # For local development, use a standard port
    # In the sandbox, we will use gunicorn to run the app
    print("Dashboard application ready. Run with: gunicorn -w 4 -b 0.0.0.0:8080 app:app")
    # app.run(debug=True, port=5000)

