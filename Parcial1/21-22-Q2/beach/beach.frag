#version 330 core

// --- INPUT (from the Vertex Shader) ---
in vec2 vtexCoord;
in vec3 v_normal_eye;

// --- OUTPUT ---
out vec4 fragColor;

// --- UNIFORMS ---
uniform float time;
uniform sampler2D window;
uniform sampler2D palm1; // observeu el dígit 1 al final
uniform sampler2D background2; // observeu el dígit 2 al final

// Definicion colores
const vec4 COLOR_BLACK  = vec4(0.0, 0.0, 0.0, 1.0);

void main()
{
    vec3 N = normalize(v_normal_eye);
    vec4 finalColor = COLOR_BLACK;

    // textura window (amb les coordenades de textura habituals)
    vec4 C = texture(window, vtexCoord);

    // Si Alpha de C = 1.0, finalColor = C
    if (C.a == 1.0) finalColor = C;
    else if (C.a < 1.0) {

        vec2 term2 = 0.25 * N.xy;
        vec2 term3 = vec2(0.1*sin(2.0*time)*vtexCoord.t, 0.0);
        vec2 palmCoord = vtexCoord + term2 + term3;

        vec4 D = texture(palm1, palmCoord);

        if (D.a >= 0.5) finalColor = D;
        else {
            vec2 backCoords = vtexCoord + 0.5 * N.xy;
            finalColor = texture(background2, backCoords);
        }

    }

    fragColor = finalColor;
}