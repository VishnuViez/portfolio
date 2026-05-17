// Three.js Scene Management
class ThreeScene {
    constructor() {
        this.scenes = {};
        this.init();
    }

    init() {
        // Initialize all 3D scenes
        this.initBackgroundScene();
        this.initHeroScene();
        this.initAboutScene();
        this.initSkillsScene();
    }

    // Background Particles Scene
    initBackgroundScene() {
        const canvas = document.getElementById('bg-canvas');
        if (!canvas) return;

        const scene = new THREE.Scene();
        const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
        const renderer = new THREE.WebGLRenderer({
            canvas: canvas,
            alpha: true,
            antialias: true
        });

        renderer.setSize(window.innerWidth, window.innerHeight);
        renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
        camera.position.z = 5;

        // Create particle system
        const particlesGeometry = new THREE.BufferGeometry();
        const particlesCount = 1500;
        const posArray = new Float32Array(particlesCount * 3);

        for (let i = 0; i < particlesCount * 3; i++) {
            posArray[i] = (Math.random() - 0.5) * 20;
        }

        particlesGeometry.setAttribute('position', new THREE.BufferAttribute(posArray, 3));

        const particlesMaterial = new THREE.PointsMaterial({
            size: 0.025,
            color: getComputedStyle(document.documentElement).getPropertyValue('--primary').trim() || '#6366f1',
            transparent: true,
            opacity: 0.8,
            blending: THREE.AdditiveBlending
        });

        const particlesMesh = new THREE.Points(particlesGeometry, particlesMaterial);
        scene.add(particlesMesh);

        // Animation
        const animate = () => {
            requestAnimationFrame(animate);
            particlesMesh.rotation.x += 0.0003;
            particlesMesh.rotation.y += 0.0005;
            renderer.render(scene, camera);
        };

        animate();

        // Handle resize
        window.addEventListener('resize', () => {
            camera.aspect = window.innerWidth / window.innerHeight;
            camera.updateProjectionMatrix();
            renderer.setSize(window.innerWidth, window.innerHeight);
        });

        this.scenes.background = { scene, camera, renderer, particlesMesh };
    }

    // Hero Section 3D Scene
    initHeroScene() {
        const canvas = document.getElementById('hero-canvas');
        if (!canvas) return;

        const scene = new THREE.Scene();
        const camera = new THREE.PerspectiveCamera(75, canvas.clientWidth / canvas.clientHeight, 0.1, 1000);
        const renderer = new THREE.WebGLRenderer({
            canvas: canvas,
            alpha: true,
            antialias: true
        });

        renderer.setSize(canvas.clientWidth, canvas.clientHeight);
        renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
        camera.position.z = 5;

        // Create rotating torus knot
        const geometry = new THREE.TorusKnotGeometry(1.5, 0.5, 100, 16);
        const material = new THREE.MeshNormalMaterial({
            wireframe: false,
            flatShading: true
        });
        const torusKnot = new THREE.Mesh(geometry, material);
        scene.add(torusKnot);

        // Add ambient light
        const ambientLight = new THREE.AmbientLight(0xffffff, 0.5);
        scene.add(ambientLight);

        // Add directional light
        const directionalLight = new THREE.DirectionalLight(0xffffff, 0.8);
        directionalLight.position.set(5, 5, 5);
        scene.add(directionalLight);

        // Animation
        const animate = () => {
            requestAnimationFrame(animate);
            torusKnot.rotation.x += 0.005;
            torusKnot.rotation.y += 0.007;
            renderer.render(scene, camera);
        };

        animate();

        // Handle resize
        const handleResize = () => {
            const parent = canvas.parentElement;
            if (!parent) return;
            camera.aspect = parent.clientWidth / parent.clientHeight;
            camera.updateProjectionMatrix();
            renderer.setSize(parent.clientWidth, parent.clientHeight);
        };

        window.addEventListener('resize', handleResize);

        this.scenes.hero = { scene, camera, renderer, torusKnot };
    }

    // About Section 3D Scene
    initAboutScene() {
        const canvas = document.getElementById('about-canvas');
        if (!canvas) return;

        const scene = new THREE.Scene();
        const camera = new THREE.PerspectiveCamera(75, canvas.clientWidth / canvas.clientHeight, 0.1, 1000);
        const renderer = new THREE.WebGLRenderer({
            canvas: canvas,
            alpha: true,
            antialias: true
        });

        renderer.setSize(canvas.clientWidth, canvas.clientHeight);
        renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
        camera.position.z = 5;

        // Create floating cubes
        const cubes = [];
        const cubeGeometry = new THREE.BoxGeometry(0.5, 0.5, 0.5);
        
        for (let i = 0; i < 15; i++) {
            const material = new THREE.MeshStandardMaterial({
                color: Math.random() * 0xffffff,
                metalness: 0.5,
                roughness: 0.5
            });
            const cube = new THREE.Mesh(cubeGeometry, material);
            
            cube.position.x = (Math.random() - 0.5) * 8;
            cube.position.y = (Math.random() - 0.5) * 8;
            cube.position.z = (Math.random() - 0.5) * 8;
            
            cube.rotation.x = Math.random() * Math.PI;
            cube.rotation.y = Math.random() * Math.PI;
            
            cubes.push(cube);
            scene.add(cube);
        }

        // Add lights
        const ambientLight = new THREE.AmbientLight(0xffffff, 0.5);
        scene.add(ambientLight);

        const pointLight = new THREE.PointLight(0xffffff, 1);
        pointLight.position.set(5, 5, 5);
        scene.add(pointLight);

        // Animation
        const animate = () => {
            requestAnimationFrame(animate);
            
            cubes.forEach((cube, index) => {
                cube.rotation.x += 0.01;
                cube.rotation.y += 0.01;
                cube.position.y += Math.sin(Date.now() * 0.001 + index) * 0.005;
            });
            
            renderer.render(scene, camera);
        };

        animate();

        // Handle resize
        const handleResize = () => {
            const parent = canvas.parentElement;
            if (!parent) return;
            camera.aspect = parent.clientWidth / parent.clientHeight;
            camera.updateProjectionMatrix();
            renderer.setSize(parent.clientWidth, parent.clientHeight);
        };

        window.addEventListener('resize', handleResize);

        this.scenes.about = { scene, camera, renderer, cubes };
    }

    // Skills Section 3D Scene
    initSkillsScene() {
        const canvas = document.getElementById('skills-canvas');
        if (!canvas) return;

        const scene = new THREE.Scene();
        const camera = new THREE.PerspectiveCamera(75, canvas.clientWidth / canvas.clientHeight, 0.1, 1000);
        const renderer = new THREE.WebGLRenderer({
            canvas: canvas,
            alpha: true,
            antialias: true
        });

        renderer.setSize(canvas.clientWidth, canvas.clientHeight);
        renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
        camera.position.z = 8;

        // Create orbiting spheres representing skills
        const spheres = [];
        const sphereGeometry = new THREE.SphereGeometry(0.3, 32, 32);
        
        for (let i = 0; i < 20; i++) {
            const material = new THREE.MeshStandardMaterial({
                color: new THREE.Color().setHSL(i / 20, 0.7, 0.6),
                metalness: 0.7,
                roughness: 0.3
            });
            const sphere = new THREE.Mesh(sphereGeometry, material);
            
            const angle = (i / 20) * Math.PI * 2;
            const radius = 4;
            sphere.position.x = Math.cos(angle) * radius;
            sphere.position.z = Math.sin(angle) * radius;
            sphere.position.y = (Math.random() - 0.5) * 2;
            
            spheres.push({ mesh: sphere, angle: angle, radius: radius });
            scene.add(sphere);
        }

        // Add lights
        const ambientLight = new THREE.AmbientLight(0xffffff, 0.5);
        scene.add(ambientLight);

        const pointLight = new THREE.PointLight(0xffffff, 1);
        pointLight.position.set(0, 5, 0);
        scene.add(pointLight);

        // Animation
        let time = 0;
        const animate = () => {
            requestAnimationFrame(animate);
            time += 0.01;
            
            spheres.forEach((sphere, index) => {
                sphere.angle += 0.005;
                sphere.mesh.position.x = Math.cos(sphere.angle) * sphere.radius;
                sphere.mesh.position.z = Math.sin(sphere.angle) * sphere.radius;
                sphere.mesh.position.y = Math.sin(time + index) * 0.5;
                sphere.mesh.rotation.y += 0.01;
            });
            
            renderer.render(scene, camera);
        };

        animate();

        // Handle resize
        const handleResize = () => {
            const parent = canvas.parentElement;
            if (!parent) return;
            camera.aspect = parent.clientWidth / parent.clientHeight;
            camera.updateProjectionMatrix();
            renderer.setSize(parent.clientWidth, parent.clientHeight);
        };

        window.addEventListener('resize', handleResize);

        this.scenes.skills = { scene, camera, renderer, spheres };
    }

    // Update particle color on theme change
    updateParticleColor(color) {
        if (this.scenes.background && this.scenes.background.particlesMesh) {
            this.scenes.background.particlesMesh.material.color.set(color);
        }
    }
}

// Initialize Three.js scenes when DOM is ready
let threeScene;
document.addEventListener('DOMContentLoaded', () => {
    threeScene = new ThreeScene();
});
