CREATE TABLE papers (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    title TEXT,
    arxiv_url TEXT,
    pdf_url TEXT,
    uploaded_at TIMESTAMP DEFAULT NOW()
);
