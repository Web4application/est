import requests
import fitz

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

def chunk_text(text, size=1000):
    return [text[i:i+size] for i in range(0, len(text), size)]
