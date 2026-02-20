<!--
  OGA-PLEX CORE: THE NEW DIMENSION 
  Format: .oggx (Oga Glass eXtension)
  Integration: CFML + XML + HTML5 + Three.js
-->

<!--- [SECTION 1: CFML SERVER LOGIC] --->
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
