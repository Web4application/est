import gradio as gr
from utils import download_pdf, extract_text, chunk_text
from rag import build_index, query_rag

index = None
chunks = None

def load_paper(url):
    global index, chunks
    pdf = download_pdf(url)
    text = extract_text(pdf)
    chunks = chunk_text(text)
    index, chunks = build_index(chunks)
    return "Paper loaded successfully."

def ask(question):
    return query_rag(question, index, chunks)

with gr.Blocks() as demo:
    gr.Markdown("# 📚 Paperweb AI Research Assistant")

    url = gr.Textbox(label="Paste arXiv Link")
    load_btn = gr.Button("Load Paper")
    status = gr.Textbox(label="Status")

    load_btn.click(load_paper, inputs=url, outputs=status)

    question = gr.Textbox(label="Ask a Question")
    answer = gr.Textbox(label="Answer")
    ask_btn = gr.Button("Ask")

    ask_btn.click(ask, inputs=question, outputs=answer)

demo.launch()
