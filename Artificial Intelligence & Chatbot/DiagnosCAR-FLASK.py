from flask import Flask, request, jsonify
import pickle
from sklearn.metrics.pairwise import cosine_similarity

app = Flask(__name__)

with open('C:/Users/João/Downloads/SPRINT4/CHATBOT/DiagnosCAR-modelo_e_vectorizer.pickle', 'rb') as f:
    loaded_objects = pickle.load(f)
    classifier = loaded_objects['classifier']
    vectorizer = loaded_objects['vectorizer']
    df = loaded_objects['dataframe']

def prever_solucao(descricao):
    descricao_tfidf = vectorizer.transform([descricao])
    problema_predito = classifier.predict(descricao_tfidf)[0]

    df_filtrado = df[df['Problema'] == problema_predito]

    descricoes_tfidf = vectorizer.transform(df_filtrado['Descricao'])
    similaridades = cosine_similarity(descricao_tfidf, descricoes_tfidf).flatten()

    idx_mais_similar = similaridades.argmax()
    solucao = df_filtrado.iloc[idx_mais_similar]['Solucao']

    return problema_predito, solucao

@app.route('/prever', methods=['POST'])
def prever():
    data = request.get_json()
    descricao = data.get('descricao')

    if not descricao:
        return jsonify({'erro': 'Nenhuma descrição fornecida'}), 400

    problema, solucao = prever_solucao(descricao)

    return jsonify({
        'problema': problema,
        'solucao': solucao
    })

if __name__ == "__main__":
    app.run(debug=True)
