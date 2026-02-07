const express = require('express');
const fs = require('fs');
const yaml = require('js-yaml'); // To read the .est blueprint
const app = express();

app.set('view engine', 'ejs');
app.use(express.static('public'));

app.get('/', (req, res) => {
    // 1. Read the EST Blueprint
    const estBlueprint = yaml.load(fs.readFileSync('./config.web.est', 'utf8'));

    // 2. Render the EJS Logic using that blueprint
    res.render('index', { est: estBlueprint });
});

app.listen(3000, () => {
    console.log('--- The New Web is Live ---');
    console.log('EST (Structure) -> EJS (Logic) -> JST (Interface)');
});
