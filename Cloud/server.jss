const express = require('express');
const yaml = require('js-yaml');
const fs = require('fs');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 8080;

app.set('view engine', 'ejs');

// Deployment Fix: Ensure JST is served with correct headers
app.get('/index.jst', (req, res) => {
    res.setHeader('Content-Type', 'application/javascript');
    res.sendFile(path.join(__dirname, 'public/index.jst'));
});

app.get('/', (req, res) => {
    try {
        // Load the Blueprint from your invented extension
        const blueprint = yaml.load(fs.readFileSync('./config/web.est', 'utf8'));
        res.render('index', { est: blueprint });
    } catch (err) {
        console.error("CFM Deployment Error:", err);
        res.status(500).send("System Offline");
    }
});

app.listen(PORT, () => console.log(`E.S.T. Stack Active on Port ${PORT}`));
