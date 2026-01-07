# Índex

- [0. TEORIA](#0-teoria)
- [1. Skeletons](#1-skeletons)
  - [Per Vertex (Class A)](#class-a-esqueleto-per-vertex-deformación)
  - [Per Fragment (Class B)](#class-b-esqueleto-per-fragment)
- [2. Receptes](#2-receptes)
  - [Per Vertex](#a-per-vertex)
  - [Per Fragment](#b-per-fragment)
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

<hr style="border: 15px solid blue;">
<hr style="border: 15px solid red;">
<hr style="border: 15px solid blue;">


---


## Class A-Esqueleto (PER-VERTEX) (Deformación)

### A-Vertex Shader

```glsl
#version 330 core

// --- INPUTS (from your 3D model) ---
layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

// --- OUTPUTS (to the Fragment Shader) ---
out vec4 frontColor; // El color FINAL calculado por vértice
out vec2 vtexCoord;  // La coordenada de textura

// --- UNIFORMS (from the viewer) ---
uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

void main()
{
    vec4 vertex_objectspace = vec4(vertex, 1.0);
    vec3 normal_objectspace = normal;

    // Calcula la normal en Eye Space
    vec3 N = normalize(normalMatrix * normal_objectspace);

    // Calcula el color (iluminación simple por Z)
    frontColor = vec4(color,1.0) * N.z;

    // Pasa la coordenada de textura
    //vtexCoord = texCoord;

    // Calcula la posición final
    gl_Position = modelViewProjectionMatrix * vertex_objectspace;
}
```

**NOTA** Si te pide modificar la Projection y la Normal Space, se tiene que calcular por si solo:

```glsl
#version 330 core

// --- INPUTS (from your 3D model) ---
layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

// --- OUTPUTS (to the Fragment Shader) ---
out vec4 frontColor; // El color FINAL calculado por vértice
out vec2 vtexCoord;  // La coordenada de textura

// --- UNIFORMS (from the viewer) ---
uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

void main()
{
    //P_object = texture ...
    //P_eye_4 = modelViewMatrix * vec4(P_object, 1.0);

    // Calcula la posición final
    gl_Position = projectionMatrix * P_eye_4;
}
```

### A-Fragment Shader

```glsl
#version 330 core

// --- INPUT (from the Vertex Shader) ---
in vec4 frontColor; // Recibe el color interpolado

// --- OUTPUT ---
out vec4 fragColor;

void main()
{
    // Simplemente asigna el color calculado en el VS
    fragColor = frontColor;
}
```

---

## Class B-Esqueleto (PER-FRAGMENT)

En esta categoría el trabajo duro se hace en el **Fragment Shader**. Hay dos variantes principales según lo que pida el examen: trabajar con imágenes (B1) o calcular física de la luz (B2).

### B1: Texturas (Mapeado de Imágenes)

**Úsalo cuando:** El examen pida "Texturizar el objeto", "Invaders", "Kong", "Mostrar una imagen".

* **Clave:** Pasar `texCoord` al FS y usar `texture()`.

#### B1-Vertex Shader

```glsl
#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 3) in vec2 texCoord; // Necesitamos esto sí o sí

out vec2 vtexCoord; // Lo pasamos al Fragment Shader

uniform mat4 modelViewProjectionMatrix;

void main()
{
    // Pasamos la coordenada tal cual
    vtexCoord = texCoord;

    // Posición estándar
    gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
}

```

#### B1-Fragment Shader

```glsl
#version 330 core

in vec2 vtexCoord;
out vec4 fragColor;

uniform sampler2D colorMap; // La textura cargada

void main()
{
    // Muestreamos el color de la textura en la coordenada (s,t)
    vec4 texColor = texture(colorMap, vtexCoord);

    // OPCIONAL: Descartar píxeles transparentes (Alpha Testing)
    // if(texColor.a < 0.5) discard;

    fragColor = texColor;
}

```

---

### B2: Iluminación (Modelo Phong / Alta Calidad)

**Úsalo cuando:** El examen pida "Phong Shading" (no Gouraud), "Especularidad", "Brillos", o "Iluminación por fragmento".

* **Clave:** Pasar la **Posición (P)** y la **Normal (N)** interpoladas al FS. El color se calcula abajo, no arriba.

#### B2-Vertex Shader

```glsl
#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;

out vec3 P; // Posición del vértice en View Space
out vec3 N; // Normal del vértice en View Space

uniform mat4 modelViewMatrix;
uniform mat3 normalMatrix; 
uniform mat4 modelViewProjectionMatrix;

void main()
{
    // 1. Calculamos P en View Space (necesario para vectores de luz)
    P = (modelViewMatrix * vec4(vertex, 1.0)).xyz;

    // 2. Calculamos N en View Space (normalizada)
    N = normalize(normalMatrix * normal);

    // 3. Posición en pantalla (Clip Space)
    gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
}

```

#### B2-Fragment Shader

```glsl
#version 330 core

in vec3 P; // Interpolado (Posición del píxel)
in vec3 N; // Interpolado (Normal del píxel)
out vec4 fragColor;

// Propiedades de la luz y el material
uniform vec4 lightPosition; // Suele venir en View Space
uniform vec4 matAmbient, matDiffuse, matSpecular;
uniform float matShininess;

void main()
{
    // 1. Renormalizamos N (la interpolación altera la longitud)
    vec3 N_norm = normalize(N);
    
    // 2. Calculamos vectores L (Luz), V (Vista/Cámara), R (Reflejo)
    vec3 L = normalize(lightPosition.xyz - P); 
    vec3 V = normalize(-P); // En View Space, la cámara está en (0,0,0), así que V es -P
    vec3 R = reflect(-L, N_norm);

    // 3. Componente Ambiental
    vec3 ambient = matAmbient.rgb;

    // 4. Componente Difusa (Lambert): N dot L
    vec3 diffuse = matDiffuse.rgb * max(0.0, dot(N_norm, L));

    // 5. Componente Especular (Phong): (R dot V)^shininess
    vec3 specular = matSpecular.rgb * pow(max(0.0, dot(R, V)), matShininess);

    // 6. Suma final
    fragColor = vec4(ambient + diffuse + specular, 1.0);
}

```


<hr style="border: 15px solid blue;">
<hr style="border: 15px solid red;">
<hr style="border: 15px solid blue;">


# 2. Receptes

## A-Per Vertex

### 1. Interpolar línealment 2 punts (boundingBoxMin.y i boundingBoxMax.y) segons un paràmetre d'interpolació t.

``` glsl
// Li direm c
float c = mix(boundingBoxMin.y, boundingBoxMax.y, t);
```

### 2. Escalar, translladar i rotar en l'eix de les Y

Anem a assumir que sen's demana:

* 0.0 a 0.25: Rotació (eix Y)
* 0.25 a 0.6: Translació (moure en Y)
* 0.6 a 1.0: Escalat ((de)créixer en Y)


``` glsl
uniform vec3 boundingBoxMin;
uniform vec3 boundingBoxMax;
uniform float angle = radians(45.0);
uniform float transY = 2.0;
uniform float scaleFactor = 1.5;

// --- 1. LA TEVA FUNCIÓ DE ROTACIÓ ---
mat3 rotateY(float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return mat3(
          c, 0.0,   s,
        0.0, 1.0, 0.0,
         -s, 0.0,   c
    );
}

void main() {
    // --- 2. NORMALITZAR L'ALÇADA (h de 0 a 1) ---
    float H = boundingBoxMax.y - boundingBoxMin.y;
    float h = (vertex.y - boundingBoxMin.y) / H;

    // Copiem el vèrtex per modificar-lo
    vec3 newPos = vertex; 

    // --- 3. LÒGICA PER FRANGES ---
    
    // TRAM A: 0.0 a 0.25 -> ROTATE
    if (h < 0.25) newPos = rotateY(angle) * newPos;
    
    // TRAM B: 0.25 a 0.6 -> TRANSLATE
    else if (h < 0.6) {        
        // Translació simple (sumar)
        newPos.y += transY;
        
        // Nota: Això trencarà la malla (farà un forat).
        // Si volguessis continuïtat estil Dalí, hauries de calcular la Delta.
        // 2. Calcular 'Δ' (Delta, la traslación)
        // El enunciado da la fórmula: c*scale = c + Δ
        // Aislamos Δ: Δ = c*scale - c
        // float delta = c * (scale - 1.0);
        // newPos.y += delta;
    }
    
    // TRAM C: 0.6 a 1.0 -> SCALE
    else {
        // Escalat simple:
        // newPos.y *= scaleFactor; 
        
        // Escalat correcte (sense moure el punt d'inici del tram):
        // Calculem la Y on comença aquest tram (el 60%)
        float yBase = boundingBoxMin.y + (0.6 * H);
        
        // "Ens posem a la base, escalem la diferència, i tornem a sumar la base"
        newPos.y = yBase + (newPos.y - yBase) * scaleFactor;
    }

    // --- 4. OUTPUT ---
    vec3 N = normalize(normalMatrix * normal);
    frontColor = vec4(1.0, 0.0, 0.0, 1.0) * N.z; // Color vermell simple

    gl_Position = modelViewProjectionMatrix * vec4(newPos, 1.0);
}
```

### 3. Pintar el vèrtex del gris que té per components la Z de la normal en Eye Space

``` glsl
// 1. Transformem la normal a Eye Space i normalitzem
vec3 N = normalize(normalMatrix * normal);

// 2. Agafem la component Z. 
// Com que la càmera mira cap a -Z, una N.z positiva vol dir que la cara mira cap a la càmera.
float gris = N.z; 
frontColor = vec4(N.z, N.z, N.z, 1.0);
```

### 4. Calculada la posició del vèrtex en Model Space, transformar a Clip Space (com es fa usualment)

``` glsl
gl_Position = modelViewProjectionMatrix * vec4(Pos, 1.0);
```

### 5. Donada una animació cíclica de 3.5 segons, els primers 0.5 segons, mourà els vèrtexs des de l'origen de coordenades fins a la seva posició original en model space.

Anem a assumir que el paràmetre d'interpolació linial sigui (t/0.5)^2, on t és el temps en segons des de l'inici del periode (per exemple, quan time = 4, t = 0.5).


``` glsl
uniform float time;

// 1. Calculem el temps local dins del cicle (de 0.0 a 3.5)
    float t = mod(time, 3.5);

    // Variable on guardarem la posició calculada
    vec3 newPos = vertex; // Valor per defecte

    // 2. FASE D'EXPANSIÓ (Els primers 0.5 segons)
    if (t < 0.5) {
        // Volem anar DES DE l'origen (vec3(0)) FINS A la posició original (vertex)
        newPos = mix(vec3(0.0), vertex, pow((t / 0.5), 2.0));
    }
    ...
```

### 6. Donada una animació cíclica de 3.5 segons, els primers 0.5 segons, hi ha una animació (irrellevant). I pels segons de 0.5 a 3.5, mourà els vèrtexs des de la seva posició inicial en Model Space cap a l'origin. Els vèrtexs s'han de moure en velocitat uniforme.

``` glsl
uniform float time;

// 1. Calculem el temps local dins del cicle (de 0.0 a 3.5)
    float t = mod(time, 3.5);

    // Variable on guardarem la posició calculada
    vec3 newPos = vertex; // Valor per defecte

    // 2. FASE D'EXPANSIÓ (Els primers 0.5 segons)
    if (t < 0.5) {
        ...
    }
    else {
        // --- FASE DE COMPRESSIÓ ---
        // Calculem el progrés natural de 0.0 a 1.0
        float progress = (t - 0.5) / 3.0;

        // "Ves des de 'vertex' cap a 'vec3(0.0)' usant el 'progress'"
        newPos = mix(vertex, vec3(0.0), progress);
    }
    ...
```


### 7. 

``` glsl

```


<hr style="border: 15px solid blue;">
<hr style="border: 15px solid red;">
<hr style="border: 15px solid blue;">

# 3. Exercises

## A-Per Vertex (Deformación de Geometría)

* **Objetivo:** Cambiar la **forma**, **posición** o **animación** del modelo 3D.
* **Palabras Clave:** "rotar", "deformar", "proyectar", "estirar", "girar cabeza", "animar".
* **Ejemplos:** `Look`, `Dolphin`, `Dalify`, `Cubify`.
* **Dónde trabajas:** Casi todo el código va en el **Vertex Shader (`.vert`)**.
* **Esqueleto a Usar:** **Esqueleto A (Per-Vertex)**.

---

### Ejemplo 1: Dalify

#### 1.1-Enunciado

```glsl
Escriu VS+FS per deformar el model en direcció vertical (eix Y en model space), per obtenir 
una aparença similar a la d'alguns animals en quadres de Salvador Dalí: 

El VS deformarà el model modificant únicament la coordenada Y en model space: 

Sigui c el resultat d'interpolar linealment boundingBoxMin.y i boundingBoxMax.y, 
segons un paràmetre d'interpolació t, uniform float t = 0.4. 

Si la coordenada Y és inferior a c, el VS li aplicarà l'escalat donat per uniform float 
scale = 4.0 per tal d'allargar les potes del model. Altrament, no li aplicarà cap escalat, 
però sí una translació Δ en Y. Per calcular Δ, observeu que per tenir continuïtat
a y=c, llavors c*scale = c + Δ (aïlleu Δ).

El FS farà les tasques habituals. 
```

#### 1.1b-Tasques Clau

**Tasca 1: Interpolar linealment boundingBoxMin.y i boundingBoxMax.y segons paràmetre t**

```glsl
uniform float t = 0.4;
uniform vec3 boundingBoxMin;
uniform vec3 boundingBoxMax;

// Calcular 'c' (el punt de tall en Y)
float c = mix(boundingBoxMin.y, boundingBoxMax.y, t);
// mix(a, b, t) = a*(1-t) + b*t
// Amb t=0.4: c = min.y*0.6 + max.y*0.4
```

**Tasca 2: Calcular Δ per mantenir continuïtat a y=c**

```glsl
uniform float scale = 4.0;

// De la fórmula: c*scale = c + Δ
// Aïllem Δ: Δ = c*scale - c = c*(scale - 1)
float delta = c * (scale - 1.0);
```

**Tasca 3: Aplicar escalat condicional (si y < c) o translació (si y >= c)**

```glsl
vec4 vertex_objectspace = vec4(vertex, 1.0);

if (vertex_objectspace.y < c)
{
    // Part de baix: ESCALAR (allargar les potes)
    vertex_objectspace.y = vertex_objectspace.y * scale;
}
else
{
    // Part de dalt: TRASLLADAR (mantenir continuïtat)
    vertex_objectspace.y = vertex_objectspace.y + delta;
}
```

**Tasca 4: Il·luminació bàsica amb N.z**

```glsl
uniform mat3 normalMatrix;

// Transformar normal a Eye Space
vec3 N = normalize(normalMatrix * normal);

// Color basat en la component Z (quant mira cap a la càmera)
frontColor = vec4(color, 1.0) * N.z;
```

#### 1.2-Vertex Shader

```glsl
#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;
out vec2 vtexCoord;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

uniform float t = 0.4;
uniform float scale = 4.0;
uniform vec3 boundingBoxMin;
uniform vec3 boundingBoxMax;

void main()
{
    vec4 vertex_objectspace = vec4(vertex, 1.0);
    vec3 normal_objectspace = normal;

    // 1. Calcular 'c' (el punt de tall en Y)
    float c = mix(boundingBoxMin.y, boundingBoxMax.y, t);

    // 2. Calcular 'Δ' (Delta, la translació)
    float delta = c * (scale - 1.0);

    // 3. Aplicar la deformació
    if (vertex_objectspace.y < c)
    {
        // Part de baix: ESCALAR
        vertex_objectspace.y = vertex_objectspace.y * scale;
    }
    else
    {
        // Part de dalt: TRASLLADAR
        vertex_objectspace.y = vertex_objectspace.y + delta;
    }

    vec3 N = normalize(normalMatrix * normal_objectspace);
    frontColor = vec4(color, 1.0) * N.z;
    vtexCoord = texCoord;
    gl_Position = modelViewProjectionMatrix * vertex_objectspace;
}
```

#### 1.3-Fragment Shader

```glsl
#version 330 core

in vec4 frontColor;
out vec4 fragColor;

void main()
{
    fragColor = frontColor;
}
```

---

### Ejemplo 2: Dolphin

#### 2.1-Enunciado

```glsl
Volem simular l'animació d'un dofí nadant. Per aconseguir-ho cal que el VS deformi el model.
L'animació durarà un segon i s'anirà repetint en el temps (caldrà fer servir una funció 
sinusoïdal amb un període apropiat). Dividirem el dofí en dues meitats i aplicarem una 
rotació a cada meitat en funció del temps.

Angles de la rotació: L'angle de rotació per la part davantera variarà en [-PI/32, PI/32], 
i per la part posterior en [-PI/4, 0]. Les rotacions seran en sentits oposats.

Offset entre parts: L'animació de la part davantera començarà 0.25 segons abans que la de 
la part posterior.

El color del dofí serà el gris clar (0.8, 0.8, 0.8), amb il·luminació bàsica.
```

#### 2.1b-Tasques Clau

**Tasca 1: Calcular punts relatius a la bounding box**

```glsl
uniform vec3 boundingBoxMin;
uniform vec3 boundingBoxMax;

// Funció helper per calcular punt a X% de l'alçada
float punt(float x) {
    return (boundingBoxMax.y - boundingBoxMin.y) * x + boundingBoxMin.y;
}

// Exemples:
float RT = punt(0.35);  // Punt de rotació cua (35% d'alçada)
float RD = punt(0.65);  // Punt de rotació cap (65% d'alçada)
float TT1 = punt(0.5);  // Inici transició cua
float TD2 = punt(0.75); // Fi transició cap
```

**Tasca 2: Dividir model en dues meitats i aplicar lògica diferent**

```glsl
vec3 pos = vertex;

if(vertex.y <= punt(0.5))
{
    // PART POSTERIOR (cua)
    // Lògica de rotació per la cua
}
else 
{
    // PART DAVANTERA (cap)
    // Lògica de rotació per el cap
}
```

**Tasca 3: Crear angle sinusoïdal amb rang específic**

```glsl
uniform float time;
float pi = acos(-1);  // Valor precís de PI

// Part posterior: angle entre [-PI/4, 0]
float alphaX_posterior = min(0.0, -pi/4.0 * sin(time));

// Part davantera: angle entre [-PI/32, PI/32] amb offset de 0.25s
float alphaX_davantera = pi/32.0 * sin(time + 0.25);
```

**Tasca 4: Aplicar els 5 passos de rotació respecte a un punt**

```glsl
float punto_rotacion = RT; // o RD segons la part
float angle = alphaX;

// 1. CENTRAR: Translació a l'origen
mat4 T0 = mat4(
    vec4(1.0, 0.0, 0.0, 0),
    vec4(0.0, 1.0, 0.0, -punto_rotacion),  // -Y
    vec4(0.0, 0.0, 1.0, 0),
    vec4(0.0, 0.0, 0.0, 1.0)
);

// 2-3. ROTAR (eix X)
mat4 rotX = mat4(
    vec4(1, 0, 0, 0), 
    vec4(0, cos(angle), sin(angle), 0), 
    vec4(0, -sin(angle), cos(angle), 0), 
    vec4(0, 0, 0, 1)
);

// 4. DESCENTRAR: Tornar a la posició original
mat4 T1 = mat4(
    vec4(1.0, 0.0, 0.0, 0),
    vec4(0.0, 1.0, 0.0, punto_rotacion),  // +Y
    vec4(0.0, 0.0, 1.0, 0),
    vec4(0.0, 0.0, 0.0, 1.0)
);

// Aplicar transformació
vec3 nv = (T1 * rotX * T0 * vec4(vertex, 1.0)).xyz;
```

**Tasca 5: Aplicar transició suau amb smoothstep**

```glsl
float T1 = punt(0.5);   // Inici zona de transició
float T2 = punt(0.05);  // Fi zona de transició

// Factor va de 0 (transició màxima) a 1 (sense transició)
float factor = smoothstep(T2, T1, vertex.y);

// Barrejar posició transformada amb l'original
pos = mix(nv, vertex, factor);
// factor=0 -> usa nv (totalment transformat)
// factor=1 -> usa vertex (sense transformar)
```

#### 2.2-Vertex Shader

```glsl
#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;
out vec2 vtexCoord;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform float time;
uniform vec3 boundingBoxMin;
uniform vec3 boundingBoxMax;

float punt(float x){
    return (boundingBoxMax.y - boundingBoxMin.y) * x + boundingBoxMin.y;
}

void main()
{
    float pi = acos(-1);
    float RT = punt(0.35), RD = punt(0.65);
    vec3 pos = vertex;

    if(vertex.y <= punt(0.5))
    {
        float TT2 = punt(0.05), TT1 = punt(0.5);
        float factor = smoothstep(TT2, TT1, vertex.y);
        float alphaX = min(0.0, -pi/4.0 * sin(time));

        mat4 T0 = mat4(vec4(1.0, 0.0, 0.0, 0),
                vec4(0.0, 1.0, 0.0, -RT),
                vec4(0.0, 0.0, 1.0, 0),
                vec4(0.0, 0.0, 0.0, 1.0));
        mat4 T1 = mat4(vec4(1.0, 0.0, 0.0, 0),
                vec4(0.0, 1.0, 0.0, RT),
                vec4(0.0, 0.0, 1.0, 0),
                vec4(0.0, 0.0, 0.0, 1.0));        
        mat4 rotX = mat4(vec4(1, 0, 0, 0), vec4(0, cos(alphaX), sin(alphaX), 0), 
                         vec4(0, -sin(alphaX), cos(alphaX), 0), vec4(0, 0, 0, 1));
        vec3 nv = (T1 * rotX * T0 * vec4(vertex, 1.)).xyz;
        pos = mix(nv, vertex, factor);
    }
    else 
    {
        float TD1 = punt(0.55), TD2 = punt(0.75);
        float factor = smoothstep(TD1, TD2, vertex.y);
        float alphaX = pi/32.0 * sin(time + 0.25);
        
        mat4 T0 = mat4(vec4(1.0, 0.0, 0.0, 0),
                vec4(0.0, 1.0, 0.0, -RD),
                vec4(0.0, 0.0, 1.0, 0),
                vec4(0.0, 0.0, 0.0, 1.0));
        mat4 T1 = mat4(vec4(1.0, 0.0, 0.0, 0),
                vec4(0.0, 1.0, 0.0, RD),
                vec4(0.0, 0.0, 1.0, 0),
                vec4(0.0, 0.0, 0.0, 1.0));        
        mat4 rotX = mat4(vec4(1, 0, 0, 0), vec4(0, cos(alphaX), sin(alphaX), 0), 
                         vec4(0, -sin(alphaX), cos(alphaX), 0), vec4(0, 0, 0, 1));
        vec3 nv = (T1 * rotX * T0 * vec4(vertex, 1.)).xyz;
        pos = mix(nv, vertex, factor);
    }

    vec3 N = normalize(normalMatrix * normal);
    vtexCoord = texCoord;
    frontColor = vec4(color, 1.0) * N.z;
    gl_Position = modelViewProjectionMatrix * vec4(pos, 1.0);
}
```

#### 2.3-Fragment Shader

```glsl
#version 330 core

in vec4 frontColor;
out vec4 fragColor;

void main()
{
    fragColor = frontColor;
}
```

---

### Ejemplo 3: Spring

#### 3.1-Enunciado

```glsl
Escriviu VS+FS que simulin l'expansió i compressió cícliques del model 3D com si fos 
una molla. L'animació es repetirà cada 3.5 segons.

Fase 1 (expansió): 0.5 segons. Mou els vèrtexs des de l'origen fins a la seva posició 
original. Paràmetre d'interpolació: (t/0.5)³.

Fase 2 (compressió): 3 segons. Mou els vèrtexs des de la posició original cap a l'origine, 
a velocitat uniforme.

El color del vèrtex serà el gris que té per components la Z de la normal en eye space.
```

#### 3.1b-Tasques Clau

**Tasca 1: Crear animació cíclica amb mod**

```glsl
uniform float time;

// Obtenir temps dins del cicle [0.0, 3.5)
float t_period = mod(time, 3.5);
// Exemple: si time = 7.2, t_period = 0.2
// Exemple: si time = 10.5, t_period = 0.0
```

**Tasca 2: Fase d'expansió amb interpolació cúbica (t/0.5)³**

```glsl
vec3 origen = vec3(0.0, 0.0, 0.0);
vec3 vertex_objectspace;

if (t_period < 0.5)
{
    // FASE 1: EXPANSIÓ (0.0s a 0.5s)
    // Normalitzar t_period a rang [0, 1]
    float t_exp = t_period / 0.5;  // [0.0, 0.5] -> [0.0, 1.0]
    
    // Aplicar funció cúbica
    float interp_factor = pow(t_exp, 3.0);
    
    // Interpolació: origen (0%) -> vertex (100%)
    vertex_objectspace = mix(origen, vertex, interp_factor);
}
```

**Tasca 3: Fase de compressió amb velocitat uniforme (lineal)**

```glsl
else  // t_period >= 0.5
{
    // FASE 2: COMPRESSIÓ (0.5s a 3.5s)
    // Rang temporal: [0.5, 3.5] = 3.0 segons
    float t_comp = (t_period - 0.5) / 3.0;  // [0.5, 3.5] -> [0.0, 1.0]
    
    // Interpolació lineal: vertex (0%) -> origen (100%)
    vertex_objectspace = mix(vertex, origen, t_comp);
    
    // També necessitem l'invers per la normal
    float interp_factor = 1.0 - t_comp;
}
```

**Tasca 4: Deformar la normal quan deformem el vèrtex**

```glsl
vec3 normal_objectspace = normal;

// Quan escalem un vèrtex per 'factor', la normal s'ha de dividir
// Afegim 0.0001 per evitar divisió per zero
normal_objectspace = normal / (interp_factor + 0.0001);

// Exemple: si interp_factor = 0.5 (vèrtex a meitat de camí)
// -> normal es divideix per 0.5 = es multiplica per 2
```

**Tasca 5: Color gris segons Z de la normal en eye space**

```glsl
uniform mat3 normalMatrix;

// Transformar i normalitzar la normal deformada
vec3 N = normalize(normalMatrix * normal_objectspace);

// Usar component Z com a intensitat de gris
// N.z rang: [-1, 1] però només valors positius il·luminen
frontColor = vec4(N.z, N.z, N.z, 1.0);
// RGB tots iguals = gris
// Valor més alt de N.z = gris més clar (cara mira cap a càmera)
```

#### 3.2-Vertex Shader

```glsl
#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;
out vec2 vtexCoord;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform float time;

void main()
{
    float interp_factor = 0.0;
    vec3 vertex_objectspace = vertex;
    vec3 normal_objectspace = normal;
    vec3 origen = vec3(0.0, 0.0, 0.0);

    // Trobar el temps dins del cicle de 3.5s
    float t_period = mod(time, 3.5);

    if (t_period < 0.5)
    {
        // FASE 1: EXPANSIÓ
        float t_exp = t_period / 0.5;
        interp_factor = pow(t_exp, 3.0);
        vertex_objectspace = mix(origen, vertex, interp_factor);
    }
    else
    {
        // FASE 2: COMPRESSIÓ
        float t_comp = (t_period - 0.5) / 3.0;
        vertex_objectspace = mix(vertex, origen, t_comp);
        interp_factor = 1.0 - t_comp;
    }

    // Deformar la normal
    normal_objectspace = normal / (interp_factor + 0.0001);

    vec3 N = normalize(normalMatrix * normal_objectspace);
    frontColor = vec4(N.z, N.z, N.z, 1.0);
    vtexCoord = texCoord;
    gl_Position = modelViewProjectionMatrix * vec4(vertex_objectspace, 1.0);
}
```

#### 3.3-Fragment Shader

```glsl
#version 330 core

in vec4 frontColor;
out vec4 fragColor;

void main()
{
    fragColor = frontColor;
}
```

---

## B-Per Fragment (Texturas)

* **Objetivo:** Decidir el color de un **píxel** basándose en texturas, coordenadas, o lógica.
* **Palabras Clave:** `texture()`, `sampler2D`, `colorMap`, `vtexCoord`, `if`, `discard`, `procedural`.
* **Ejemplos:** `Digits`, `Smile`, `Flag`, `Beach`, `Hunter`.
* **Dónde trabajas:** Todo el código va en el **Fragment Shader (`.frag`)**.
* **Esqueleto a Usar:** **Esqueleto B (Per-Fragment)**.

---

### Ejemplo 1: Hunter

#### 1.1-Enunciado

```glsl
Volem simular uns binocles que ens acosten els detalls d'una textura que ocupa tot el viewport.

Aquest exercici sols funciona amb l'objecte plane.obj, texturat amb l'escena triada.

Useu la funció blur.glsl per mostrar la textura desenfocada. Afegiu binocles: dos cercles 
de radi 100 píxels amb vorera negra de 5 píxels. El uniform float magnific indica el factor 
d'augment dels binocles.
```

#### 1.1b-Tasques Clau

**Tasca 1: Usar la identitat com a ModelViewProjectionMatrix**

```glsl
// Al Vertex Shader:
void main()
{
    vtexCoord = texCoord;
    
    // NO usar modelViewProjectionMatrix
    // Usar directament el vèrtex com a posició de clip space
    gl_Position = vec4(vertex, 1.0);
    
    // Això fa que el pla ocupi tot el viewport sense transformacions
}
```

**Tasca 2: Convertir coordenades de textura [0,1] a píxels**

```glsl
// Al Fragment Shader:
uniform vec2 viewport;  // Ex: (1920.0, 1080.0)
in vec2 vtexCoord;      // Ex: (0.5, 0.5) = centre

// Convertir a píxels
vec2 pixelCoord = vtexCoord * viewport;
// Exemple: (0.5, 0.5) * (1920, 1080) = (960, 540) píxels
```

**Tasca 3: Calcular centres dels binocles desplaçats 80px del ratolí**

```glsl
uniform vec2 mousePosition;  // En píxels, ex: (500.0, 400.0)

// Cercle esquerre: 80px a l'esquerra
vec2 centerL = mousePosition + vec2(-80.0, 0.0);

// Cercle dret: 80px a la dreta
vec2 centerR = mousePosition + vec2(80.0, 0.0);
```

**Tasca 4: Detectar si píxel està dins de cercles o vorera**

```glsl
// Distància del píxel actual a cada centre
float distL = distance(pixelCoord, centerL);
float distR = distance(pixelCoord, centerR);

// Vorera negra: entre radi 100 i 105
if ((distL > 100.0 && distL < 105.0) || (distR > 100.0 && distR < 105.0))
{
    finalColor = vec4(0.0, 0.0, 0.0, 1.0);  // Negre
}
// Dins del cercle: menys de radi 100
else if (distL < 100.0 || distR < 100.0)
{
    // Aplicar magnificació (veure següent tasca)
}
```

**Tasca 5: Aplicar magnificació (zoom) dins dels binocles**

```glsl
uniform float magnific = 3.0;

// Convertir posició ratolí a coordenades de textura [0,1]
vec2 M_tex = mousePosition / viewport;

// Calcular punt P que està més a prop del ratolí
// Fórmula: P = M + (F - M) / magnific
// On F és el fragment actual i M és el ratolí
vec2 P_tex = M_tex + (vtexCoord - M_tex) / magnific;

// Mostrejar textura nítida (no blurred) en punt P
finalColor = texture(jungla, P_tex);
```

**Tasca 6: Integrar funció blur externa (blur.glsl)**

```glsl
// Declarar uniforms que la funció necessita
uniform sampler2D jungla;
uniform vec2 viewport;

// Copiar funció blurImage del fitxer blur.glsl
vec4 blurImage(in vec2 coords) { /* ... codi ... */ }

// Usar-la per color per defecte
void main()
{
    vec4 finalColor = blurImage(vtexCoord);
    // Després aplicar lògica dels binocles...
}
```

#### 1.2-Vertex Shader

```glsl
#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec2 vtexCoord;

void main()
{
    vtexCoord = texCoord;
    gl_Position = vec4(vertex, 1.0);
}
```

#### 1.3-Fragment Shader

```glsl
#version 330 core

in vec2 vtexCoord;
out vec4 fragColor;

uniform vec2 mousePosition;
uniform vec2 viewport;
uniform sampler2D jungla;
uniform float magnific = 3.0;

// Funció blur.glsl
vec4 blurImage(in vec2 coords)
{
    float Pi = 6.28318530718;
    float Directions = 16.0;
    float Quality = 8.0;
    float Size = 10.0;
    
    vec2 Radius = Size/viewport;
    vec4 Color = texture(jungla, coords);
    
    for(float d=0.0; d<Pi; d+=Pi/Directions)
    {
        float cd = cos(d);
        float sd = sin(d);
        for(float i=1.0/Quality; i<=1.0; i+=1.0/Quality)
        {
            Color += texture(jungla, coords+vec2(cd,sd)*Radius*i);      
        }
    }
    
    Color /= Quality * Directions - 15.0;
    return Color;
}

void main()
{
    vec4 finalColor = blurImage(vtexCoord);
    vec2 pixelCoord = vtexCoord * viewport;

    vec2 centerL = mousePosition + vec2(-80.0, 0.0);
    vec2 centerR = mousePosition + vec2(80.0, 0.0);

    float distL = distance(pixelCoord, centerL);
    float distR = distance(pixelCoord, centerR);

    // Vorera negra
    if ((distL > 100.0 && distL < 105.0) || (distR > 100.0 && distR < 105.0))
    {
        finalColor = vec4(0.0, 0.0, 0.0, 1.0);
    }
    // Lent (magnificació)
    else if (distL < 100.0 || distR < 100.0)
    {
        vec2 M_tex = mousePosition / viewport;
        vec2 P_tex = M_tex + (vtexCoord - M_tex) / magnific;
        finalColor = texture(jungla, P_tex);
    }
    
    fragColor = finalColor;
}
```

---

### Ejemplo 2: Invaders

#### 2.1-Enunciado

```glsl
Escriviu VS+FS per tal de dibuixar quelcom similar a una pantalla del Space Invaders.

El FS triará el color del fragment segons les coordenades de textura dins [0,1].

Requisits:
- Canó blanc a la part inferior (4 punts)
- Escuts en una fila per sobre del canó (3 punts)
- 6 fileres amb extraterrestres invasors (3 punts)
```

#### 2.1b-Tasques Clau

**Tasca 1: Dividir pantalla en files segons coordenada T (vertical)**

```glsl
in vec2 vtexCoord;  // (s, t) on t=0 és baix, t=1 és dalt

// Dividir en franges verticals
if (vtexCoord.t > 0.8) {
    // Fila 6 (més alta)
} else if (vtexCoord.t > 0.7) {
    // Fila 5
} else if (vtexCoord.t > 0.6) {
    // Fila 4
}
// ... etc
```

**Tasca 2: Mostrejar d'un atlas de textures 4x4**

```glsl
uniform sampler2D colormap;  // Textura amb grid 4x4

// Cada casella ocupa 0.25 x 0.25
vec2 tileSize = vec2(0.25, 0.25);

// Seleccionar casella (col, row)
// Col 0 = esquerra, Col 3 = dreta
// Row 0 = baix, Row 3 = dalt
vec2 tile = vec2(1.0, 2.0);  // Columna 1, Fila 2

// Coordenada local dins la casella [0, 1]
vec2 localCoord = vec2(0.5, 0.5);  // Centre de l'sprite

// Coordenada final a la textura
vec2 sampleCoord = (tile + localCoord) * tileSize;
vec4 texColor = texture(colormap, sampleCoord);
```

**Tasca 3: Repetir sprite múltiples vegades amb fract**

```glsl
// Per dibuixar 12 aliens en una fila:
float numAliens = 12.0;

// Coordenada S repetida 12 vegades
localCoord.s = fract(vtexCoord.s * numAliens);
// vtexCoord.s = 0.0 -> 1.0
// fract crea 12 bucles de 0.0 -> 1.0

// Coordenada T (mapejada a l'alçada de la fila)
float rowStart = 0.8;  // Inici de la fila
float rowHeight = 0.1; // Alçada de la fila
localCoord.t = (vtexCoord.t - rowStart) / rowHeight;
```

**Tasca 4: Centrar sprite dins de la seva zona**

```glsl
// Problema: sprite ocupa 10% però zona és 25% (1/4)
float spriteWidth = 0.1;
float zoneWidth = 1.0 / 4.0;  // = 0.25

// Ràtio de farciment
float fill_ratio = spriteWidth / zoneWidth;  // = 0.4

// Padding a cada costat
float padding_ratio = (1.0 - fill_ratio) / 2.0;  // = 0.3

// Comprovar si estem dins la finestra centrada [0.3, 0.7]
if (localCoord.s > padding_ratio && localCoord.s < (1.0 - padding_ratio))
{
    // Re-mapejar [0.3, 0.7] -> [0.0, 1.0]
    float shifted_s = localCoord.s - padding_ratio;
    localCoord.s = shifted_s / fill_ratio;
} 
else 
{
    // Estem al padding, no dibuixar
    draw = false;
}
```

**Tasca 5: Centrar UN sprite únic (canó)**

```glsl
// Volem el canó centrat horitzontalment (ocupa 10% del total)
if (vtexCoord.s > 0.45 && vtexCoord.s < 0.55) 
{
    // Dins la zona del canó [0.45, 0.55] = 10% de l'ample
    
    // Re-mapejar [0.45, 0.55] -> [0.0, 1.0]
    localCoord.s = (vtexCoord.s - 0.45) / 0.10;
    localCoord.t = (vtexCoord.t - 0.1) / 0.10;
} 
else 
{
    draw = false;  // Fora de la zona del canó
}
```

**Tasca 6: Filtrar fons negre de l'atlas**

```glsl
vec4 texColor = texture(colormap, sampleCoord);

// Calcular brillantor (suma RGB)
float brightness = texColor.r + texColor.g + texColor.b;

if (brightness > 0.1) {
    // NO és fons negre, usar el color del sprite
    finalColor = texColor;
}
// Si és negre (brightness < 0.1), mantenir fons negre
```

#### 2.2-Vertex Shader

```glsl
#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec2 vtexCoord;

uniform mat4 modelViewProjectionMatrix;

void main()
{
    vtexCoord = texCoord;
    gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
}
```

#### 2.3-Fragment Shader

```glsl
#version 330 core

in vec2 vtexCoord;
out vec4 fragColor;

uniform sampler2D colormap;

void main()
{
    vec4 finalColor = vec4(0.0, 0.0, 0.0, 1.0);
    vec2 tileSize = vec2(0.25, 0.25);
    vec2 tile = vec2(0.0);
    vec2 localCoord = vec2(0.0);
    bool draw = true; 

    if (vtexCoord.t > 0.8) {
        tile = vec2(0.0, 3.0); 
        localCoord.s = fract(vtexCoord.s * 12.0);
        localCoord.t = (vtexCoord.t - 0.8) / 0.1;
    } else if (vtexCoord.t > 0.7) {
        tile = vec2(1.0, 3.0);
        localCoord.s = fract(vtexCoord.s * 12.0);
        localCoord.t = (vtexCoord.t - 0.7) / 0.1;
    } else if (vtexCoord.t > 0.6) {
        tile = vec2(0.0, 2.0); 
        localCoord.s = fract(vtexCoord.s * 12.0);
        localCoord.t = (vtexCoord.t - 0.6) / 0.1;
    } else if (vtexCoord.t > 0.5) {
        tile = vec2(1.0, 2.0);
        localCoord.s = fract(vtexCoord.s * 12.0);
        localCoord.t = (vtexCoord.t - 0.5) / 0.1;
    } else if (vtexCoord.t > 0.4) {
        tile = vec2(0.0, 1.0);
        localCoord.s = fract(vtexCoord.s * 12.0);
        localCoord.t = (vtexCoord.t - 0.4) / 0.1;
    } else if (vtexCoord.t > 0.3) {
        tile = vec2(0.0, 0.0);
        localCoord.s = fract(vtexCoord.s * 12.0);
        localCoord.t = (vtexCoord.t - 0.3) / 0.1;
    } else if (vtexCoord.t > 0.2) {
        // ESCUTS
        tile = vec2(3.0, 0.0);
        float rowHeight = 0.1;
        float spriteWidth = 0.1;
        float numShields = 4.0;
        float zoneWidth = 1.0 / numShields; 

        localCoord.t = (vtexCoord.t - 0.2) / rowHeight;
        localCoord.s = fract(vtexCoord.s * numShields);

        float fill_ratio = spriteWidth / zoneWidth;
        float padding_ratio = (1.0 - fill_ratio) / 2.0;

        if (localCoord.s > padding_ratio && localCoord.s < (1.0 - padding_ratio)) 
        {
            float shifted_s = localCoord.s - padding_ratio;
            localCoord.s = shifted_s / fill_ratio;
        } else {
            draw = false;
        }
    } else if (vtexCoord.t > 0.1) {
        // CANÓ
        tile = vec2(3.0, 1.0);
        if (vtexCoord.s > 0.45 && vtexCoord.s < 0.55) {
            localCoord.s = (vtexCoord.s - 0.45) / 0.10; 
            localCoord.t = (vtexCoord.t - 0.1) / 0.10;
        } else {
            draw = false; 
        }
    } else {
        draw = false;
    }

    if (draw) {
        vec2 sampleCoord = (tile + localCoord) * tileSize;
        vec4 texColor = texture(colormap, sampleCoord);
        float brightness = texColor.r + texColor.g + texColor.b;
        
        if (brightness > 0.1) {
            finalColor = texColor;
        }
    }

    fragColor = finalColor;
}
```

---

### Ejemplo 3: Flag

#### 3.1-Enunciado

```glsl
Escriu VS+FS que, amb l'objecte plane.obj, dibuixi de forma procedural una bandera.

El VS escalarà la coordenada Y per tal que la relació d'aspecte sigui 2:1.

El FS calcularà el color de forma procedural.
```

#### 3.2-Vertex Shader

```glsl
#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec2 vtexCoord;

uniform mat4 modelViewProjectionMatrix;

void main()
{
    vtexCoord = texCoord;
    vec4 new_vertex = vec4(vertex, 1.0);
    new_vertex.y = new_vertex.y * 0.5;
    gl_Position = modelViewProjectionMatrix * new_vertex;
}
```

#### 3.3-Fragment Shader

```glsl
#version 330 core

in vec2 vtexCoord;
out vec4 fragColor;

void main()
{
    // Implementació de la bandera procedural
    vec4 finalColor = vec4(1.0);
    
    // Aquí s'implementaria la lògica de la bandera
    // (exemple simplificat)
    
    fragColor = finalColor;
}
```

---

## C-Per Fragment (Iluminación Phong)

* **Objetivo:** Calcular el modelo de luz de Phong (Ambiental, Difuso, Especular) per píxel.
* **Palabras Clave:** `Phong`, `Iluminación`, `N`, `L`, `V`, `R`, `matDiffuse`, `lightSpecular`.
* **Ejemplos:** `Nlights`, `LightChange`, `8lights`.
* **Dónde trabajas:** El cálculo principal va en el **Fragment Shader (`.frag`)**.
* **Esqueleto a Usar:** **Esqueleto B (Per-Fragment)**.

---

### Ejemplo 1: 8lights

#### 1.1-Enunciado

```glsl
Escriu VS+FS per aplicar il·luminació de Phong per fragment, amb 8 llums fixos respecte 
l'escena. Les posicions dels llums en world space coincidiran amb els 8 vèrtexs de la 
capsa contenidora (boundingBoxMin i boundingBoxMax).

Per cada llum usar: ∑ Kd Id (N·Li)/2 + Ks Is (Ri·V)^s
```

#### 1.1b-Tasques Clau

**Tasca 1: Passar posició i normal a Eye Space al Fragment Shader**

```glsl
// Al Vertex Shader:
out vec3 v_position_eye;
out vec3 v_normal_eye;

uniform mat4 modelViewMatrix;
uniform mat3 normalMatrix;

void main()
{
    // Posició en Eye Space (necessària per calcular L i V)
    vec4 pos_eye_4 = modelViewMatrix * vec4(vertex, 1.0);
    v_position_eye = vec3(pos_eye_4);
    
    // Normal en Eye Space (NO normalitzar aquí, ho farem al FS)
    v_normal_eye = normalize(normalMatrix * normal);
    
    gl_Position = projectionMatrix * pos_eye_4;
}
```

**Tasca 2: Calcular els 8 vèrtexs de la bounding box**

```glsl
// Al Fragment Shader:
uniform vec3 boundingBoxMin;  // Ex: (-1, -1, -1)
uniform vec3 boundingBoxMax;  // Ex: (1, 1, 1)

// Els 8 vèrtexs són totes les combinacions de min/max en X,Y,Z
vec3 lightPos_world[8];
lightPos_world[0] = vec3(boundingBoxMin.x, boundingBoxMin.y, boundingBoxMin.z);
lightPos_world[1] = vec3(boundingBoxMax.x, boundingBoxMin.y, boundingBoxMin.z);
lightPos_world[2] = vec3(boundingBoxMin.x, boundingBoxMax.y, boundingBoxMin.z);
lightPos_world[3] = vec3(boundingBoxMax.x, boundingBoxMax.y, boundingBoxMin.z);
lightPos_world[4] = vec3(boundingBoxMin.x, boundingBoxMin.y, boundingBoxMax.z);
lightPos_world[5] = vec3(boundingBoxMax.x, boundingBoxMin.y, boundingBoxMax.z);
lightPos_world[6] = vec3(boundingBoxMin.x, boundingBoxMax.y, boundingBoxMax.z);
lightPos_world[7] = vec3(boundingBoxMax.x, boundingBoxMax.y, boundingBoxMax.z);
```

**Tasca 3: Transformar llum de World Space a Eye Space**

```glsl
uniform mat4 viewMatrix;

// Per cada llum:
vec3 lightPos_eye = vec3(viewMatrix * vec4(lightPos_world[i], 1.0));
// Multipliquem per viewMatrix (NO per modelViewMatrix)
// perquè el llum està en World Space, no en Object Space
```

**Tasca 4: Calcular vectors N, L, V, R per Phong**

```glsl
in vec3 v_normal_eye;
in vec3 v_position_eye;

// N: Normal (re-normalitzar després de la interpolació)
vec3 N = normalize(v_normal_eye);

// V: Vector cap a la càmera (en Eye Space, càmera està a l'origen)
vec3 V = normalize(-v_position_eye);

// Per cada llum:
// L: Vector cap al llum
vec3 L = normalize(lightPos_eye - v_position_eye);

// R: Vector de reflexió de la llum respecte a N
vec3 R = reflect(-L, N);
// reflect(-L, N) calcula: 2*(N·L)*N - L
```

**Tasca 5: Calcular component difós i especular amb fórmula específica**

```glsl
uniform vec4 matDiffuse;
uniform vec4 matSpecular;
uniform vec4 lightDiffuse;
uniform vec4 lightSpecular;
uniform float matShininess;

// Difús: (Kd * Id * (N·L)) / 2
float NdotL = max(0.0, dot(N, L));
vec4 dif = (matDiffuse * lightDiffuse * NdotL) / 2.0;
// Dividim per 2 per evitar saturació

// Especular: Ks * Is * (R·V)^shininess
vec4 spec = vec4(0.0);
if (NdotL > 0.0)  // Només si el llum il·lumina aquesta cara
{
    float RdotV = max(0.0, dot(R, V));
    spec = matSpecular * lightSpecular * pow(RdotV, matShininess);
}
```

**Tasca 6: Acumular contribucions de múltiples llums**

```glsl
vec4 finalColor = vec4(0.0, 0.0, 0.0, 1.0);

for (int i = 0; i < 8; i++)
{
    // Calcular dif i spec per aquest llum
    // ...
    
    // Acumular
    finalColor += dif + spec;
}

finalColor.a = 1.0;  // Assegurar alpha = 1
fragColor = finalColor;
```

#### 1.2-Vertex Shader

```glsl
#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec2 vtexCoord;
out vec3 v_normal_eye;
out vec3 v_position_eye;

uniform mat3 normalMatrix;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

void main()
{
    vtexCoord = texCoord;
    vec4 pos_eye_4 = modelViewMatrix * vec4(vertex, 1.0);
    v_position_eye = vec3(pos_eye_4);
    v_normal_eye = normalize(normalMatrix * normal);
    gl_Position = projectionMatrix * pos_eye_4;
}
```

#### 1.3-Fragment Shader

```glsl
#version 330 core

in vec2 vtexCoord;
in vec3 v_normal_eye;
in vec3 v_position_eye;

out vec4 fragColor;

uniform vec4 lightDiffuse;
uniform vec4 lightSpecular;
uniform vec4 matDiffuse;
uniform vec4 matSpecular;
uniform float matShininess;
uniform vec3 boundingBoxMin;
uniform vec3 boundingBoxMax;
uniform mat4 viewMatrix;

void main()
{
    vec4 finalColor = vec4(0.0, 0.0, 0.0, 1.0);

    // Definir les 8 posicions dels llums en World Space
    vec3 lightPos_world[8];
    lightPos_world[0] = vec3(boundingBoxMin.x, boundingBoxMin.y, boundingBoxMin.z);
    lightPos_world[1] = vec3(boundingBoxMax.x, boundingBoxMin.y, boundingBoxMin.z);
    lightPos_world[2] = vec3(boundingBoxMin.x, boundingBoxMax.y, boundingBoxMin.z);
    lightPos_world[3] = vec3(boundingBoxMax.x, boundingBoxMax.y, boundingBoxMin.z);
    lightPos_world[4] = vec3(boundingBoxMin.x, boundingBoxMin.y, boundingBoxMax.z);
    lightPos_world[5] = vec3(boundingBoxMax.x, boundingBoxMin.y, boundingBoxMax.z);
    lightPos_world[6] = vec3(boundingBoxMin.x, boundingBoxMax.y, boundingBoxMax.z);
    lightPos_world[7] = vec3(boundingBoxMax.x, boundingBoxMax.y, boundingBoxMax.z);

    vec3 N = normalize(v_normal_eye);
    vec3 V = normalize(-v_position_eye);

    for (int i = 0; i < 8; i++)
    {
        vec3 lightPos_eye = vec3(viewMatrix * vec4(lightPos_world[i], 1.0));
        vec3 L = normalize(lightPos_eye - v_position_eye);
        vec3 R = reflect(-L, N);

        float NdotL = max(0.0, dot(N, L));
        vec4 dif = (matDiffuse * lightDiffuse * NdotL) / 2.0;

        vec4 spec = vec4(0.0);
        if (NdotL > 0.0)
        {
            float RdotV = pow(max(0.0, dot(R, V)), matShininess);
            spec = matSpecular * lightSpecular * RdotV;
        }

        finalColor += dif + spec;
    }
    
    finalColor.a = 1.0;
    fragColor = finalColor;
}
```

---

### Ejemplo 2: Nlights

#### 2.1-Enunciado

```glsl
Escriviu VS+FS per aplicar il·luminació de Phong per fragment, amb n llums fixos respecte 
la càmera, on n és un uniform int n=4.

Els llums estaran situats al voltant d'un cercle de radi 10 al pla Z=0, centrat a la càmera. 
El primer llum estarà a (10, 0, 0) en eye space.

Per evitar saturació usar: ∑ Kd Id (N·Li)/√n + Ks Is (Ri·V)^s
```

#### 2.1b-Tasques Clau

**Tasca 1: Posicionar n llums en cercle en Eye Space**

```glsl
uniform int n = 4;
const float pi = 3.141592;

// Cercle de radi 10, pla Z=0 (davant la càmera)
float radius = 10.0;

for (int i = 0; i < n; i++)
{
    // Angle per aquest llum (equidistribució)
    float angle = 2.0 * pi * float(i) / float(n);
    // i=0: angle=0, i=1: angle=2pi/n, etc.
    
    // Posició del llum en Eye Space
    vec3 lightPos_eye = vec3(
        radius * cos(angle),  // X
        radius * sin(angle),  // Y
        0.0                   // Z (pla frontal)
    );
    
    // Exemples amb n=4:
    // i=0: (10, 0, 0)    - Dreta
    // i=1: (0, 10, 0)    - Dalt
    // i=2: (-10, 0, 0)   - Esquerra
    // i=3: (0, -10, 0)   - Baix
}
```

**Tasca 2: Dividir component difós per arrel quadrada de n**

```glsl
// Calcular divisor UNA VEGADA (fora del bucle)
float sqrt_n = sqrt(float(n));
// Exemple: n=4 -> sqrt_n=2.0
// Exemple: n=9 -> sqrt_n=3.0

for (int i = 0; i < n; i++)
{
    // Component difós dividit per sqrt(n)
    float NdotL = max(0.0, dot(N, L));
    vec4 dif = (matDiffuse * lightDiffuse * NdotL) / sqrt_n;
    
    // Component especular NO es divideix
    // ...
}
```

**Tasca 3: Conversions entre graus i radians**

```glsl
// Constant PI
const float pi = 3.141592;
// O calcular-la: float pi = acos(-1.0);

// Graus a radians
float angleRadians = angleGraus * (pi / 180.0);
// Ex: 90º -> 90 * (pi/180) = pi/2

// Radians a graus
float angleGraus = angleRadians * (180.0 / pi);
// Ex: pi -> pi * (180/pi) = 180º
```

#### 2.2-Vertex Shader

```glsl
#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec2 vtexCoord;
out vec3 v_normal_eye;
out vec3 v_position_eye;

uniform mat3 normalMatrix;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

void main()
{
    vtexCoord = texCoord;
    vec4 pos_eye_4 = modelViewMatrix * vec4(vertex, 1.0);
    v_position_eye = vec3(pos_eye_4);
    v_normal_eye = normalMatrix * normal;
    gl_Position = projectionMatrix * pos_eye_4;
}
```

#### 2.3-Fragment Shader

```glsl
#version 330 core

in vec2 vtexCoord;
in vec3 v_normal_eye;
in vec3 v_position_eye;

out vec4 fragColor;

uniform int n = 4;
const float pi = 3.141592;

uniform vec4 lightDiffuse;
uniform vec4 lightSpecular;
uniform vec4 matDiffuse;
uniform vec4 matSpecular;
uniform float matShininess;

void main()
{
    vec4 finalColor = vec4(0.0, 0.0, 0.0, 1.0);
    vec3 N = normalize(v_normal_eye);
    vec3 V = normalize(-v_position_eye);
    float sqrt_n = sqrt(float(n));

    for (int i = 0; i < n; i++)
    {
        float angle = 2.0 * pi * float(i) / float(n);
        vec3 lightPos_eye = vec3(10.0 * cos(angle), 10.0 * sin(angle), 0.0);

        vec3 L = normalize(lightPos_eye - v_position_eye);
        vec3 R = reflect(-L, N);

        float NdotL = max(0.0, dot(N, L));
        vec4 dif = (matDiffuse * lightDiffuse * NdotL) / sqrt_n;

        vec4 spec = vec4(0.0);
        if (NdotL > 0.0)
        {
            float RdotV = pow(max(0.0, dot(R, V)), matShininess);
            spec = matSpecular * lightSpecular * RdotV;
        }

        finalColor += dif + spec;
    }
    
    finalColor.a = 1.0;
    fragColor = finalColor;
}
```

---

### Ejemplo 3: Boundary

#### 3.1-Enunciado

```glsl
Escriu un VS+FS per obtenir una il·luminació que resalti les "vores" de l'objecte.

El FS calcularà el cosinus c de l'angle entre N i -V.

Si c < edge0: negre
Si c > edge1: blanc
Entre edge0 i edge1: usar smoothstep per transició suau
```

#### 3.1b-Tasques Clau

**Tasca 1: Calcular vector V cap a la càmera en Eye Space**

```glsl
in vec3 v_position_eye;

// En Eye Space, la càmera està a l'origen (0, 0, 0)
// Vector de P a càmera: (0,0,0) - P = -P
vec3 V = normalize(-v_position_eye);

// Alternativa equivalent (més explícita):
vec3 V = normalize(vec3(0.0, 0.0, 0.0) - v_position_eye);
```

**Tasca 2: Calcular cosinus de l'angle entre N i V**

```glsl
vec3 N = normalize(v_normal_eye);
vec3 V = normalize(-v_position_eye);

// Producte escalar retorna directament el cosinus
float c = dot(N, V);
// c = |N| * |V| * cos(θ)
// Com N i V estan normalitzats: |N|=1, |V|=1
// Per tant: c = cos(θ)

// Interpretació:
// c ≈ 1.0  -> N i V apunten en la mateixa direcció (cara mira càmera)
// c ≈ 0.0  -> N i V són perpendiculars (VORA de l'objecte)
// c ≈ -1.0 -> N i V apunten en direccions oposades (cara d'esquena)
```

**Tasca 3: Aplicar llindars amb condicions**

```glsl
uniform float edge0 = 0.35;
uniform float edge1 = 0.4;

const vec4 COLOR_BLACK = vec4(0.0, 0.0, 0.0, 1.0);
const vec4 COLOR_WHITE = vec4(1.0, 1.0, 1.0, 1.0);

vec4 finalColor;

if (c < edge0) {
    // Prop de la vora -> Negre
    finalColor = COLOR_BLACK;
} 
else if (c > edge1) {
    // Lluny de la vora -> Blanc
    finalColor = COLOR_WHITE;
}
else {
    // Zona de transició [edge0, edge1] -> veure següent tasca
}
```

**Tasca 4: Usar smoothstep per transició suau**

```glsl
// smoothstep(edge0, edge1, x) retorna:
// - 0.0 si x <= edge0
// - 1.0 si x >= edge1  
// - Interpolació suau entre 0.0 i 1.0 si edge0 < x < edge1

float t = smoothstep(edge0, edge1, c);
// t és el factor d'interpolació suau

// Barrejar entre negre i blanc
finalColor = mix(COLOR_BLACK, COLOR_WHITE, t);
// t=0 -> COLOR_BLACK
// t=1 -> COLOR_WHITE
// t=0.5 -> Gris
```

**Tasca 5: Entendre smoothstep vs mix**

```glsl
// SMOOTHSTEP: Crea el factor d'interpolació amb suavitzat
float t = smoothstep(edge0, edge1, x);
// Aplica funció cúbica: t = 3x² - 2x³ (Hermite interpolation)

// MIX: Interpola linealment entre dos valors
vec4 result = mix(valueA, valueB, t);
// result = valueA*(1-t) + valueB*t

// Comparació amb interpolació lineal:
// Lineal:     t_linear = (x - edge0) / (edge1 - edge0);
// Smoothstep: t_smooth = smoothstep(edge0, edge1, x);  // Més suau!

// Exemple pràctic:
float edge0 = 0.35, edge1 = 0.4;
float x = 0.375;  // Punt mig

// Lineal: t = (0.375 - 0.35) / (0.4 - 0.35) = 0.5
float t_linear = (x - edge0) / (edge1 - edge0);

// Smoothstep: t ≈ 0.5 però amb transició més suau als extrems
float t_smooth = smoothstep(edge0, edge1, x);
```

#### 3.2-Vertex Shader

```glsl
#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec2 vtexCoord;
out vec3 v_normal_eye;
out vec3 v_position_eye;

uniform mat3 normalMatrix;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

void main()
{
    vtexCoord = texCoord;
    vec4 pos_eye_4 = modelViewMatrix * vec4(vertex, 1.0);
    v_position_eye = vec3(pos_eye_4);
    v_normal_eye = normalize(normalMatrix * normal);
    gl_Position = projectionMatrix * pos_eye_4;
}
```

#### 3.3-Fragment Shader

```glsl
#version 330 core

in vec2 vtexCoord;
in vec3 v_normal_eye;
in vec3 v_position_eye;

out vec4 fragColor;

uniform float edge0 = 0.35;
uniform float edge1 = 0.4;

const vec4 COLOR_WHITE = vec4(1.0, 1.0, 1.0, 1.0);
const vec4 COLOR_BLACK = vec4(0.0, 0.0, 0.0, 1.0);

void main()
{
    vec4 finalColor = COLOR_BLACK;
    vec3 N = normalize(v_normal_eye);
    vec3 V = normalize(vec3(0.0, 0.0, 0.0) - v_position_eye);
    float c = dot(N, V);
    
    if (c < edge0) {
        finalColor = COLOR_BLACK;
    } 
    else if (c > edge1) {
        finalColor = COLOR_WHITE;
    }
    else {
        float t = smoothstep(edge0, edge1, c);
        finalColor = mix(COLOR_BLACK, COLOR_WHITE, t);
    }

    fragColor = finalColor;
}
```
