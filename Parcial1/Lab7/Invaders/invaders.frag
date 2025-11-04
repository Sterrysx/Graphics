#version 330 core

// --- INPUT (from the Vertex Shader) ---
in vec2 vtexCoord; // Coordinate (s, t) in the range [0, 1]

// --- OUTPUT ---
out vec4 fragColor;

// --- UNIFORMS (Added for "invaders") ---
uniform sampler2D colormap; // The "invaders.png" texture

void main()
{
    // ==============================================================
    // == "invaders" LOGIC GOES HERE ==
    // ==============================================================
    
    // 1. Default color: BLACK (this is our space background)
    vec4 finalColor = vec4(0.0, 0.0, 0.0, 1.0);

    // The texture is a 4x4 grid
    vec2 tileSize = vec2(0.25, 0.25);
    vec2 tile = vec2(0.0);
    vec2 localCoord = vec2(0.0);
    bool draw = true; 

    // Divide the screen into rows using the T (Y) coordinate
    if (vtexCoord.t > 0.8) {
        // Row 6 (e.g., blue alien)
        // Texture (Col 0, Row 3) -> Tile Y-coord = 3
        tile = vec2(0.0, 3.0); 
        localCoord.s = fract(vtexCoord.s * 12.0); // 12 aliens
        localCoord.t = (vtexCoord.t - 0.8) / 0.1; // Map [0.8, 0.9] to [0, 1]
    } else if (vtexCoord.t > 0.7) {
        // Row 5 (e.g., green alien)
        // Texture (Col 1, Row 3) -> Tile Y-coord = 3
        tile = vec2(1.0, 3.0);
        localCoord.s = fract(vtexCoord.s * 12.0);
        localCoord.t = (vtexCoord.t - 0.7) / 0.1;
    } else if (vtexCoord.t > 0.6) {
        // Row 4 (e.g., other green alien)
        // Texture (Col 0, Row 2) -> Tile Y-coord = 2
        tile = vec2(0.0, 2.0); 
        localCoord.s = fract(vtexCoord.s * 12.0);
        localCoord.t = (vtexCoord.t - 0.6) / 0.1;
    } else if (vtexCoord.t > 0.5) {
        // Row 3 (e.g., purple alien)
        // Texture (Col 1, Row 2) -> Tile Y-coord = 2
        tile = vec2(1.0, 2.0);
        localCoord.s = fract(vtexCoord.s * 12.0);
        localCoord.t = (vtexCoord.t - 0.5) / 0.1;
    } else if (vtexCoord.t > 0.4) {
        // Row 2 (e.g., yellow alien)
        // Texture (Col 0, Row 1) -> Tile Y-coord = 1
        tile = vec2(0.0, 1.0);
        localCoord.s = fract(vtexCoord.s * 12.0);
        localCoord.t = (vtexCoord.t - 0.4) / 0.1;
    } else if (vtexCoord.t > 0.3) {
        // Row 1 (e.g., small red alien)
        // Texture (Col 0, Row 0) -> Tile Y-coord = 0
        tile = vec2(0.0, 0.0);
        localCoord.s = fract(vtexCoord.s * 12.0);
        localCoord.t = (vtexCoord.t - 0.3) / 0.1;
    } else if (vtexCoord.t > 0.2) {
        // Row of SHIELDS (green)
        tile = vec2(3.0, 0.0);

        // --- Centering Logic ---

        // 1. Define row/sprite dimensions
        float rowHeight = 0.1;
        float spriteWidth = 0.1; // To keep a 1:1 aspect ratio
        float numShields = 4.0;
        
        // 2. Width of one "zone" (1.0 / 4.0 = 0.25)
        float zoneWidth = 1.0 / numShields; 

        // 3. Get the local t-coordinate (0.0 to 1.0)
        localCoord.t = (vtexCoord.t - 0.2) / rowHeight;

        // 4. Get the local s-coordinate (0.0 to 1.0)
        localCoord.s = fract(vtexCoord.s * numShields);

        // 5. Calculate ratios for centering
        // How much of the zone does the sprite fill? (0.1 / 0.25 = 0.4)
        float fill_ratio = spriteWidth / zoneWidth;
        // How much padding on *one side*? ( (1.0 - 0.4) / 2.0 = 0.3 )
        float padding_ratio = (1.0 - fill_ratio) / 2.0;

        // 6. Check if the pixel is in the drawable "window"
        // (i.e., not in the left 30% or right 30% padding)
        if (localCoord.s > padding_ratio && localCoord.s < (1.0 - padding_ratio)) 
        {
            // It is in the window [0.3, 0.7].
            // We must re-map this range back to [0.0, 1.0] for the sprite.
            
            // 1. Shift it: [0.3, 0.7] -> [0.0, 0.4]
            float shifted_s = localCoord.s - padding_ratio;
            
            // 2. Scale it: [0.0, 0.4] -> [0.0, 1.0]
            localCoord.s = shifted_s / fill_ratio;
        } else {
            // We are in the padding (the empty 30% on left or right)
            draw = false;
        }
    } else if (vtexCoord.t > 0.1) {
        // Row of the CANNON (white)
        // Texture (Col 3, Row 1) -> Tile Y-coord = 1
        tile = vec2(3.0, 1.0);
        if (vtexCoord.s > 0.45 && vtexCoord.s < 0.55) {
            localCoord.s = (vtexCoord.s - 0.45) / 0.10; 
            localCoord.t = (vtexCoord.t - 0.1) / 0.10;
        } else {
            draw = false; 
        }
    } else {
        // Empty space at the bottom
        draw = false;
    }

    // 2. If 'draw' is true, we attempt to draw a sprite.
    if (draw) {
        
        // ==================================================
        // == CHANGE IS HERE ==
        // The line 'localCoord.t = 1.0 - localCoord.t;'
        // was REMOVED to fix the upside-down sprites.
        // ==================================================
        
        // Calculate the final coordinate to sample from the texture
        vec2 sampleCoord = (tile + localCoord) * tileSize;
        
        // Read the texture color
        vec4 texColor = texture(colormap, sampleCoord);
        
        // Check the brightness
        // (The texture atlas has a black background)
        float brightness = texColor.r + texColor.g + texColor.b;
        
        if (brightness > 0.1) {
            // If it's NOT the black background,
            // update finalColor to the sprite color.
            finalColor = texColor;
        }
        // If it IS the black background (brightness < 0.1),
        // we do nothing. finalColor stays black.
    }
    // If 'draw' is false, we do nothing.
    // finalColor stays black from the beginning.

    // ==============================================================

    // --- Final Assignment ---
    fragColor = finalColor;
}