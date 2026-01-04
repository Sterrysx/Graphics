# Helpers

## 1.Fragment Shaders

### 1.A.Textures

Here is your clean, print-ready **Frankenstein Helper Manual**.

This document contains only the tools. Copy-paste these functions at the top of your shader (before `main`), and use the examples inside `main()` to build your solution.

---

# 🔌 GLSL Helper Functions Manual

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

## 4.Plugins
