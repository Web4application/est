// JST: The final layer of the stack
const root = document.getElementById('root');
const config = JSON.parse(root.dataset.config);

root.innerHTML = `
    <h3>System Status: Online</h3>
    <p>Running Version: ${config.version}</p>
    <button id="activate">Pulse System</button>
`;

document.getElementById('activate').onclick = () => {
    root.style.borderColor = '#fbbf24';
    alert(`Active Features: ${config.settings.features.join(', ')}`);
};
