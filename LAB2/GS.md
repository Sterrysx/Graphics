# Índex

- [0. TEORIA](#0-teoria)
- [1. Skeletons](#1-skeletons)
  - [Per Geometry (Class C)](#class-c-esqueleto-per-geometry)
- [2. Receptes](#2-receptes)
  - [Per Vertex](#a-per-vertex)
  - [Per Fragment](#b-per-fragment)
  - [Per Geometry](#c-per-geometry)
- [3. Exercises](#3-exercises)




<hr style="border: 15px solid blue;">
<hr style="border: 15px solid red;">
<hr style="border: 15px solid blue;">

# 0. TEORIA

## 0.1 La Lògica Universal (Els 5 Passos)

Aquesta és la seqüència **CANÒNICA** per transformar qualsevol geometria (vèrtexs o objectes enters) respecte al seu propi centre o un punt arbitrari.

**L'ordre matemàtic és SAGRAT:**

1. **Centrar:** Portar el punt de referència al `(0,0,0)`.
2. **Escalar:** Fer-ho gran o petit (sempre es fa des de l'origen).
3. **Rotar:** Girar (sempre es gira respecte a l'origen).
4. **Descentrar:** Tornar el punt de referència al seu lloc original.
5. **Moure (Translació Final):** Aplicar el moviment final (animació, explosió, etc.).

```glsl
// Suposem que tens:
// 'pos': la posició del vèrtex
// 'C': el centre de l'objecte (BoundingBox Center o Baricentre)
// 'scale': float (ex: 2.0 per doble, 0.5 per meitat)
// 'rotMatrix': matriu de rotació
// 'desplacament': vector de moviment final

// 1. CENTRAR
pos = pos - C;

// 2. ESCALAR
pos = pos * scale;

// 3. ROTAR
pos = rotMatrix * pos; // En GLSL la matriu va a l'ESQUERRA

// 4. DESCENTRAR (Restaurar posició original relativa)
pos = pos + C;

// 5. MOURE (Translació final / Explosió)
pos = pos + desplacament;

```

---

## 0.2 Matrius de Rotació

Copia aquestes funcions si necessites rotar manualment. Recorda que `angle` ha d'estar en **radians**.

### Rotació Eix X

```glsl
mat3 rotateX(float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return mat3(
        1.0, 0.0, 0.0,
        0.0,   c,  -s,
        0.0,   s,   c
    );
}

```

### Rotació Eix Y

```glsl
mat3 rotateY(float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return mat3(
          c, 0.0,   s,
        0.0, 1.0, 0.0,
         -s, 0.0,   c
    );
}

```

### Rotació Eix Z

```glsl
mat3 rotateZ(float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return mat3(
          c,  -s, 0.0,
          s,   c, 0.0,
        0.0, 0.0, 1.0
    );
}

```

---

## 0.3 Definició de Colors

Snippet ràpid per tenir la paleta de colors bàsica a mà.

```glsl
const vec4 RED     = vec4(1.0, 0.0, 0.0, 1.0);
const vec4 GREEN   = vec4(0.0, 1.0, 0.0, 1.0);
const vec4 BLUE    = vec4(0.0, 0.0, 1.0, 1.0);
const vec4 CYAN    = vec4(0.0, 1.0, 1.0, 1.0);
const vec4 MAGENTA = vec4(1.0, 0.0, 1.0, 1.0);
const vec4 YELLOW  = vec4(1.0, 1.0, 0.0, 1.0);
const vec4 WHITE   = vec4(1.0, 1.0, 1.0, 1.0);
const vec4 BLACK   = vec4(0.0, 0.0, 0.0, 1.0);
const vec4 GREY    = vec4(0.5, 0.5, 0.5, 1.0);
const vec4 ORANGE    = vec4(1.0, 0.5, 0.0, 1.0);
const vec4 PURPLE    = vec4(0.5, 0.0, 0.5, 1.0);
const vec4 VIOLET    = vec4(0.58, 0.0, 0.82, 1.0);
const vec4 PINK      = vec4(1.0, 0.41, 0.7, 1.0);
```

---

## 0.4 Matemàtiques Bàsiques (Fracció, Sostre, Terra)

Funcions essencials per manipular el temps (`time`) o crear patrons repetitius.

```glsl
float x = 3.14159;

// PART FRACCIONÀRIA (fract)
// Retorna els decimals. Útil per fer bucles dins de bucles (0.0 -> 0.99 -> 0.0)
float f = fract(x); // Resultat: 0.14159

// PART ENTERA / TERRA (floor)
// Arrodoneix cap a BAIX a l'enter més proper.
// Útil per identificar "cel·les" en una graella o "fases" de temps.
float i = floor(x); // Resultat: 3.0

// SOSTRE (ceil)
// Arrodoneix cap a DALT a l'enter més proper.
float c = ceil(x);  // Resultat: 4.0

// EXEMPLE TÍPIC: IDENTIFICADOR DE CEL·LA
// Si tens coordenades de textura multiplicades (ex: 5x5)
vec2 st = texCoord * 5.0;
vec2 id = floor(st); // (0,0), (1,0), (2,1)... Identificador únic per quadrat
vec2 uv = fract(st); // (0..1, 0..1) Coordenades locals dins de cada quadrat

```

---

## 0.5 Interpolació Lineal (`mix`)

La funció més important per animar o barrejar colors. Calcula un valor intermig entre `A` i `B` basat en un factor `f`.

**Fórmula:** 

```glsl
// Barrejar dos colors
vec3 colorFinal = mix(RED.xyz, BLUE.xyz, 0.5); // 50% Vermell, 50% Blau (Lila)

// Moure un objecte del punt A al punt B
float t = fract(time); // Factor que va de 0 a 1 constantment
vec3 pos = mix(posicioOrigen, posicioDesti, t);

// RANGS DEL FACTOR (f)
// f = 0.0  --> Retorna el primer valor (A)
// f = 1.0  --> Retorna el segon valor (B)
// f = 0.5  --> Retorna la mitjana exacta

```

---

## 0.6 Operacions Vectorials (Mòdul i Producte)

Imprescindibles per calcular normals, il·luminació i àrees.

### Mòdul (Longitud / Distància)

```glsl
vec3 V = vec3(10.0, 0.0, 0.0);

// LENGTH: La longitud del vector (hipotenusa)
float len = length(V); // Resultat: 10.0

// DISTANCE: La distància entre dos punts (equival a length(P2 - P1))
float d = distance(P1, P2);

// NORMALIZE: Retorna el vector amb direcció igual però longitud 1.0
// IMPRESCINDIBLE fer-ho abans de càlculs d'il·luminació (dot product)
vec3 N = normalize(Normal); 

```

### Producte Vectorial (`cross`)

Retorna un vector **perpendicular** als altres dos.

* **Important:** L'ordre importa (Regla de la mà dreta). `cross(A, B)` és oposat a `cross(B, A)`.
* **Ús:** Calcular la Normal d'un triangle o la seva àrea.

```glsl
vec3 U = V1 - V0; // Aresta 1
vec3 V = V2 - V0; // Aresta 2

// Calcular la NORMAL del triangle
vec3 NormalGeometrica = normalize(cross(U, V));

// Calcular l'ÀREA del triangle
// L'àrea és la meitat del mòdul del producte vectorial
float area = 0.5 * length(cross(U, V));

```


### Producte Escalar (`dot`)

Retorna un `float`. Mesura com de "alineats" estan dos vectors.

* **Fórmula:** .
* **Truc:** Si els vectors estan **normalitzats** (mòdul 1), el resultat és exactament el **cosinus de l'angle**.

**Interpretació del resultat:**

* `1.0`: Vectors paral·lels (mateixa direcció).
* `0.0`: Vectors perpendiculars (90º).
* `-1.0`: Vectors oposats (180º).
* `> 0`: Miren cap al mateix costat (angle < 90º).
* `< 0`: Miren cap a costats oposats (angle > 90º).

```glsl
// CÀLCUL D'IL·LUMINACIÓ (Lambert / Difusa)
// N: Normal de la superfície
// L: Vector cap a la llum (Light Direction)
// max(0.0, ...) serveix per evitar llum negativa si la cara està d'esquena.
float NdotL = max(0.0, dot(N, L)); 

// CÀLCUL DE "RIM LIGHTING" (Vora il·luminada / Efecte vellut)
// V: Vector cap a la càmera/ull
// 1.0 - dot(N, V) dóna valors alts a les vores de l'objecte.
float rim = 1.0 - max(0.0, dot(N, V));

```

### Reflexió (`reflect`)

Calcula el vector de rebot. Imprescindible per a la **il·luminació especular** (brillantor) i mapes d'entorn.

```glsl
// Sintaxi: reflect(Incident, Normal)
// IMPORTANT: El vector Incident ha d'apuntar CAP A la superfície.
// Si tens L (que apunta cap a la llum), has de posar -L.

vec3 R = reflect(-L, N); 

```

### Multiplicació de Matrius

L'ordre en GLSL és **invers** a com ho llegim en text. L'operació es llegeix de dreta a esquerra.

```glsl
// CORRECTE: La matriu transforma el vector (Matriu a l'esquerra)
vec4 posicioClip = projectionMatrix * modelViewMatrix * vec4(vertex, 1.0);

// INCORRECTE: Això no compila o dóna resultats erronis matemàticament
// vec4 posicioClip = vec4(vertex, 1.0) * modelViewMatrix; 

```

### Operacions de Rang (`clamp`)

Manté un valor dins d'uns límits. Vital per evitar colors negatius o més grans que blanc.

```glsl
// Sintaxi: clamp(valor, min, max)

float f = dot(N, L); // Pot donar -0.5 si la llum està darrere
f = clamp(f, 0.0, 1.0); // Ara està segur entre 0 i 1

// També serveix per vectors (ho fa component a component)
vec3 colorSegur = clamp(colorCalculat, vec3(0.0), vec3(1.0));

```



<hr style="border: 15px solid blue;">
<hr style="border: 15px solid red;">
<hr style="border: 15px solid blue;">

---


# 1. Skeletons

## Class C-Esqueleto (PER-GEOMETRY)

### C-Vertex Shader

En este tipo de ejercicios, el Vertex Shader suele ser muy simple ("Pass-Through"). **No proyectamos** todavía a Clip Space porque el Geometry Shader necesita las coordenadas originales (Object Space) para hacer cálculos (como encontrar el centro de un triángulo).

```glsl
#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 2) in vec3 color;

out vec4 vfrontColor; 

void main()
{
    vfrontColor = vec4(color, 1.0);

    gl_Position = vec4(vertex, 1.0); 
}

```

### C-Geometry Shader

Este es el núcleo. Aquí es donde **transformas** las coordenadas a Clip Space y **emites** los vértices.

```glsl
#version 330 core

layout(triangles) in; 
layout(triangle_strip, max_vertices = 3) out;

// --- INPUTS (vienen del VS como arrays []) ---
in vec4 vfrontColor[]; 

// --- OUTPUTS (van al FS) ---
out vec4 gfrontColor;
// out vec2 gtexCoord; 

// --- UNIFORMS ---
uniform mat4 modelViewProjectionMatrix;

void main( void )
{

    for(int i = 0; i < 3; i++)
    {
        gfrontColor = vfrontColor[i];
        vec4 pos = gl_in[i].gl_Position;
        gl_Position = modelViewProjectionMatrix * pos; 
        EmitVertex(); // Emite 1 vértice
    }
    EndPrimitive(); // Cierra el triángulo 
}

```

### C-Fragment Shader

El Fragment Shader suele ser idéntico al de la **Class A**, solo que recibe los datos del GS (prefijo `g`) en lugar del VS.

```glsl
#version 330 core

// --- INPUT (Viene del Geometry Shader) ---
in vec4 gfrontColor; 
// in vec2 gtexCoord; 

// --- OUTPUT ---
out vec4 fragColor;

void main()
{
    fragColor = gfrontColor;
    
    // Si tienes texturas o márgenes (bordes negros):
    // if (gtexCoord.s < 0.05 || gtexCoord.s > 0.95 ...) fragColor = vec4(0);
}

```



<hr style="border: 15px solid blue;">
<hr style="border: 15px solid red;">
<hr style="border: 15px solid blue;">


# 2. Receptes

## A-Per Vertex

### 1. Passar al GS la posició, la normal, el color i la coordenada de textura de cada vèrtex (En Object Space)

**Ús:** Quan tens un **Geometry Shader** després que ha de fer càlculs físics (Lego, extrusions, explosions). El GS rebrà les dades "crues".

```glsl
#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal; 
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord; 

out vec4 vfrontColor; 
out vec3 vNormal; 
out vec2 vtexCoord; 

void main()
{
    // Passem els atributs tal qual (sense modificar)
    vfrontColor = vec4(color, 1.0);
    vNormal = normal;
    vtexCoord = texCoord;

    // Posició "crua" en Object Space. 
    // El GS s'encarregarà de multiplicar per la matriu MVP després.
    gl_Position = vec4(vertex, 1.0); 
}
```

<hr style="height: 2px; background-color: blue; border: none;">

### 2. Passar Posició en CLIP SPACE (Obligatori si NO hi ha GS)

**Ús:** Quan **NO tens Geometry Shader**, o quan el GS necessita coordenades de pantalla directament.
**Important:** Necessites la `modelViewProjectionMatrix`.

```glsl
#version 330 core

layout (location = 0) in vec3 vertex;
uniform mat4 modelViewProjectionMatrix; // Imprescindible

void main()
{
    // Multipliquem per la matriu per projectar a la pantalla
    gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0); 
}
```

<hr style="height: 2px; background-color: blue; border: none;">

### 3. Passar Dades en EYE SPACE (Preparat per Il·luminació)

**Ús:** Quan el següent pas (sigui GS o FS) ha de calcular **Il·luminació (Phong/Lambert)**. La llum es calcula sempre en Eye Space.

```glsl
#version 330 core
layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;

out vec3 vPosEye;    // Posició del vèrtex respecte la càmera
out vec3 vNormalEye; // Normal rotada correctament

uniform mat4 modelViewMatrix;  // Per moure vèrtexs
uniform mat3 normalMatrix;     // Per rotar normals
uniform mat4 modelViewProjectionMatrix; // Per la posició final

void main() {
    // 1. Posició en Eye Space (per vectors L i V)
    vPosEye = (modelViewMatrix * vec4(vertex, 1.0)).xyz;

    // 2. Normal en Eye Space (per productes escalars)
    vNormalEye = normalize(normalMatrix * normal);

    // 3. La gl_Position depèn:
    // - Si hi ha GS: sol ser vec4(vertex, 1.0)
    // - Si NO hi ha GS: OBLIGATORI MVP * vertex (com aquí sota)
    gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0); 
}
```

<hr style="height: 2px; background-color: blue; border: none;">


### 3. Passar la posició en Eye Space

// Si no hi ha GS s'envia en Eye space

``` glsl
out vec3 vNormal;     // Surt del VS
out vec2 vTexCoord;

void main() {
    // OBLIGATORI: Si no hi ha GS, el VS ha de calcular la posició final en CLIP SPACE
    gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0); 
    
    vNormal = normal; // Envia dades per interpolar
}
```

<hr style="height: 2px; background-color: blue; border: none;">


## B-Per Fragment

### 1. Pintar textura en funció de si és o no la cara superior d'un cub

``` glsl
#version 330 core

in vec4 gfrontColor;
in vec2 gtexCoord;

// --- CANVI CLAU: Rebre l'enter sense interpolar ---
flat in int gIsTop; 

out vec4 fragColor;

uniform sampler2D colorMap;

void main()
{
    // Comparació lògica exacta
    if (gIsTop == 1) {
        fragColor = texture(colorMap, gtexCoord);
    } 
    else {
        fragColor = gfrontColor;
    }
}
```


## C-Per Geometry

### 1. Emetre un triangle corresponent al triangle original (amb el color sense il·luminació)

``` glsl
    for (int i = 0; i < 3; i++) {
        gfrontColor = vfrontColor[i];

        // Transform Object Space -> Clip Space
		vec4 pos = gl_in[i].gl_Position; // 1. Get Raw Object Position
        gl_Position = modelViewProjectionMatrix * pos; 	// D. Clip Space (Projection
        EmitVertex();
    }
    EndPrimitive();
```

// Solució alternativa

``` glsl
    for (int i = 0; i < 3; i++) {
        gfrontColor = vfrontColor[i];

        // Transform Object Space -> Clip Space
		vec3 pos = gl_in[i].gl_Position.xyz; // 1. Get Raw Object Position
        gl_Position = modelViewProjectionMatrix * vec4(pos, 1.0); 	// D. Clip Space (Projection
        EmitVertex();
    }
    EndPrimitive();
```

<hr style="height: 2px; background-color: blue; border: none;">

### 2. Emetre un triangle corresponent a la projecció del triangle original al pla Y anterior (Shadow)

``` glsl
    const vec4 COLOR_BLACK  = vec4(0.0, 0.0, 0.0, 1.0);
    for( int i = 0 ; i < 3 ; i++ )
    {
        gfrontColor = COLOR_BLACK;
        vec3 shadowPos = gl_in[i].gl_Position.xyz;	
        shadowPos.y = boundingBoxMin.y;
        
        gl_Position = modelViewProjectionMatrix * vec4(shadowPos, 1.0);         
        EmitVertex(); 
    }
```

<hr style="height: 2px; background-color: blue; border: none;">


### 3. Si és el 1r triangle (està processant la primera primitiva del objecte), dibuixar un rectangle centrat en Centre de costat Longitud, 0.01 per sota de boundingBoxMin.y

Per aquest exemple, donarem el cas on:

* Pintar el rectangle cyan
* Rectangle de costat 2R, on R és la meitat de la diagonal de la capsa englobant de l’escena
* Centrat en (C.x, boundingBoxMin.y, C.z), on C és el centre de la capsa englobant de l'escena

``` glsl
    if (gl_PrimitiveIDIn == 0) { 
        // Calcular Centre i Longitud 
        // "Sigui R la meitat de la diagonal... i sigui C el centre"
        vec3 C = vec3(boundingBoxMax + boundingBoxMin) / 2.0;
        float R = length(boundingBoxMax - boundingBoxMin) / 2.0;

        // "0.01 per sota de boundingBoxMin.y"
        vec3 Center = vec3(C.x, boundingBoxMin.y - 0.01, C.z);
        float Longitud = 2*R;
        
        // Rectangle de color Cyan
        const vec4 CYAN = vec4(0.0, 1.0, 1.0, 1.0);
        gfrontColor = CYAN;

        // --- 2. DEFINICIÓ BASE (Centrat a 0,0,0) ---
        // Creem un quadrat UNITARI (costat 1.0) centrat a l'origen.
        // Així, quan multipliquem per 'Longitud', tindrà exactament la mida 'Longitud'.
        // Ordre: Triangle Strip (Baix-Esq, Baix-Dreta, Dalt-Esq, Dalt-Dreta)
        vec3 offsets[4];
        offsets[0] = vec3(-0.5, 0.0, -0.5);
        offsets[1] = vec3( 0.5, 0.0, -0.5);
        offsets[2] = vec3(-0.5, 0.0,  0.5);
        offsets[3] = vec3( 0.5, 0.0,  0.5);

        // Pels 4 vèrtexs del quadrat
        for (int i = 0; i < 4; i++) {
            vec3 pos = offsets[i]; // 1. CENTRAR (Ja està al 0,0,0 local)

            // 2. ESCALAR (Multipliquem per la mida final desitjada)
            // De mida 1 passa a mida 'Longitud' (que és 2*R)
            pos = pos * Longitud; 

            // 3. ROTAR (No cal aquí)

            // 4. DESCENTRAR (No cal perquè el nostre origen local era correcte)

            // 5. MOURE (Translació final a la posició de destí)
            pos = pos + Center;

            // Sortida
            gl_Position = modelViewProjectionMatrix * vec4(pos, 1.0);
            EmitVertex();
        }
        EndPrimitive();
    }
```

<hr style="height: 2px; background-color: blue; border: none;">

### 4. Aplicar a cada vèrtex del triangle la translació T

Nota: Per fer la translació no cal estar centrat: ens ho saltem

``` glsl
    // Suposem que tenim un vector T definit, per exemple:
    // vec3 T = vec3(0.0, 1.0, 0.0); 

    for(int i = 0; i < 3; i++)
    {
        gfrontColor = vfrontColor[i];

        // Obtenir posició original (Object Space)
        vec3 pos = gl_in[i].gl_Position.xyz;

        // 5. MOURE (Translació T)
        // Simplement sumem el vector al vèrtex actual
        pos = pos + T;

        // Projecció final
        gl_Position = modelViewProjectionMatrix * vec4(pos, 1.0);
        EmitVertex();
    }
    EndPrimitive();
```

<hr style="height: 2px; background-color: blue; border: none;">

### 5. Calcular n, on n és el promig de les normals dels 3 vèrtexs del triangle en Object Space

``` glsl
in vec3 vNormal[]; 

void main ( void() ) {
    vec3 n = (vNormal[0] + vNormal[1] + vNormal[2]) / 3.0;
    ...
}
```

//EXTRA, si ens demanen el promig normalitzat

``` glsl
in vec3 vNormal[]; 

void main ( void() ) {
    //Nota dividir per 3 si fas normalize es redundant matemàticament
    vec3 n = normalize(vNormal[0] + vNormal[1] + vNormal[2]);
    ...
}
```

<hr style="height: 2px; background-color: blue; border: none;">


### 6. Treure els vèrtexs en Clip Space

Nota: Sempre ens demanaran que treguins els vèrtexs en Clip Space el GS

``` glsl
    for(int i = 0; i < 3; i++)
    {
        gfrontColor = vfrontColor[i];
        vec3 pos = gl_in[i].gl_Position.xyz;
        gl_Position = modelViewProjectionMatrix * vec4(pos, 1.0);
        EmitVertex();
    }
    EndPrimitive();
```

<hr style="height: 2px; background-color: blue; border: none;">

### 7. Aplicar una translació en Eye Space

**Quan t'ho demanen?**
Quan la translació depèn de la càmera.

* Exemple: "Mou els vèrtexs 2 unitats **cap a la càmera**".
* Exemple: "Fes que l'objecte sempre estigui orientat cap a l'observador."

```glsl
    // Vector T en Eye Space (Ex: moure 1 unitat cap a la dreta de la PANTALLA)
    vec3 T_eye = vec3(1.0, 0.0, 0.0); 

    for(int i = 0; i < 3; i++) {
        // 1. OBJECT -> EYE
        vec4 posEye = modelViewMatrix * gl_in[i].gl_Position; 
        
        // 2. APLICAR TRANSLACIÓ (En coordenades de càmera)
        posEye.xyz = posEye.xyz + T_eye;

        // 3. EYE -> CLIP (Només matriu Projecció, la ModelView ja l'hem usat)
        gl_Position = projectionMatrix * posEye;
        
        EmitVertex();
    }

```

<hr style="height: 2px; background-color: blue; border: none;">

### 8. Aplicar a cada vèrtex del triangle, una translació T, una rotació R i un escalat S

``` glsl
    for(int i = 0; i < 3; i++)
    {
        gfrontColor = vfrontColor[i];
        vec3 pos = gl_in[i].gl_Position.xyz;

        // --- ELS 5 PASSOS UNIVERSALS ---

        // 1. CENTRAR (Portar l'objecte al 0,0,0 local)
        pos = pos - C;

        // 2. ESCALAR (Canviar la mida)
        pos = pos * S;

        // 3. ROTAR (Aplicar matriu de rotació)
        pos = R * pos; 

        // 4. DESCENTRAR (Tornar a la posició original)
        pos = pos + C;

        // 5. MOURE (Aplicar la translació final T)
        pos = pos + T;

        // -------------------------------

        gl_Position = modelViewProjectionMatrix * vec4(pos, 1.0);
        EmitVertex();
    }
    EndPrimitive();
```

<hr style="height: 2px; background-color: blue; border: none;">

### 9. Calcular el centre d'un triangle (Baricentre)

``` glsl
vec3 BT = (gl_in[0].gl_Position.xyz + gl_in[1].gl_Position.xyz + gl_in[2].gl_Position.xyz) / 3.0;
```

<hr style="height: 2px; background-color: blue; border: none;">

### 10. Dibuixar n triangles (primitives) per segon

Anem a assumir que volem que el GS emeti només els n primers triangles. Però si n vé donat pel temps t, anirem dibuixant més triangles cada segon fins haver dibuixat la figura sencera.

Suposem que volem dibuixar els n primers triangles on n = 100*time (truncament).

``` glsl
uniform float time;
int n = floor(100*time);

if (gl_PrimitiveIDIn <= n) {
	for (int i = 0; i < 3; i++) {
        gfrontColor = vfrontColor[i];

        // Transform Object Space -> Clip Space
		vec3 pos = gl_in[i].gl_Position.xyz; // 1. Get Raw Object Position
        gl_Position = modelViewProjectionMatrix * vec4(pos, 1.0); 	// D. Clip Space (Projection
        EmitVertex();
    }
    EndPrimitive();
}
```


<hr style="height: 2px; background-color: blue; border: none;">

### 11. Emetre els triangles amb il.luminació (enviar normal i posició al FS amb Eye Space)

Nota: GS no calcula la il.luminació, ho prepara perquè fragment shader la calculi.

``` glsl
// --- CONFIGURACIÓ ---
in vec3 vNormal[];      // Normal que ve del Vertex Shader (Object Space)
out vec3 gNormal;       // Normal cap al Fragment Shader (Eye Space)
out vec3 gPos;          // Posició cap al Fragment Shader (Eye Space)

uniform mat4 modelViewMatrix;
uniform mat3 normalMatrix;

void main() {
    for (int i = 0; i < 3; i++) {
        // 1. NORMAL: Transformem a Eye Space per càlculs de llum
        // (Important: utilitzar normalMatrix)
        gNormal = normalize(normalMatrix * vNormal[i]);

        // 2. POSICIÓ (Física): Transformem a Eye Space 
        // (Necessari per calcular el vector Llum L i Visió V al FS)
        gPos = (modelViewMatrix * gl_in[i].gl_Position).xyz;

        // 3. POSICIÓ (Pantalla): Transformem a Clip Space
        // (Això és només per pintar el píxel al lloc correcte)
        gl_Position = modelViewProjectionMatrix * gl_in[i].gl_Position;
        
        EmitVertex();
    }
    EndPrimitive();
}
```

<hr style="height: 2px; background-color: blue; border: none;">

### 12. Calcular els 3 vèrtexs del triangle, les 2 arestes, i la normal en Object Space

``` glsl
// Uniforms necessaris per passar a Clip Space al final
uniform mat4 modelViewProjectionMatrix;

void main( void )
{
    // --- 1. CÀLCULS EN OBJECT SPACE ---
    // Recuperem els vèrtexs crus (tal com venen del fitxer .obj)
    vec3 V0 = gl_in[0].gl_Position.xyz;
    vec3 V1 = gl_in[1].gl_Position.xyz;
    vec3 V2 = gl_in[2].gl_Position.xyz;

    // Calculem vectors direccional (arestes)
    vec3 U = V1 - V0;
    vec3 V = V2 - V0;

    // Calculem la Normal en Object Space
    vec3 N = normalize(cross(U, V));

    // --- 2. EMISSIÓ EN CLIP SPACE ---
    for(int i = 0; i < 3; i++)
    {
        gfrontColor = vfrontColor[i];
        // Transformació final: Object Space -> Clip Space
        gl_Position = modelViewProjectionMatrix * gl_in[i].gl_Position;
        EmitVertex();
    }
    EndPrimitive();
}
```


<hr style="height: 2px; background-color: blue; border: none;">

### 13. Calcular els 3 vèrtexs del triangle, les 2 arestes, i la normal en Clip Space


``` glsl
#version 330 core

layout(triangles) in;
layout(triangle_strip, max_vertices = 3) out;

in vec4 vfrontColor[];
out vec4 gfrontColor;

// SEPAREM LES MATRIUS
uniform mat4 modelViewMatrix;  // Transforma: Objecte -> Ull
uniform mat4 projectionMatrix; // Transforma: Ull -> Clip (Pantalla)
uniform mat3 normalMatrix;     // (Opcional) Per transformar normals si venen del VS

void main( void )
{
    // --- 1. PASSAR A EYE SPACE (Coordenades d'Ull) ---
    // Aquí és on fem: vec3 V = (VM * vertex).xyz
    vec3 V0 = (modelViewMatrix * gl_in[0].gl_Position).xyz;
    vec3 V1 = (modelViewMatrix * gl_in[1].gl_Position).xyz;
    vec3 V2 = (modelViewMatrix * gl_in[2].gl_Position).xyz;

    // --- 2. CÀLCULS GEOMÈTRICS (Ara són correctes respecte a la càmera) ---
    vec3 U = V1 - V0;
    vec3 V = V2 - V0;
    
    // Normal en Eye Space (Perfecta per il·luminació)
    vec3 N = normalize(cross(U, V));
    
    // Exemple: Calcular el baricentre en Eye Space
    vec3 BT = (V0 + V1 + V2) / 3.0;


    // --- 3. EMISSIÓ (Aplicant la PROJECTION MATRIX) ---
    for(int i = 0; i < 3; i++)
    {
        gfrontColor = vfrontColor[i];
        
        // Recuperem el vèrtex en Eye Space que ja tenim calculat
        vec3 posEye;
        if(i==0) posEye = V0;
        else if(i==1) posEye = V1;
        else posEye = V2;

        // TRANSFORMACIÓ FINAL: Eye -> Clip
        gl_Position = projectionMatrix * vec4(posEye, 1.0);
        
        EmitVertex();
    }
    EndPrimitive();
}
```

<hr style="height: 2px; background-color: blue; border: none;">

### 14. Els vèrtexs conserven el color original modulat per la z de la normal en coordenades d'ull

``` glsl
// 1. Transformar vèrtexs a EYE SPACE (Imprescindible per tenir la Normal orientada a càmera)
vec3 V0 = (modelViewMatrix * gl_in[0].gl_Position).xyz;
vec3 V1 = (modelViewMatrix * gl_in[1].gl_Position).xyz;
vec3 V2 = (modelViewMatrix * gl_in[2].gl_Position).xyz;

// 2. Calcular la Normal Geomètrica en Eye Space
vec3 U = V1 - V0;
vec3 V = V2 - V0;
vec3 N = normalize(cross(U, V));

// 3. Emetre els vèrtexs
for(int i = 0; i < 3; i++)
{
    // Modulació del color original per la component Z de la normal
    // N.z en Eye Space actua com una il·luminació direccional simple des de la càmera
    gfrontColor = vfrontColor[i] * N.z;

    // Assignar posició final en CLIP SPACE (Projection * EyePos)
    vec3 posEye;
    if(i==0) posEye = V0;
    else if(i==1) posEye = V1;
    else posEye = V2;
    gl_Position = projectionMatrix * vec4(posEye, 1.0);

    EmitVertex();
}
EndPrimitive();
```

<hr style="height: 2px; background-color: blue; border: none;">

### 15. Emetre un quadrat en l'eix XY de costat L, centrat en l'eix de coordenades amb centre V

``` glsl
// Suposem que tenim:
// vec3 V;      -> El centre on vols el quadrat (en Eye Space)
// float L;     -> La longitud del costat

// --- 1. DEFINICIÓ BASE (Centrat a 0,0,0 local) ---
// Creem un quadrat UNITARI (1x1) al pla XY (Z=0).
// Ordre Triangle Strip: Baix-Esq -> Baix-Dreta -> Dalt-Esq -> Dalt-Dreta
vec3 offsets[4];
offsets[0] = vec3(-0.5, -0.5, 0.0);
offsets[1] = vec3( 0.5, -0.5, 0.0);
offsets[2] = vec3(-0.5,  0.5, 0.0);
offsets[3] = vec3( 0.5,  0.5, 0.0);

//Exemple si volguessim pla XZ
//offsets[0] = vec3(-0.5, 0.0, -0.5);
//offsets[1] = vec3( 0.5, 0.0, -0.5);
//offsets[2] = vec3(-0.5, 0.0,  0.5);
//offsets[3] = vec3( 0.5, 0.0,  0.5);

// Bucle per generar els 4 vèrtexs
for (int i = 0; i < 4; i++) {
    
    vec3 pos = offsets[i]; // 1. CENTRAR (Ja el tenim al 0,0,0 local)

    // 2. ESCALAR
    // Multipliquem per la mida desitjada (L)
    pos = pos * L;

    // 3. ROTAR 
    // (No cal fer res perquè ja hem definit els offsets al pla XY)

    // 4. DESCENTRAR 
    // (No cal perquè el pivot de l'escala era el propi centre)

    // 5. MOURE (Translació Final)
    // Movem el quadrat del (0,0,0) a la posició V
    pos = pos + V;

    // --- SORTIDA ---
    // Com que V ja estava en Eye Space, només apliquem Projecció
    gl_Position = projectionMatrix * vec4(pos, 1.0);
    // Si V no està en Eye Space, multipliquem per modelViewProjectionMatrix
    EmitVertex();
}
EndPrimitive();
```

<hr style="height: 2px; background-color: blue; border: none;">

### 16. Emetre un cub de costat L, centrat en l'eix de coordenades amb centre V

``` glsl
uniform mat4 projectionMatrix;
// Suposem que V ja ve en Eye Space o el calculem fora
// uniform mat4 modelViewMatrix; (Si calgués transformar V)

// Paràmetres del cub
// vec3 V;  -> Centre del cub
// float L; -> Costat

void main( void )
{
    // A. SETUP INICIAL
    // Suposem que V és el centre del cub (en Eye Space)
    vec3 V = (modelViewMatrix * gl_in[0].gl_Position).xyz; // Exemple
    float L = 1.0; // Exemple o Uniform

    // B. DEFINICIÓ BASE (Cara Frontal del Cub Unitari)
    // El cub unitari va de -0.5 a 0.5.
    // La cara frontal està a Z = +0.5.
    vec3 baseOffsets[4];
    baseOffsets[0] = vec3(-0.5, -0.5, 0.5);
    baseOffsets[1] = vec3( 0.5, -0.5, 0.5);
    baseOffsets[2] = vec3(-0.5,  0.5, 0.5);
    baseOffsets[3] = vec3( 0.5,  0.5, 0.5);

    // C. DEFINICIÓ DE LES 6 ROTACIONS (Matrius)
    // Cadascuna orienta la cara "base" cap a una direcció
    mat3 faceRotations[6];
    faceRotations[0] = mat3( 1, 0, 0,  0, 1, 0,  0, 0, 1); // Front (No rota)
    faceRotations[1] = mat3(-1, 0, 0,  0, 1, 0,  0, 0,-1); // Back  (Rot Y 180)
    faceRotations[2] = mat3( 0, 0, 1,  0, 1, 0, -1, 0, 0); // Right (Rot Y -90)
    faceRotations[3] = mat3( 0, 0,-1,  0, 1, 0,  1, 0, 0); // Left  (Rot Y +90)
    faceRotations[4] = mat3( 1, 0, 0,  0, 0, 1,  0,-1, 0); // Top   (Rot X -90)
    faceRotations[5] = mat3( 1, 0, 0,  0, 0,-1,  0, 1, 0); // Bottom(Rot X +90)

    // D. BUCLE DE 6 CARES
    for (int iFace = 0; iFace < 6; iFace++) 
    {
        // Recuperem la matriu de rotació per a aquesta cara
        mat3 R = faceRotations[iFace];

        // E. BUCLE DE 4 VÈRTEXS (QUAD)
        for (int iVert = 0; iVert < 4; iVert++) 
        {
            vec3 pos = baseOffsets[iVert]; // 1. CENTRAR (La base ja està centrada a l'origen)

            // 2. ESCALAR
            // Multipliquem per L per tenir la mida correcta
            pos = pos * L; 

            // 3. ROTAR
            // Apliquem la rotació de la cara (iFace)
            pos = R * pos;

            // 4. DESCENTRAR (No cal)

            // 5. MOURE (Translació Final al centre V)
            pos = pos + V;

            // --- SORTIDA ---
            gfrontColor = vfrontColor[0]; // O un color diferent per cara si vols
            
            gl_Position = projectionMatrix * vec4(pos, 1.0);
            EmitVertex();
        }
        EndPrimitive(); // Tanquem la cara actual (Triangle Strip) abans de la següent
    }
}
```

<hr style="height: 2px; background-color: blue; border: none;">

### 17. Enviar un flag al FS per a que texturitzi certes parts, en l'exemple del cub, texturitzar la cara Top.

``` glsl
#version 330 core

layout(triangles) in;
layout(triangle_strip, max_vertices = 24) out;

in vec4 vfrontColor[];
out vec4 gfrontColor;

// --- CANVI CLAU: 'flat' evita la interpolació ---
flat out int gIsTop; // 1 si és Top, 0 si no
out vec2 gtexCoord; 

uniform mat4 projectionMatrix;
uniform mat4 modelViewMatrix;

void main( void )
{
    vec3 V = (modelViewMatrix * gl_in[0].gl_Position).xyz; 
    float L = 1.0; 

    // Offsets i UVs (Igual que abans)
    vec3 baseOffsets[4];
    baseOffsets[0] = vec3(-0.5, -0.5, 0.5);
    baseOffsets[1] = vec3( 0.5, -0.5, 0.5);
    baseOffsets[2] = vec3(-0.5,  0.5, 0.5);
    baseOffsets[3] = vec3( 0.5,  0.5, 0.5);

    vec2 baseUVs[4];
    baseUVs[0] = vec2(0.0, 0.0);
    baseUVs[1] = vec2(1.0, 0.0);
    baseUVs[2] = vec2(0.0, 1.0);
    baseUVs[3] = vec2(1.0, 1.0);

    // Matrius de rotació (Igual que abans)
    mat3 faceRotations[6];
    faceRotations[0] = mat3( 1, 0, 0,  0, 1, 0,  0, 0, 1); // Front
    faceRotations[1] = mat3(-1, 0, 0,  0, 1, 0,  0, 0,-1); // Back
    faceRotations[2] = mat3( 0, 0, 1,  0, 1, 0, -1, 0, 0); // Right
    faceRotations[3] = mat3( 0, 0,-1,  0, 1, 0,  1, 0, 0); // Left
    faceRotations[4] = mat3( 1, 0, 0,  0, 0, 1,  0,-1, 0); // Top
    faceRotations[5] = mat3( 1, 0, 0,  0, 0,-1,  0, 1, 0); // Bottom

    for (int iFace = 0; iFace < 6; iFace++) 
    {
        mat3 R = faceRotations[iFace];

        // --- DEFINIM EL FLAG COM A ENTER ---
        // Si és la cara 4, és un 1, sinó un 0.
        int isTop = (iFace == 4) ? 1 : 0;

        for (int iVert = 0; iVert < 4; iVert++) 
        {
            vec3 pos = baseOffsets[iVert];
            pos = pos * L; 
            pos = R * pos;
            pos = pos + V;

            gfrontColor = vfrontColor[0];
            gtexCoord = baseUVs[iVert]; 
            
            // Passem l'enter directament. 
            // Com que tots els vertexs d'aquesta cara tenen el mateix valor,
            // el fragment shader rebrà aquest valor exacte.
            gIsTop = isTop;

            gl_Position = projectionMatrix * vec4(pos, 1.0);
            EmitVertex();
        }
        EndPrimitive(); 
    }
}
```

<hr style="height: 2px; background-color: blue; border: none;">


<hr style="border: 15px solid blue;">
<hr style="border: 15px solid red;">
<hr style="border: 15px solid blue;">

# 3. Exercises

## A-Per Vertex
## B-Per Fragment
## C-Per Geometry