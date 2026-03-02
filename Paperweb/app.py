import gradio as gr
import requests
import fitz  # PyMuPDF
import faiss
import numpy as np
from sentence_transformers import SentenceTransformer

model = SentenceTransformer("all-MiniLM-L6-v2")

def download_pdf(arxiv_url):
    pdf_url = arxiv_url.replace("abs", "pdf") + ".pdf"
    r = requests.get(pdf_url)
    with open("paper.pdf", "wb") as f:
        f.write(r.content)
    return "paper.pdf"

def extract_text(pdf_path):
    doc = fitz.open(pdf_path)
    text = ""
    for page in doc:
        text += page.get_text()
    return text

def chunk_text(text, chunk_size=800):
    chunks = []
    for i in range(0, len(text), chunk_size):
        chunks.append(text[i:i+chunk_size])
    return chunks

def build_index(chunks):
    embeddings = model.encode(chunks)
    dim = embeddings.shape[1]
    index = faiss.IndexFlatL2(dim)
    index.add(np.array(embeddings))
    return index, embeddings

def answer_question(question, index, chunks):
    q_embedding = model.encode([question])
    D, I = index.search(np.array(q_embedding), k=3)
    context = "\n\n".join([chunks[i] for i in I[0]])
    return f"Answer based on paper:\n\n{context}"

def process(arxiv_url, question):
    pdf = download_pdf(arxiv_url)
    text = extract_text(pdf)
    chunks = chunk_text(text)
    index, embeddings = build_index(chunks)
    return answer_question(question, index, chunks)

with gr.Blocks() as demo:
    gr.Markdown("# 📚 Paperweb AI Reader")
    url = gr.Textbox(label="Paste arXiv Link")
    question = gr.Textbox(label="Ask a Question About the Paper")
    output = gr.Textbox(label="Answer")
    btn = gr.Button("Analyze")

    btn.click(process, inputs=[url, question], outputs=output)

demo.launch()
