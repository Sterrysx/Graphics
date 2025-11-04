# Guia Completa de Shaders GLSL

> **Important:** Els shaders d'aquesta guia estan pensats per ser executats amb el GLarena Viewer ubicat a:
> ```
> ~/assig/grau-g/Viewer/GLarenaSL
> ```

## 1. Estructura Bàsica dels Shaders

### Vertex Shader
```glsl
#version 330 core

// Input attributes
layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal; 
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

// Output variables
out vec4 frontColor;
out vec2 vtexCoord;

// Uniforms comuns
uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform float time;
```

### Fragment Shader
```glsl
#version 330 core
in vec4 frontColor;
in vec2 vtexCoord;
out vec4 fragColor;
```

## 2. Variables Uniformes Importants

- `modelViewProjectionMatrix`: Matriu combinada de model, vista i projecció
- `modelViewMatrix`: Matriu de model i vista
- `projectionMatrix`: Matriu de projecció
- `normalMatrix`: Matriu per transformar normals
- `time`: Variable de temps per animacions
- `mousePosition`: Posició del ratolí
- `viewport`: Dimensions de la finestra

## 2.1. Uniforms Específics del Viewer (Core Profile)

### Matrius
- `modelMatrix` (mat4): Model space → World space
- `viewMatrix` (mat4): World space → Eye space
- `projectionMatrix` (mat4): Eye space → Clip space
- `modelViewMatrix` (mat4): Model space → Eye space
- `modelViewProjectionMatrix` (mat4): Model space → Clip space
- `modelMatrixInverse` (mat4): World space → Model space
- `viewMatrixInverse` (mat4): Eye space → World space
- `projectionMatrixInverse` (mat4): Clip space → Eye space
- `modelViewMatrixInverse` (mat4): Eye space → Model space
- `modelViewProjectionMatrixInverse` (mat4): Clip space → Model space
- `normalMatrix` (mat3): Matriu per transformar normals (Model space → Eye space)

### Il·luminació
- `lightAmbient` (vec4): Color ambient RGBA
- `lightDiffuse` (vec4): Color difús RGBA
- `lightSpecular` (vec4): Color especular RGBA
- `lightPosition` (vec4): Posició de la llum en eye space (x,y,z,w). Si w=0 és direccional

### Materials
- `matAmbient` (vec4): Color ambient del material RGBA
- `matDiffuse` (vec4): Color difús del material RGBA
- `matSpecular` (vec4): Color especular del material RGBA
- `matShininess` (float): Brillantor del material (exponent especular)

### Geometria i Interacció
- `boundingBoxMin` (vec3): Cantonada mínima de la capsa englobant en model space
- `boundingBoxMax` (vec3): Cantonada màxima de la capsa englobant en model space
- `mousePosition` (vec2): Coordenades del cursor en window space (x,y) amb origen a la cantonada inferior esquerra

## 3. Funcions Matemàtiques Útils

### Trigonométriques
- `sin()`, `cos()`, `tan()`
- `asin()`, `acos()`, `atan()`
- `radians()`: Converteix graus a radians
- `degrees()`: Converteix radians a graus

### Vectors
- `normalize()`: Normalitza un vector
- `length()`: Retorna la longitud d'un vector
- `distance()`: Distància entre dos punts
- `dot()`: Producte escalar
- `cross()`: Producte vectorial
- `reflect()`: Reflexió d'un vector

### Geometria
```glsl
// Comprova si un punt està dins d'un cercle
bool inside(vec2 st, vec2 center, float radius) {
    return distance(st, center) <= radius;
}
```

Exemple d'ús:
```glsl
void main() {
    vec2 center = vec2(0.5);
    float radius = 0.3;
    if (inside(vtexCoord, center, radius)) {
        fragColor = vec4(1.0); // Dins del cercle
    } else {
        fragColor = vec4(0.0); // Fora del cercle
    }
}
```

### Interpolació
- `mix()`: Interpolació lineal entre dos valors
- `smoothstep()`: Interpolació suau entre dos valors
- `clamp()`: Limita un valor entre un mínim i màxim

## 4. Patrons Comuns de Solució

### Per Animacions
```glsl
void main() {
    float t = time * speed;
    vec3 newPosition = vertex + normal * amplitude * sin(t);
    gl_Position = modelViewProjectionMatrix * vec4(newPosition, 1.0);
}
```

### Per Textures
```glsl
uniform sampler2D colorMap;
void main() {
    fragColor = texture(colorMap, vtexCoord);
}
```

## 5. Consideracions Importants

### Precisions dels Tipus
- Utilitzar `float` per números decimals
- Afegir `.0` als números enters que s'han de tractar com floats

### Transformacions
- Aplicar transformacions en l'ordre correcte: Model -> View -> Projection
- Utilitzar `normalMatrix` per transformar normals correctament

### Textures
- Coordenades de textura entre 0 i 1
- Utilitzar `texture()` per mostrejar textures
- Tenir en compte els modes de wrapping i filtering

### Textura Esfèrica (Equirectangular Mapping)
```glsl
// Converteix coordenades cartesianes a coordenades esfèriques (equirectangular mapping)
vec2 sphericalTexCoord(vec3 pos) {
    // Normalitzem la posició per assegurar que estem a la superfície de l'esfera
    vec3 npos = normalize(pos);
    
    // Calculem θ (longitude) i ψ (latitude)
    float theta = atan(npos.z, npos.x);     // θ = atan(z/x)
    float psi = asin(npos.y);               // ψ = asin(y)
    
    // Convertim a coordenades UV (entre 0 i 1)
    return vec2(
        theta / (2.0 * PI),     // u = θ/(2π)
        (psi / PI) + 0.5        // v = ψ/π + 0.5
    );
}
```
On:
- `theta (θ)`: angle en el pla XZ (longitud), rang [-π, π]
- `psi (ψ)`: angle respecte l'eix Y (latitud), rang [-π/2, π/2]
- Les coordenades UV resultants estan en el rang [0,1]
- Útil per mapejar textures panoràmiques equirectangulars

### Optimització
- Minimitzar càlculs en el fragment shader
- Passar càlculs constants al vertex shader quan sigui possible
- Evitar divisions i funcions trigonomètriques innecessàries
- Utilitzar `const` per valors fixos
- Minimitzar branching en fragment shaders

### Debug
- Utilitzar colors sòlids per debugar
- Visualitzar normals o coordenades com a colors
- Comprovar valors extrems dels inputs

## 6. Exemples de Transformacions

### Transformació Bàsica
```glsl
void main() {
    // Transformació de vèrtexs
    vec4 position = modelViewProjectionMatrix * vec4(vertex, 1.0);
    
    // Transformació de normals
    vec3 N = normalize(normalMatrix * normal);
    
    // Color bàsic
    frontColor = vec4(color, 1.0);
    
    // Posició final
    gl_Position = position;
}
```

### Rotació 2D
```glsl
vec2 rotate(vec2 p, float a) {
    return vec2(
        p.x * cos(a) - p.y * sin(a),
        p.x * sin(a) + p.y * cos(a)
    );
}
```

### Escala
```glsl
vec3 scale(vec3 p, vec3 s) {
    return p * s;
}
```

### Matrius de Rotació
```glsl
// Rotació al voltant de l'eix X (columna-major)
mat4 rotateX(float angle) {
    return mat4(
        vec4(1,     0,          0,      0),     // Primera columna
        vec4(0,     cos(angle), sin(angle), 0), // Segona columna
        vec4(0,    -sin(angle), cos(angle), 0), // Tercera columna
        vec4(0,     0,          0,      1)      // Quarta columna
    );
}

// Rotació al voltant de l'eix Y (columna-major)
mat4 rotateY(float angle) {
    return mat4(
        vec4(cos(angle),  0,   -sin(angle), 0), // Primera columna
        vec4(0,          1,    0,          0),  // Segona columna
        vec4(sin(angle), 0,    cos(angle),  0), // Tercera columna
        vec4(0,          0,    0,          1)   // Quarta columna
    );
}

// Rotació al voltant de l'eix Z (columna-major)
mat4 rotateZ(float angle) {
    return mat4(
        vec4(cos(angle),  sin(angle), 0,  0),  // Primera columna
        vec4(-sin(angle), cos(angle), 0,  0),  // Segona columna
        vec4(0,          0,          1,  0),  // Tercera columna
        vec4(0,          0,          0,  1)   // Quarta columna
    );
}
```

## 7. Efectes Comuns

### Fade
```glsl
float fade = clamp(time, 0.0, 1.0);
fragColor = vec4(color, fade);
```

### Pulsació
```glsl
float pulse = 0.5 + 0.5 * sin(time);
```

## 8. Variables Built-in Importants

### Vertex Shader
- `gl_Position`: Posició final del vèrtex (vec4)
- `gl_PointSize`: Mida del punt quan es dibuixen punts
- `gl_VertexID`: Índex del vèrtex actual
- `gl_InstanceID`: Índex de la instància actual

### Fragment Shader
- `gl_FragCoord`: Posició del fragment en coordenades de pantalla
- `gl_FrontFacing`: Boolean que indica si el fragment és frontal
- `gl_PointCoord`: Coordenades dins d'un punt (0,0 a 1,1)

## 9. Operacions amb Textures Avançades

### Sampling amb Offset
```glsl
vec4 sampleOffset(sampler2D tex, vec2 uv, vec2 offset) {
    return texture(tex, uv + offset);
}
```

### Efecte Blur
```glsl
vec4 blur(sampler2D tex, vec2 uv, float radius) {
    vec4 color = vec4(0.0);
    float total = 0.0;
    for(float x = -radius; x <= radius; x += 1.0) {
        for(float y = -radius; y <= radius; y += 1.0) {
            color += texture(tex, uv + vec2(x, y) * 0.01);
            total += 1.0;
        }
    }
    return color / total;
}
```

### Anti-Aliasing
```glsl
// Versió anti-aliased de la funció step
float aastep(float threshold, float x) {
    float width = 0.7 * length(vec2(dFdx(x), dFdy(x)));
    return smoothstep(threshold-width, threshold+width, x);
}
```

Exemple d'ús per dibuixar un cercle amb vores suaus:
```glsl
const vec2 centre = vec2(0.5);
void main() {
    float d = length(vec2(vtexCoord.x-centre.x, vtexCoord.y-centre.y));
    fragColor = vec4(1.0, vec2(step(0.2, d)), 1.0);
    // Versió anti-aliased:
    // fragColor = vec4(1.0, vec2(aastep(0.2, d)), 1.0);
}
```

Components clau:
- `dFdx(x)`, `dFdy(x)`: Derivades parcials per calcular l'amplada del filtre
- `width`: Amplada del filtre anti-aliasing (0.7 és un valor típic)
- `smoothstep`: Interpolació suau entre els valors del llindar

## 10. Càlculs d'Il·luminació

### Components del Model de Phong

#### 1. Component Ambiental: `matAmbient * lightAmbient`
- Simula la llum indirecta present a l'escena
- No depèn de la posició de l'observador ni de la llum

#### 2. Component Difús: `matDiffuse * lightDiffuse * Idiff`
- Segueix la llei de Lambert (`Idiff = max(0, N·L)`)
- Depèn de l'angle entre la normal i la direcció de la llum
- No depèn de la posició de l'observador

#### 3. Component Especular: `matSpecular * lightSpecular * Ispec`
- Simula el reflex brillant en superfícies lluents
- Depèn de l'angle entre el vector de reflexió i la direcció de visió
- Utilitza l'exponent de shininess per controlar la mida del reflex

#### Vectors Clau
- **N**: Vector normal normalitzat a la superfície
- **L**: Vector normalitzat direcció cap a la font de llum
- **V**: Vector normalitzat direcció cap a l'observador
- **R**: Vector normalitzat de reflexió, calculat com `2(N·L)N-L`

### Il·luminació amb Materials del Viewer (Phong)
```glsl
vec4 light(vec3 N, vec3 V, vec3 L) {
    N = normalize(N); V = normalize(V); L = normalize(L);
    vec3 R = normalize(2.0 * dot(N,L) * N - L);
    float NdotL = max(0.0, dot(N,L));
    float RdotV = max(0.0, dot(R,V));
    float Idiff = NdotL;
    float Ispec = 0;
    if (NdotL > 0) Ispec = pow(RdotV, matShininess);
    return 
        matAmbient * lightAmbient +
        matDiffuse * lightDiffuse * Idiff +
        matSpecular * lightSpecular * Ispec;
}
```

## 11. Funcions d'Utilitat Addicionals

### Transformació de Coordenades
```glsl
vec3 worldToObject(vec3 p, mat4 modelMatrix) {
    return (inverse(modelMatrix) * vec4(p, 1.0)).xyz;
}

vec3 objectToWorld(vec3 p, mat4 modelMatrix) {
    return (modelMatrix * vec4(p, 1.0)).xyz;
}
```

### Generadors de Soroll
```glsl
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}
```

### Utils per Debugging
```glsl
vec4 visualizeNormal(vec3 normal) {
    return vec4(normalize(normal) * 0.5 + 0.5, 1.0);
}

vec4 visualizeUV(vec2 uv) {
    return vec4(uv, 0.0, 1.0);
}
```

## 12. Tècniques de Renderitzat

### Outline Effect
```glsl
float getOutline(sampler2D depthTex, vec2 uv, float thickness) {
    float depth = texture(depthTex, uv).r;
    float outline = 0.0;
    for(int i = -1; i <= 1; i++) {
        for(int j = -1; j <= 1; j++) {
            float sampleDepth = texture(depthTex, uv + vec2(i,j) * thickness).r;
            outline += abs(depth - sampleDepth);
        }
    }
    return outline > 0.001 ? 1.0 : 0.0;
}
```

## 13. Tips per Optimització

- Utilitzar `if` només quan sigui absolutament necessari
- Precalcular valors constants al CPU
- Utilitzar `const` per variables que no canvien
- Evitar divisions per zero amb `max(denominator, 0.0001)`
- Utilitzar versions optimitzades de funcions:
  - `pow(x,2.0)` → `x*x`
  - `pow(x,3.0)` → `x*x*x`
  - `pow(x,4.0)` → `(x*x)*(x*x)`