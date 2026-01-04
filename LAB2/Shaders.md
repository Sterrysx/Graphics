# Parcial 2-SHADERS


## Índice
- [Parcial 2-SHADERS](#parcial-2-shaders)
  - [Tipos de esqueleto](#tipos-de-esqueleto)
    - [Class A-Esqueleto (PER-VERTEX)](#class-a-esqueleto-per-vertex-deformación)
      - [A-Vertex Shader](#a-vertex-shader)
      - [A-Fragment Shader](#a-fragment-shader)
    - [Class B-Esqueleto (PER-FRAGMENT)](#class-b-esqueleto-per-fragment)
      - [B1: Texturas (Mapeado de Imágenes)](#b1-texturas-mapeado-de-imágenes)
        - [B1-Vertex Shader](#b1-vertex-shader)
        - [B1-Fragment Shader](#b1-fragment-shader)
      - [B2: Iluminación (Modelo Phong / Alta Calidad)](#b2-iluminación-modelo-phong--alta-calidad)
        - [B2-Vertex Shader](#b2-vertex-shader)
        - [B2-Fragment Shader](#b2-fragment-shader)
    - [Class C-Esqueleto (PER-GEOMETRY)](#class-c-esqueleto-per-geometry)
      - [C-Vertex Shader](#c-vertex-shader)
      - [C-Geometry Shader](#c-geometry-shader)
      - [C-Fragment Shader](#c-fragment-shader)





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
    vtexCoord = texCoord;

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


## Class C-Esqueleto (PER-GEOMETRY)

### C-Vertex Shader

En este tipo de ejercicios, el Vertex Shader suele ser muy simple ("Pass-Through"). **No proyectamos** todavía a Clip Space porque el Geometry Shader necesita las coordenadas originales (Object Space) para hacer cálculos (como encontrar el centro de un triángulo).

```glsl
#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 2) in vec3 color;

out vec4 vfrontColor; // Color que enviaremos al GS

// NOTA: A veces no necesitamos matrices aquí si el GS hace todo el trabajo.
void main()
{
    // 1. Pasamos el color
    vfrontColor = vec4(color, 1.0);

    // 2. IMPORTANTE: Pasamos la posición en OBJECT SPACE (sin multiplicar por matrices).
    // El GS decidirá dónde colocar los nuevos vértices y aplicará la proyección.
    gl_Position = vec4(vertex, 1.0); 
}

```

### C-Geometry Shader

Este es el núcleo. Aquí es donde **transformas** las coordenadas a Clip Space y **emites** los vértices.

```glsl
#version 330 core

// --- CONFIGURACIÓN DE ENTRADA/SALIDA ---
layout(triangles) in;  // Recibimos un triángulo (3 vértices)
layout(triangle_strip, max_vertices = 36) out; // MÁXIMO de vértices a generar (ajustar según ejercicio)

// --- INPUTS (vienen del VS como arrays []) ---
in vec4 vfrontColor[]; 

// --- OUTPUTS (van al FS) ---
out vec4 gfrontColor;
out vec2 gtexCoord; // Si necesitas texturas, genéralas aquí

// --- UNIFORMS ---
uniform mat4 modelViewProjectionMatrix;

void main( void )
{
    // EJEMPLO 1: Bucle estándar (copiar el triángulo tal cual)
    // ---------------------------------------------------------
    for( int i = 0 ; i < 3 ; i++ )
    {
        gfrontColor = vfrontColor[i];
        
        // Aquí SÍ aplicamos la matriz de proyección
        gl_Position = modelViewProjectionMatrix * gl_in[i].gl_Position; 
        
        EmitVertex(); // Emite 1 vértice
    }
    EndPrimitive(); // Cierra el triángulo (triangle_strip)


    // EJEMPLO 2: Generar geometría nueva (p.ej. un CUBITO en el centro)
    // ---------------------------------------------------------
    // 1. Calcular el centro del triángulo original (Object Space)
    // vec3 center = (gl_in[0].gl_Position.xyz + gl_in[1].gl_Position.xyz + gl_in[2].gl_Position.xyz) / 3.0;
    
    // 2. Emitir vértices de una nueva forma relativos a 'center'
    // (Ver ejercicio RGB Color Space o Rubiks para lógica de cubos completa)
    // gfrontColor = ...
    // gl_Position = modelViewProjectionMatrix * vec4(center + offset, 1.0);
    // EmitVertex();
    // ...
    // EndPrimitive();
}

```

### C-Fragment Shader

El Fragment Shader suele ser idéntico al de la **Class A**, solo que recibe los datos del GS (prefijo `g`) en lugar del VS.

```glsl
#version 330 core

// --- INPUT (Viene del Geometry Shader) ---
in vec4 gfrontColor; 
// in vec2 gtexCoord; // Si usaste texturas en el GS

// --- OUTPUT ---
out vec4 fragColor;

void main()
{
    fragColor = gfrontColor;
    
    // Si tienes texturas o márgenes (bordes negros):
    // if (gtexCoord.s < 0.05 || gtexCoord.s > 0.95 ...) fragColor = vec4(0);
}

```
