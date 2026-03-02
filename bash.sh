mkdir new-web-beginning && cd new-web-beginning
npm init -y
npm install express ejs js-yaml
mkdir views public config
# Clone the repository
git clone https://github.com/Web4application/webosbrowser.git
cd webosbrowser

# Install dependencies (example for Node.js/JavaScript-based projects)
npm install

# Start the browser (customize as needed)
npm start

npx shadcn@latest add @algolia/search

composer require algolia/search-bundle:4.0.0
