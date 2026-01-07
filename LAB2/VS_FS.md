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

## A-Per Fragment
