#version 330 core

// --- INPUT (del Vertex Shader) ---
in vec2 vtexCoord;

// --- OUTPUT ---
out vec4 fragColor;

// --- CONSTANTS (Definimos los colores y formas) ---
const vec4 COLOR_GREEN  = vec4(0.0, 1.0, 0.0, 1.0);
const vec4 COLOR_YELLOW = vec4(1.0, 1.0, 0.0, 1.0);
const vec4 COLOR_BLUE   = vec4(0.0, 0.0, 1.0, 1.0);

// --- Constantes del Círculo Azul ---
const float BLUE_CIRCLE_RADIUS = 0.12;
const vec2  BLUE_CENTER_TEX = vec2(0.5, 0.5); // Centro de la pantalla

// --- Constantes de la Banda Amarilla ---
const float BAND_OUTER_RADIUS = 0.20; // Más grande que el azul (0.12)
const float BAND_THICKNESS = 0.02;  
const vec2  BAND_CENTER_TEX = vec2(0.5, 0.70); // Centro movido a T=0.7 

void main()
{    
    // a. Empezar con el fondo verde
    vec4 finalColor = COLOR_GREEN;

    // b. Dibujar el rectángulo amarillo
    if (vtexCoord.s > 0.15 && vtexCoord.s < 0.85 && vtexCoord.t > 0.15 && vtexCoord.t < 0.85) {
        finalColor = COLOR_YELLOW;
    }

    // --- 2. Círculo Azul (Cálculo separado) ---
    // Centramos y corregimos el aspecto para el círculo azul
    float centered_s_blue = vtexCoord.s - BLUE_CENTER_TEX.s;
    float centered_t_blue = (vtexCoord.t - BLUE_CENTER_TEX.t) * 0.5;
    float dist_blue = length(vec2(centered_s_blue, centered_t_blue));

    // Dibujamos el círculo azul
    if (dist_blue < BLUE_CIRCLE_RADIUS) finalColor = COLOR_BLUE;
    
    // --- 3. Banda Amarilla (Cálculo separado) ---
    // Centramos y corregimos el aspecto para la banda amarilla
    float centered_s_band = vtexCoord.s - BAND_CENTER_TEX.s;
    float centered_t_band = (vtexCoord.t - BAND_CENTER_TEX.t) * 0.5;
    float dist_band = length(vec2(centered_s_band, centered_t_band));

    // Calculamos el radio interior
    float band_inner_radius = BAND_OUTER_RADIUS - BAND_THICKNESS;

    // Comprobamos si el píxel está en el "anillo"
    if (dist_band < BAND_OUTER_RADIUS && dist_band > band_inner_radius)
    {
        // "Dibujar solo si el píxel está en la mitad inferior de la pantalla
        if (vtexCoord.t < 0.5) finalColor = COLOR_YELLOW;
    }
    
    // --- Asignación Final ---
    fragColor = finalColor;
}