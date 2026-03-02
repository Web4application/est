import faiss
import numpy as np
from sentence_transformers import SentenceTransformer
from openai import OpenAI

model = SentenceTransformer("all-MiniLM-L6-v2")
client = OpenAI()

def build_index(chunks):
    embeddings = model.encode(chunks)
    dim = embeddings.shape[1]
    index = faiss.IndexFlatL2(dim)
    index.add(np.array(embeddings))
    return index, chunks

def query_rag(question, index, chunks):
    q_embedding = model.encode([question])
    D, I = index.search(np.array(q_embedding), k=3)
    context = "\n\n".join([chunks[i] for i in I[0]])

    prompt = f"""
You are an AI research assistant.
Answer strictly using the context below.

Context:
{context}

Question:
{question}
"""

    response = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[{"role": "user", "content": prompt}],
    )

    return response.choices[0].message.content
