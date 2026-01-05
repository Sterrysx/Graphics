# Helpers

## 1.Fragment Shaders

### 1.A.Textures

### 1. `getIcon`

**Description:**
Retrieves a specific sprite from a texture atlas (grid). It handles the conversion from logical grid coordinates to texture coordinates.

* **Coordinate System:** Uses standard OpenGL logic where `(0,0)` is **Bottom-Left**.

**Code:**

```glsl
vec4 getIcon(sampler2D fullTexture, vec2 whichIcon, vec2 totalIcons, vec2 coordsInsideIcon) 
{
    vec2 iconSize = 1.0 / totalIcons;
    vec2 finalPosition = (whichIcon + coordsInsideIcon) * iconSize;
    return texture(fullTexture, finalPosition);
}

```

**Parameters:**

* `fullTexture`: The texture sampler (e.g., `colormap`).
* `whichIcon`: The grid coordinates of the sprite (e.g., `vec2(3.0, 1.0)` for Column 3, Row 1).
* `totalIcons`: The total size of the grid (e.g., `vec2(4.0, 4.0)`).
* `coordsInsideIcon`: The calculated `[0,1]` position inside the specific sprite.

**Usage Example:**

```glsl
// Get the "Blue Alien" at Bottom-Left (0,0) of a 4x4 grid
vec4 color = getIcon(colormap, vec2(0.0, 0.0), vec2(4.0, 4.0), coordsInsideIcon);

```

---

### 2. `removeBackgroundColor`

**Description:**
Performs a "Chroma Key" operation. It checks the distance between the pixel color and a specific background color. If they are close, it returns a transparent pixel (black).

**Code:**

```glsl
vec4 removeBackgroundColor(vec4 inputColor, vec4 colorToRemove, float threshold) 
{
    float dist = distance(inputColor.rgb, colorToRemove.rgb);
    if (dist < threshold) {
        return vec4(0.0, 0.0, 0.0, 1.0); // Return Black/Transparent
    }
    return inputColor;
}

```

**Parameters:**

* `inputColor`: The raw color fetched from the texture.
* `colorToRemove`: The background color to delete (e.g., `vec4(0,0,0,1)` for black).
* `threshold`: Sensitivity. `0.1` is standard. Use `0.4` if edges look messy.

**Usage Example:**

```glsl
// Remove black background from the sprite
finalColor = removeBackgroundColor(rawSpriteColor, vec4(0.0, 0.0, 0.0, 1.0), 0.1);

```

---

### 3. `tileAndCenter`

**Description:**
Repeats an object `N` times across a row. Crucially, it calculates padding to keep the sprite aspect ratio correct (prevents stretching).

* **Use case:** Rows of enemies, lives counters, score icons.

**Code:**

```glsl
bool tileAndCenter(float globalS, float repetitions, float spriteWidth, out float outLocalS) 
{
    // 1. How wide is the "parking spot" for one item?
    float zoneWidth = 1.0 / repetitions;
    
    // 2. Get local coord [0..1] inside that parking spot
    float rawS = fract(globalS * repetitions);
    
    // 3. Calculate Padding to keep aspect ratio
    float fillRatio = spriteWidth / zoneWidth;
    float padding = (1.0 - fillRatio) / 2.0;
    
    // 4. Check if we are in the empty padding
    if (rawS < padding || rawS > (1.0 - padding)) {
        return false;
    }
    
    // 5. Calculate final 0..1 coordinate for the sprite itself
    outLocalS = (rawS - padding) / fillRatio;
    return true;
}

```

**Parameters:**

* `globalS`: The current screen coordinate (`vtexCoord.s`).
* `repetitions`: How many items do you want in the row? (e.g., `4.0`).
* `spriteWidth`: The visual width of the sprite (e.g., `0.1`).
* `outLocalS`: **(Output)** The variable where the result will be stored.

**Usage Example:**

```glsl
// Draw 4 shields in a row
bool inside = tileAndCenter(vtexCoord.s, 4.0, 0.1, coordsInsideIcon.s);
if (!inside) draw = false;

```

---

### 4. `placeIcon` (with Moving System)

**Description:**
Places a sprite at a specific absolute position (`centerX`). This ignores the grid and allows for smooth movement.

* **Use case:** The Player, a moving projectile, or a boss.

**Code:**

```glsl
bool placeIcon(float globalS, float centerX, float spriteWidth, out float outLocalS) 
{
    float halfWidth = spriteWidth / 2.0;
    float leftEdge  = centerX - halfWidth;
    float rightEdge = centerX + halfWidth;
    
    // Check boundaries
    if (globalS < leftEdge || globalS > rightEdge) {
        return false;
    }
    
    // Normalize to 0..1
    outLocalS = (globalS - leftEdge) / spriteWidth;
    return true;
}

```

**Parameters:**

* `globalS`: The current screen coordinate (`vtexCoord.s`).
* `centerX`: Center position of the object (`0.0` to `1.0`).
* `spriteWidth`: The visual width of the object (e.g., `0.1`).
* `outLocalS`: **(Output)** The variable where the result will be stored.

**Usage Example (Moving System):**

```glsl
// 1. Calculate X based on time (Oscillate left/right)
//    0.5 is center, 0.4 is range (moves from 0.1 to 0.9)
float movingX = 0.5 + 0.4 * sin(time * 2.0);

// 2. Place the icon at that dynamic X
bool inside = placeIcon(vtexCoord.s, movingX, 0.1, coordsInsideIcon.s);
if (!inside) draw = false;

```




## 2.Vertex Shaders

## 3.Geometry Shaders

Aquí tienes tu **Hoja Maestra para Geometry Shaders**.

He dividido esto en dos partes:

1. **La Teoría (The Pipeline):** Una explicación visual rápida de cómo fluyen los datos (inputs/outputs).
2. **El Manual de Funciones:** Las 3 recetas exactas que pediste, listas para copiar y pegar.

---

## ⚙️ Parte 1: El Flujo del Geometry Shader

El Geometry Shader (GS) es un **procesador de primitivas**. A diferencia del Vertex Shader (que procesa 1 vértice) o el Fragment Shader (que procesa 1 píxel), el GS recibe **la figura completa** (un triángulo entero) y puede decidir qué hacer con él: borrarlo, clonarlo o transformarlo en otra cosa.

### 1. El Input (`gl_in[]`)

El GS recibe los datos en **Arrays**. Como un triángulo tiene 3 vértices, recibes arrays de tamaño 3.

* `gl_in[0]`: Datos del primer vértice.
* `gl_in[1]`: Datos del segundo vértice.
* `gl_in[2]`: Datos del tercer vértice.

**Importante:** Si calculaste `gl_Position` en el Vertex Shader, aquí la lees como `gl_in[i].gl_Position`.

### 2. El Output (`Triangle Strip`)

El GS no emite "triángulos sueltos", emite una **Tira de Triángulos** (`triangle_strip`).

* Funciona conectando puntos en orden: 1-2-3 crea un triángulo, el 4 crea otro usando 2-3-4, etc.
* **`EmitVertex()`**: Envía el vértice actual (con sus colores, normales y posición) a la GPU.
* **`EndPrimitive()`**: Corta la tira. Es como levantar el lápiz del papel. Si no lo usas, la GPU intentará conectar tu sombra con tu objeto real con una línea fea.

### 3. La Memoria (`max_vertices`)

Al principio del shader debes declarar cuántos vértices *como máximo* vas a generar.

* Solo el triángulo original: `max_vertices = 3`.
* Triángulo + Sombra: `max_vertices = 6`.
* Un cubo (Rubik): `max_vertices = 24`.

---

## 🛠️ Parte 2: Recetario de Funciones (Copy-Paste)

Copia estas funciones antes del `main()` o úsalas como plantilla dentro de él.

### 1. `emitBasicTriangle` (El Básico)

**Descripción:**
La operación más simple. Coge el triángulo que entra, aplica la matriz de proyección y lo pinta tal cual. Es el "Pass-Through".

* **Requisito:** `layout(triangle_strip, max_vertices = 3) out;`

**Código:**

```glsl
void emitBasicTriangle(mat4 MVP)
{
    for(int i = 0; i < 3; i++)
    {
        // 1. Copiar atributos (Color, Normales, TexCoords si los hay)
        gfrontColor = vfrontColor[i]; 

        // 2. Transformar posición (Object Space -> Clip Space)
		vec4 pos = gl_in[i].gl_Position;
        gl_Position = modelViewProjectionMatrix * pos; 
        
        // 3. Emitir
        EmitVertex();
    }
    EndPrimitive(); // ¡Importante cerrar el triángulo!
}

```

---

### 2. `emitShadow` (La Sombra)

**Descripción:**
Genera un segundo triángulo aplastado contra el suelo (`y = suelo`). Se suele pintar de negro.

* **Truco:** Funciona mejor si el Vertex Shader envía las coordenadas en *Object Space* (sin multiplicar por MVP), para que el GS pueda aplastar la Y fácilmente antes de proyectar.
* **Requisito:** `layout(triangle_strip, max_vertices = 6) out;` (3 para el objeto + 3 para la sombra).

**Código:**

```glsl
void emitShadow(mat4 MVP, float floorY)
{
    // --- PASO 1: Pintar el triángulo negro aplastado ---
    for(int i = 0; i < 3; i++)
    {
        gfrontColor = vec4(0.0, 0.0, 0.0, 1.0); // Color Negro

        // A. Coger posición original (Object Space)
        vec4 pos = gl_in[i].gl_Position;

        // B. Aplastar contra el suelo (Shadow Logic)
        pos.y = floorY; 

        // C. Proyectar
        gl_Position = modelViewProjectionMatrix * pos;
        EmitVertex();
    }
    EndPrimitive();

    // --- PASO 2: Pintar el objeto real encima ---
    // (Reutilizamos la lógica del básico)
    for(int i = 0; i < 3; i++)
    {
        gfrontColor = vfrontColor[i];
        gl_Position = MVP * gl_in[i].gl_Position;
        EmitVertex();
    }
    EndPrimitive();
}

```

---

### 3. `emitQuad` (El Cuadrado / Truco de 4 Iteraciones)

**Descripción:**
Genera un cuadrado perfecto usando una `triangle_strip` de 4 vértices.

* **El Orden Mágico:** Para que salga un cuadrado y no un reloj de arena, el orden de los vértices debe ser en **Z (Zig-Zag)**:
1. Bottom-Left `(-1, -1)`
2. Bottom-Right `( 1, -1)`
3. Top-Left `(-1,  1)`
4. Top-Right `( 1,  1)`


* **Uso:** Ideal para crear suelos, billboards (partículas) o las caras del Cubo de Rubik.

**Código:**

```glsl
void emitQuad(vec3 center, float size, mat4 MVP)
{
    // 1. Definir los 4 offsets en orden "Triangle Strip" (Z pattern)
    vec3 OFFSETS[4];
    OFFSETS[0] = vec3(-1.0, -1.0, 0.0); // Bottom-Left
    OFFSETS[1] = vec3( 1.0, -1.0, 0.0); // Bottom-Right
    OFFSETS[2] = vec3(-1.0,  1.0, 0.0); // Top-Left
    OFFSETS[3] = vec3( 1.0,  1.0, 0.0); // Top-Right

    // 2. Loop de 4 iteraciones
    for(int i = 0; i < 4; i++)
    {
        gfrontColor = vec4(0.0, 1.0, 1.0, 1.0); // Color (ej. Cyan)

        // A. Calcular posición: Centro + (Offset escalado)
        vec3 pos = center + (OFFSETS[i] * size);

        // B. Proyectar
        gl_Position = MmodelViewProjectionMatrixVP * vec4(pos, 1.0);
        
        // C. TexCoords (Truco extra: Coinciden con los offsets normalizados 0..1)
        // gtexCoord = vec2(OFFSETS[i].x > 0 ? 1 : 0, OFFSETS[i].y > 0 ? 1 : 0);

        EmitVertex();
    }
    EndPrimitive();
}

```

Exactament, ho has entès a la perfecció. L'estructura mental que has de tenir per a qualsevol transformació en el Geometry Shader (GS) és sempre aquesta "recepta".

Anem a resoldre els teus dubtes punt per punt.

### 1. La Lògica Universal (Els 4 o 5 passos)

Sí, l'única cosa extra que et poden demanar és l'**Escalat (Scale)**. L'ordre canònic complet per transformar un vèrtex respecte al seu centre és:

1. **Centrar:** `pos = pos - Centre;` (Portar al (0,0,0) local)
2. **Escalar:** `pos = pos * factorEscala;` (Fer gran/petit)
3. **Rotar:** `pos = MatriuRotacio * pos;` (Girar)
4. **Descentrar:** `pos = pos + Centre;` (Tornar al lloc original)
5. **Moure:** `pos = pos + Translacio;` (L'explosió o moviment final)

Si et demanessin escalar (per exemple, que els trossos es facin petits mentre exploten per desaparèixer), el codi seria:

```glsl
// ... pasos previs ...
pos = pos - BT;          // 1. Centrar
pos = pos * (1.0 - time); // 2. Escalar (ex: es fa petit amb el temps)
pos = rotacio * pos;     // 3. Rotar
pos = pos + BT;          // 4. Descentrar
pos = pos + T;           // 5. Moure

```

### 2. Matrius de Rotació (X, Y, Z)

Correcte. La matriu que hem fet servir abans era per a **Z**. Si et demanen rotar respecte a **X** o **Y**, la matriu canvia. Has de saber-te les 3 de memòria (o saber deduir-les):

**Rotació en Z (la que has fet servir):**
Gira coses en el pla XY. La Z es queda igual.

```glsl
mat3 rotZ = mat3(
    c,  s, 0,
   -s,  c, 0,
    0,  0, 1
);

```

**Rotació en X:**
Gira coses en el pla YZ. La X es queda igual.

```glsl
mat3 rotX = mat3(
    1,  0,  0,
    0,  c,  s,
    0, -s,  c
);

```

**Rotació en Y:**
Gira coses en el pla XZ. La Y es queda igual.
*Ull viu: aquí els signes del sinus canvien de lloc respecte a les altres.*

```glsl
mat3 rotY = mat3(
    c,  0, -s,
    0,  1,  0,
    s,  0,  c
);

```

### 3. Per què la mitjana de normals és `vec3`?

Perquè una normal no és un valor d'intensitat (com un `float`), sinó una **fletxa** que apunta cap a algun lloc en l'espai 3D.

Imagina que tens tres fletxes sortint del triangle:

1. Apuna amunt `(0, 1, 0)`
2. Apunta a la dreta `(1, 0, 0)`
3. Apunta en diagonal `(1, 1, 0)`

La "mitjana" ha de ser una nova fletxa que apunti entremig de les tres. Si féssim servir un `float`, perdríem la informació de "cap a on" apunta.

```glsl
// Sumem component a component (x amb x, y amb y...)
vec3 n = (vNormal[0] + vNormal[1] + vNormal[2]) / 3.0; 

```

### 4. Rotació respecte a un eix perpendicular a Z?

Si et diuen "eix perpendicular a Z", t'estan dient implícitament que usis l'eix **X** o l'eix **Y** (tots dos són perpendiculars a Z).

Tanmateix, la pregunta més difícil que et podrien fer és: **"Rota el triangle sobre el seu propi vector Normal"** (o un vector arbitrari qualsevol).

Això es resol amb la **Fórmula de Rotació de Rodrigues** (Axis-Angle Rotation). Si et cau això, no intentis construir la matriu a mà component a component perquè és infernal. Usa aquesta funció auxiliar (copia-la a dalt del teu shader):

**Funció per rotar sobre un eix arbitrari (Qualsevol `axis`):**

```glsl
mat3 rotationMatrix(vec3 axis, float angle) {
    axis = normalize(axis); // Importantíssim normalitzar l'eix
    float s = sin(angle);
    float c = cos(angle);
    float oc = 1.0 - c;

    return mat3(
        oc * axis.x * axis.x + c,           oc * axis.x * axis.y + axis.z * s,  oc * axis.z * axis.x - axis.y * s,
        oc * axis.x * axis.y - axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z + axis.x * s,
        oc * axis.z * axis.x + axis.y * s,  oc * axis.y * axis.z - axis.x * s,  oc * axis.z * axis.z + c
    );
}

```

**Com l'usaries al `main`:**

```glsl
// Exemple: Rotar sobre la Normal del triangle (eix arbitrari)
vec3 axis = n; // La normal mitjana que has calculat
float angle = angSpeed * time;

mat3 R = rotationMatrix(axis, angle);

// Després apliques R igual que abans:
pos = pos - BT;
pos = R * pos; // R generada per la funció
pos = pos + BT;

```

**Resum per l'examen:**

1. Aprèn-te de memòria l'estructura **Centrar -> Escalar -> Rotar -> Descentrar -> Moure**.
2. Tingues a mà les matrius bàsiques **X, Y, Z**.
3. Si et demanen rotar sobre un eix "rar" (com la normal), copia la funció `rotationMatrix` de Rodrigues.

## 4.Plugins

