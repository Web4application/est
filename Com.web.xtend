---

## **1. Project Structure**

```fastht.ml
aura_population/
│
├─ aura_population/
│   ├─ __init__.py
│   ├─ data.py          # Data fetching & caching
│   ├─ processing.py    # Aggregation, mapping to continents or categories
│   ├─ visualization.py # Matplotlib & Plotly charts
│
├─ scripts/
│   └─ run_population.py  # End-to-end script
│
├─ data/                  # Cached datasets
│
├─ requirements.txt
└─ README.md
```
```ejs
<!--
  OGA-PLEX CORE: THE NEW DIMENSION 
  Format: .oggx (Oga Glass eXtension)
  Integration: CFML + XML + HTML5 + Three.js
--><!--- [SECTION 1: CFML SERVER LOGIC] --->
<cfscript>
    // Simulate scientific data retrieval
    paperMetadata = {
        "title": "NEURO-SYNTHETIC SPATIAL ARCHITECTURES",
        "author": "OGA RESEARCH LABS",
        "version": "1.0.4-OGX",
        "timestamp": Now()
    };
    gridStatus = "Hyper-Threading Active";
</cfscript>
<!--- [SECTION 2: XML/CTG CONTENT MANIFEST] --->
<xml-ctg style="display:none;">
    <Types xmlns="http://schemas.openxmlformats.org">
        <Default Extension=".oggx" ContentType="application/spatial-research+xml"/>
        <Default Extension=".md" ContentType="text/markdown"/>
        <Default Extension=".json" ContentType="application/json"/>
    </Types>
</xml-ctg>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>OGA-PLEX | <cfoutput>#paperMetadata.title#</cfoutput></title>
    <!-- Load Three.js via CDN for the 3D Warp -->
    <script src="https://cdnjs.cloudflare.com"></script>
    
    <style>
        :root {
            --cyan: #00f2ff;
            --glass: rgba(255, 255, 255, 0.05);
            --border: rgba(0, 242, 255, 0.2);
        }

        body, html {
            margin: 0; padding: 0; height: 100%;
            background: #010a12; color: var(--cyan);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            overflow: hidden;
        }

        /* The 3D Viewport */
        #viewport {
            perspective: 1200px;
            height: 100vh;
            width: 100vw;
            display: flex;
            align-items: center;
            justify-content: center;
            transform-style: preserve-3d;
        }

        /* Futuristic Glass Panes */
        .glass-pane {
            position: absolute;
            width: 500px;
            padding: 40px;
            background: var(--glass);
            backdrop-filter: blur(25px) saturate(150%);
            -webkit-backdrop-filter: blur(25px);
            border: 1px solid var(--border);
            border-radius: 20px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.5);
            transition: transform 0.8s cubic-bezier(0.2, 0.8, 0.2, 1), opacity 0.5s;
            cursor: pointer;
        }

        .glass-pane:hover {
            border-color: var(--cyan);
            background: rgba(0, 242, 255, 0.08);
        }

        /* Scientific HUD Elements */
        .hud {
            position: fixed; top: 20px; left: 20px; right: 20px;
            display: flex; justify-content: space-between;
            font-family: monospace; font-size: 10px;
            letter-spacing: 2px; pointer-events: none;
            z-index: 100;
        }

        h1 { font-size: 1.8rem; margin-bottom: 10px; font-weight: 300; letter-spacing: 2px; }
        p { line-height: 1.6; font-weight: 300; color: #fff; opacity: 0.8; }

        canvas#warp-bg {
            position: fixed; top: 0; left: 0; z-index: -1;
            width: 100%; height: 100%;
        }

        .data-stream {
            height: 1px; width: 100%;
            background: linear-gradient(90deg, transparent, var(--cyan), transparent);
            margin-top: 20px; animation: stream 2s infinite;
        }

        @keyframes stream { 0% { opacity: 0.2; } 50% { opacity: 1; } 100% { opacity: 0.2; } }
    </style>
</head>
<body>

    <canvas id="warp-bg"></canvas>

    <div class="hud">
        <div>CORE_SYS: <cfoutput>#paperMetadata.author#</cfoutput></div>
        <div>STATUS: <cfoutput>#gridStatus#</cfoutput></div>
        <div>TIMESTAMP: <cfoutput>#TimeFormat(paperMetadata.timestamp, "HH:mm:ss")#</cfoutput></div>
    </div>

    <div id="viewport">
        <!-- Abstract Layer -->
        <div class="glass-pane" style="transform: translateZ(200px) rotateY(-10deg);">
            <cfoutput><h1>#paperMetadata.title#</h1></cfoutput>
            <p>PaperWeb transformation utilizing the .oggx spatial protocol. This document exists as a multi-layered interactive entity within a 3D grid environment.</p>
            <div class="data-stream"></div>
        </div>

        <!-- Methodology Layer -->
        <div class="glass-pane" style="transform: translateZ(50px) translateX(300px) rotateY(15deg);">
            <h1>METHODOLOGY</h1>
            <p>Rendering scientific data via Glassmorphism. By utilizing hardware-accelerated Z-axis mapping, we reduce cognitive load and enhance context retention.</p>
        </div>
    </div>

    <script>
        // 1. THREE.JS WARP BACKGROUND
        const scene = new THREE.Scene();
        const camera = new THREE.PerspectiveCamera(60, window.innerWidth / window.innerHeight, 1, 1000);
        camera.position.z = 1;
        camera.rotation.x = Math.PI / 2;

        const renderer = new THREE.WebGLRenderer({ canvas: document.getElementById('warp-bg'), antialias: true, alpha: true });
        renderer.setSize(window.innerWidth, window.innerHeight);

        const starGeo = new THREE.BufferGeometry();
        const points = [];
        for (let i = 0; i < 5000; i++) {
            points.push(new THREE.Vector3(Math.random() * 600 - 300, Math.random() * 600 - 300, Math.random() * 600 - 300));
        }
        starGeo.setFromPoints(points);
        const starMaterial = new THREE.PointsMaterial({ color: 0x00f2ff, size: 0.7, transparent: true });
        const stars = new THREE.Points(starGeo, starMaterial);
        scene.add(stars);

        function animateStars() {
            const positions = starGeo.attributes.position.array;
            for (let i = 0; i < positions.length; i += 3) {
                positions[i + 1] -= 1.5; // Moving "down" for warp effect
                if (positions[i + 1] < -300) positions[i + 1] = 300;
            }
            starGeo.attributes.position.needsUpdate = true;
            renderer.render(scene, camera);
            requestAnimationFrame(animateStars);
        }
        animateStars();

        // 2. MOUSE TRACKING INTERFACE
        const viewport = document.getElementById('viewport');
        document.addEventListener('mousemove', (e) => {
            let x = (window.innerWidth / 2 - e.pageX) / 40;
            let y = (window.innerHeight / 2 - e.pageY) / 40;
            viewport.style.transform = `rotateY(${x}deg) rotateX(${y}deg)`;
        });

        // 3. RESPONSIVE RESIZE
        window.addEventListener('resize', () => {
            camera.aspect = window.innerWidth / window.innerHeight;
            camera.updateProjectionMatrix();
            renderer.setSize(window.innerWidth, window.innerHeight);
        });
    </script>
</body>
</html>

---
```
## **2. `data.py`** — Fetch & Cache Data

```python
import os
import pandas as pd
import wbdata as wb

CACHE_DIR = "data"

def fetch_population(indicators=None, cache_file="population.csv", start=None, end=None):
    """
    Fetch population or other World Bank indicators, cache locally.
    """
    if indicators is None:
        indicators = {'SP.POP.TOTL': 'Population, total'}
        
    os.makedirs(CACHE_DIR, exist_ok=True)
    path = os.path.join(CACHE_DIR, cache_file)
    
    if os.path.exists(path):
        df = pd.read_csv(path, index_col=[0,1], parse_dates=[1])
    else:
        df = wb.get_dataframe(indicators, convert_date=True).sort_index()
        df.to_csv(path)
    
    if start:
        df = df[df.index.get_level_values('date') >= pd.to_datetime(start)]
    if end:
        df = df[df.index.get_level_values('date') <= pd.to_datetime(end)]
        
    return df
```

---

## **3. `processing.py`** — Aggregation & Mapping

```python
import wbdata as wb
import pandas as pd

def map_continents(df):
    """
    Map countries to continents automatically using World Bank metadata.
    """
    countries = wb.get_country()
    country_to_continent = {c['name']: c['region']['value'] for c in countries}
    
    df = df.reset_index()
    df['continent'] = df['country'].map(country_to_continent).fillna('Other')
    df.set_index(['continent', 'country', 'date'], inplace=True)
    
    return df

def aggregate_by_continent(df, value_col='Population, total', order=None):
    """
    Aggregate population by continent.
    """
    pop_cont = df[value_col].groupby(level=['continent','date']).sum().unstack(level=0)
    if order:
        pop_cont = pop_cont[order]
    return pop_cont
```

---

## **4. `visualization.py`** — Plots

```python
import matplotlib.pyplot as plt
import plotly.graph_objs as go
import plotly.offline as offline

def plot_stack_matplotlib(df, title="Stacked Area Chart", ylabel="Value"):
    plt.figure(figsize=(10,5))
    plt.stackplot(df.index, df.values.T, labels=df.columns)
    plt.legend(loc='upper left')
    plt.xlabel("Year")
    plt.ylabel(ylabel)
    plt.title(title)
    plt.show()

def plot_stack_plotly(df, title="Interactive Stacked Chart", ylabel="Value"):
    offline.init_notebook_mode()
    data = [go.Scatter(x=df.index, y=df[col], name=col, stackgroup='World') for col in df.columns]
    fig = go.Figure(data=data)
    fig.update_layout(title=title, xaxis_title="Year", yaxis_title=ylabel)
    offline.iplot(fig)
```

---

## **5. `run_population.py`** — End-to-End Script

```python
from aura_population.data import fetch_population
from aura_population.processing import map_continents, aggregate_by_continent
from aura_population.visualization import plot_stack_matplotlib, plot_stack_plotly

# 1. Fetch population data
df = fetch_population()

# 2. Map countries to continents
df = map_continents(df)

# 3. Aggregate population by continent
continent_order = ['East Asia & Pacific', 'South Asia', 'Sub-Saharan Africa',
                   'Europe & Central Asia', 'Latin America & Caribbean',
                   'Middle East & North Africa', 'North America']
pop_by_cont = aggregate_by_continent(df, order=continent_order)

# 4. Plot
plot_stack_matplotlib(pop_by_cont, title="World Population by Continent", ylabel="Population")
plot_stack_plotly(pop_by_cont, title="World Population by Continent (Interactive)", ylabel="Population")
```

---

## **6. `requirements.txt`**

```
pandas
wbdata
matplotlib
plotly
```

---

### **✅ Aura Extension Advantages**

1. **Fully modular:** Data fetching, processing, visualization are separate.
2. **Reusable for any dataset:** Swap population for GDP, health, or custom metrics.
3. **Caching enabled:** Minimizes API calls.
4. **Interactive and static outputs:** Works in dashboards or reports.
5. **Easy integration:** Can be wrapped into Aura dashboards, APIs, or CLI tools.

---
```fsharp
\documentclass{standalone}

\usepackage{amsmath}
\usepackage{tikz}
\usepackage{xcolor}

% One page per diagram.
\standaloneenv{tikzpicture}

% Colorblind-friendly palette from <https://jfly.uni-koeln.de/color/>.
\definecolor{Vermillion}        {cmy}{0,    0.8, 1}
\definecolor{Orange}            {cmy}{0,    0.5, 1}
\definecolor{SkyBlue}           {cmy}{0.8,  0,   0}
\definecolor{BluishGreen}       {cmy}{0.97, 0,   0.75}
\definecolor{Yellow}            {cmy}{0.1,  0.5, 0.9}
\definecolor{Blue}              {cmy}{1,    0.5, 0}
\definecolor{ReddishPurple}     {cmy}{0.1,  0.7, 0}

\begin{document}

\begin{tikzpicture}

\usetikzlibrary{calc}
\usetikzlibrary{shapes}

% Nodes representing data.
\tikzset{publicdatum/.style={
    shape=circle,
    rounded corners=0.5ex,
    minimum height=4ex,
    fill=SkyBlue, fill opacity=0.4,
    text opacity=1,
}}
\tikzset{secretdatum/.style={
    shape=rectangle,
    rounded corners=0.5ex,
    minimum height=4ex,
    fill=Vermillion, fill opacity=0.4,
    text opacity=1,
}}

% Nodes representing operations on data.
\tikzset{operation/.style={
    shape=trapezium,
    trapezium left angle=-65,
    trapezium right angle=-65,
    minimum height=4ex,
}}

\node (gen) at (1/4, 5) [draw, operation] {$\operatorname{Gen}$};
  \coordinate (gen-pk) at ($(gen.south) - (1/4,0)$);
  \coordinate (gen-sk) at ($(gen.south) + (1/4,0)$);

\node (pk) at (-2, 3) [draw, publicdatum] {$\mathit{pk}$};

\node (encap) at (-2, 2) [draw, operation]
    {$\operatorname{Encap}(\mathit{pk})$};
  \coordinate (encap-pk) at (encap.north);
  \coordinate (encap-k) at ($(encap.south) - (1/2,0)$);
  \coordinate (encap-c) at ($(encap.south) + (1/2,0)$);

\node (k0) at (-2.5, 1) [draw, secretdatum] {$k$};
\node (c) at (-1, 0.5) [draw, publicdatum] {$c$};

\node (sk) at (0.5, 0) [draw, secretdatum] {$\mathit{sk}$};

\node (decap) at (0, -1) [draw, operation]
    {$\operatorname{Decap}(\mathit{sk}, c)$};
  \coordinate (decap-c) at ($(decap.north) - (1/2,0)$);
  \coordinate (decap-sk) at ($(decap.north) + (1/2,0)$);
  \coordinate (decap-k) at (decap.south);

\node (k1) at (0, -2) [draw, secretdatum] {$k$};

\draw[->] (gen-pk) |- ($(pk) + (0,1)$) -- (pk);
\draw[->] (gen-sk) -- (sk);

\draw[->] (pk) -- (encap-pk);
\draw[->] (encap-k) -- (k0.north);
\draw[->] (encap-c) |- (c);

\draw[->] (c) -| (decap-c);
\draw[->] (sk) -- (decap-sk);
\draw[->] (decap-k) -- (k1);

\end{tikzpicture}

\end{document}
