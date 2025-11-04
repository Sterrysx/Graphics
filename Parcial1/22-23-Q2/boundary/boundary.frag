#version 330 core

// --- INPUT (from the Vertex Shader) ---
in vec2 vtexCoord;
in vec3 v_normal_eye;   // Interpolated Normal in Eye Space
in vec3 v_position_eye; // Interpolated Position in Eye Space

// --- OUTPUT ---
out vec4 fragColor;
uniform float edge0 = 0.35;
uniform float edge1 = 0.4;

// Definim com a constants colors
const vec4 COLOR_WHITE  = vec4(1.0, 1.0, 1.0, 1.0);
const vec4 COLOR_BLACK  = vec4(0.0, 0.0, 0.0, 1.0);

void main()
{
    // assignem valor per defecte
    vec4 finalColor = COLOR_BLACK;
    
    // normalitza N
    vec3 N = normalize(v_normal_eye);

    // vector unitari (normalitzar) V que uneix 2 punts la càmera amb P
    // V = càmera - P (però càmera és 0.0)
    vec3 V = normalize(vec3(0.0, 0.0, 0.0) - v_position_eye);
    
    // calcular el cosinus, el retorna directament el producte escalar.
    float c = dot(N, V);

    
    if (c < edge0) {
        finalColor = COLOR_BLACK;
    } 
    else if (c > edge1) {
        finalColor = COLOR_WHITE;
    }
    else if (c >= edge0 && c <= edge1) {
        float t = smoothstep(edge0, edge1, c);
        finalColor = mix(COLOR_BLACK, COLOR_WHITE, t);
    }

    fragColor = finalColor;
}