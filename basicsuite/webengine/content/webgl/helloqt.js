var shadow = false;

var container = document.getElementById("container");
var camera = null;
var scene;
var renderer;
var cbTexture;
var cbScene;
var cbCamera;
var cbUniforms = {
    dy: { type: "f", value: 0 }
};
var cb;
var logo;
var spotlight;

var viewSize = {
    w: 0,
    h: 0,
    update: function () {
        viewSize.w = window.innerWidth;// / 2;
        viewSize.h = window.innerHeight;// / 2;
    }
};

var onResize = function (event) {
    viewSize.update();
    if (!camera) {
        camera = new THREE.PerspectiveCamera(60, viewSize.w / viewSize.h, 0.01, 100);
    } else {
        camera.aspect = viewSize.w / viewSize.h;
        camera.updateProjectionMatrix();
    }
    renderer.setSize(viewSize.w, viewSize.h);
};

var setupCheckerboard = function () {
    cbTexture = new THREE.WebGLRenderTarget(512, 512,
                                            { minFilter: THREE.LinearFilter,
                                              magFilter: THREE.LinearFilter,
                                              format: THREE.RGBFormat });
    cbScene = new THREE.Scene();
    cbCamera = new THREE.OrthographicCamera(-1, 1, 1, -1, -100, 100);
    var geom = new THREE.PlaneGeometry(2, 2);
    var material = new THREE.ShaderMaterial({
        uniforms: cbUniforms,
        vertexShader: document.getElementById("vsChecker").textContent,
        fragmentShader: document.getElementById("fsChecker").textContent
    });
    var mesh = new THREE.Mesh(geom, material);
    cbScene.add(mesh);
};

var renderCheckerboard = function () {
    cbUniforms.dy.value += 0.01;
    renderer.render(cbScene, cbCamera, cbTexture, true);
};

var generateLogo = function () {
    var geom = new THREE.Geometry();
    var idx = 0;
    for (var i = 0; i < qtlogo.length; i += 18) {
        geom.vertices.push(new THREE.Vector3(qtlogo[i], qtlogo[i+1], qtlogo[i+2]));
        var n1 = new THREE.Vector3(qtlogo[i+3], qtlogo[i+4], qtlogo[i+5]);
        geom.vertices.push(new THREE.Vector3(qtlogo[i+6], qtlogo[i+7], qtlogo[i+8]));
        var n2 = new THREE.Vector3(qtlogo[i+9], qtlogo[i+10], qtlogo[i+11]);
        geom.vertices.push(new THREE.Vector3(qtlogo[i+12], qtlogo[i+13], qtlogo[i+14]));
        var n3 = new THREE.Vector3(qtlogo[i+15], qtlogo[i+16], qtlogo[i+17]);
        geom.faces.push(new THREE.Face3(idx, idx+1, idx+2, [n1, n2, n3]));
        idx += 3;
    }
    return geom;
};

var setupScene = function () {
    if (shadow)
        renderer.shadowMapEnabled = true;

    setupCheckerboard();
    var geom = new THREE.PlaneGeometry(4, 4);
    var material = new THREE.MeshPhongMaterial({ ambient: 0x060606,
                                                 color: 0x40B000,
                                                 specular: 0x03AA00,
                                                 shininess: 10,
                                                 map: cbTexture });
    cb = new THREE.Mesh(geom, material);
    if (shadow)
        cb.receiveShadow = true;
//    cb.rotation.x = -Math.PI / 3;
    scene.add(cb);

    geom = generateLogo();
    material = new THREE.MeshPhongMaterial({ ambient: 0x060606,
                                             color: 0x40B000,
                                             specular: 0x03AA00,
                                             shininess: 10 });
    logo = new THREE.Mesh(geom, material);
    logo.position.z = 2;
    logo.rotation.x = Math.PI;
    if (shadow)
        logo.castShadow = true;
    scene.add(logo);

    spotlight = new THREE.SpotLight(0xFFFFFF);
    spotlight.position.set(0, 0.5, 4);
    scene.add(spotlight);

    if (shadow) {
        spotlight.castShadow = true;
        spotlight.shadowCameraNear = 0.01;
        spotlight.shadowCameraFar = 100;
        spotlight.shadowDarkness = 0.5;
        spotlight.shadowMapWidth = 1024;
        spotlight.shadowMapHeight = 1024;
    }

    camera.position.z = 4;
};

var render = function () {
    requestAnimationFrame(render);
    renderCheckerboard();
    renderer.render(scene, camera);
    logo.rotation.y += 0.01;
};

var pointerState = {
    x: 0,
    y: 0,
    active: false,
    touchId: 0
};

var onMouseDown = function (e) {
    e.preventDefault();
    if (pointerState.active)
        return;

    if (e.changedTouches) {
        var t = e.changedTouches[0];
        pointerState.touchId = t.identifier;
        pointerState.x = t.clientX;
        pointerState.y = t.clientY;
    } else {
        pointerState.x = e.clientX;
        pointerState.y = e.clientY;
    }
    pointerState.active = true;
};

var onMouseUp = function (e) {
    e.preventDefault();
    if (!pointerState.active)
        return;

    if (e.changedTouches) {
        for (var i = 0; i < e.changedTouches.length; ++i)
            if (e.changedTouches[i].identifier == pointerState.touchId) {
                pointerState.active = false;
                break;
            }
    } else {
        pointerState.active = false;
    }
};

var onMouseMove = function (e) {
    e.preventDefault();
    if (!pointerState.active)
        return;

    var x, y;
    if (e.changedTouches) {
        for (var i = 0; i < e.changedTouches.length; ++i)
            if (e.changedTouches[i].identifier == pointerState.touchId) {
                x = e.changedTouches[i].clientX;
                y = e.changedTouches[i].clientY;
                break;
            }
    } else {
        x = e.clientX;
        y = e.clientY;
    }
    if (x === undefined)
        return;

    var dx = x - pointerState.x;
    var dy = y - pointerState.y;
    pointerState.x = x;
    pointerState.y = y;
    dx /= 100;
    dy /= -100;
    spotlight.target.position.set(spotlight.target.position.x + dx,
                                  spotlight.target.position.y + dy,
                                  0);
};

var main = function () {
    scene = new THREE.Scene();
    try {
        renderer = new THREE.WebGLRenderer({ antialias: false /*true*/ });
    } catch (e) {
        console.log("Could not create WebGLRenderer.");
        container.innerHTML = noWebGLMessage= "<div style=\"font-family: monospace; font-size: 13px; margin: 5em auto 0px; padding: 2em; width: 400px; "
            + "height 100px; text-align: center; background-color: rgb(238, 238, 238);\">WebGLRenderer could not be created.</div>";
        return;
    }

    container.appendChild(renderer.domElement);
    onResize();
    window.addEventListener("resize", onResize);
    window.addEventListener("mousedown", onMouseDown);
    window.addEventListener("touchstart", onMouseDown);
    window.addEventListener("mouseup", onMouseUp);
    window.addEventListener("touchend", onMouseUp);
    window.addEventListener("touchcancel", onMouseUp);
    window.addEventListener("mousemove", onMouseMove);
    window.addEventListener("touchmove", onMouseMove);
    setupScene();
    render();
};

main();
