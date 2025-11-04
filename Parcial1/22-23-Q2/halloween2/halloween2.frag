#version 330 core

// --- INPUT (del Vertex Shader) ---
in vec2 vtexCoord;

// --- OUTPUT ---
out vec4 fragColor;

// --- CONSTANTS (Definimos los colores y formas) ---
const vec4 COLOR_BLACK   = vec4(0.0, 0.0, 0.0, 1.0);
const vec4 COLOR_GRAY   = vec4(0.25, 0.25, 0.25, 1.0);
const vec4 COLOR_ORANGE = vec4(1.0, 0.75, 0.0, 1.0);

// --- Constantes del Círculo Azul ---
const float BLUE_CIRCLE_RADIUS = 0.12;
const vec2  BLUE_CENTER_TEX = vec2(0.5, 0.5); // Centro de la pantalla

void main()
{    

    // 0. Preparar variables
    vec2 center = vec2(0.5, 0.5);
    vec2 coord; 
    coord.x = (vtexCoord.s - center.s);
    coord.y = vtexCoord.t - center.t;
    float dist = length(coord);
    // coord va de -0,5 a 0,5, siendo 0.0 el mínimo

    // 1. Empezar con el fondo negro
    vec4 finalColor = COLOR_BLACK;

    // 2. Hacer difuminado circulo naranja
    float radius = 0.5; // Radio del fundido
    float t = clamp(dist / radius, 0.0, 1.0);
    finalColor = mix(COLOR_ORANGE, COLOR_BLACK, t);

    // 3. Círculo cara
    float faceRadius = 0.3;         // Radio del círculo
    bool faceCircle = dist < faceRadius;

    // 4. Hat
    float min_X = -0.025;
    float min_Y = 0.3;
    float max_X = 0.025;
    float max_Y = 0.4;

    bool hat =  coord.s > min_X && coord.s < max_X &&
                coord.t > min_Y && coord.t < max_Y;

    // 5. Ojos
    vec2 left_eye_center = vec2(-0.1, 0.12);
    float eye_radius = 0.075;
    float distance_left = distance(coord, left_eye_center);
    bool leftEye = distance_left < eye_radius;

    vec2 right_eye_center = vec2(0.1, 0.12);
    float distance_right = distance(coord, right_eye_center);
    bool rightEye = distance_right < eye_radius;

    // 6. Mouth
    vec2 centerM = vec2(0.0, 0.0);
    float outer_radiusM = 0.2;
    float distM = distance(coord, centerM);

    vec2 centerM2 = vec2(0.0, 0.05);
    float outer_radiusM2 = 0.25;
    float distM2 = distance(coord, centerM2);

    bool semiCircle1 = distM < outer_radiusM && coord.y < 0.0;
    bool semiCircle2 = distM2 < outer_radiusM && coord.y < 0.0;
    bool mouth = semiCircle1 &&  !semiCircle2;

    // 7. pintar
    bool isBody = faceCircle || hat;
    bool isHole = leftEye || rightEye || mouth;
    if (isBody && !isHole) finalColor = COLOR_GRAY;

    fragColor = finalColor;
}