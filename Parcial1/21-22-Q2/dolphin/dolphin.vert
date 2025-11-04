#version 330 core

// --- INPUTS (del modelo 3D) ---
layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

// --- OUTPUTS (al Fragment Shader) ---
out vec4 frontColor; // El color final calculado para este vértice
out vec2 vtexCoord;  // La coordenada de textura

// --- UNIFORMS (del viewer) ---
uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

// --- UNIFORMS (Añadidos para "Dolphin") ---
uniform float time;
const float PI = 3.1416;

void main()
{
    // Variables iniciales
    vec4 vertex_objectspace = vec4(vertex, 1.0);
    vec3 normal_objectspace = normal;

    // ==============================================================
    // == STEP 3 (VS) - LÓGICA DE DEFORMACIÓN "Dolphin"
    // ==============================================================

    // --- 1. Calcular ángulos (con offset de tiempo) ---
    // La animación dura 1 segundo
    float time_base = 2.0 * PI * time;
    
    // Parte delantera: time + 0.25, rango [-PI/32, PI/32]
    // Usamos -cos para que en t=0 empiece "abajo" (como pide la imagen)
    float angle_davantera = -(PI/32.0) * cos(time_base);

    // Parte posterior: time + 0.0, rango [-PI/4, 0]
    // Usamos sin() para mapear al rango [-PI/4, 0]
    float angle_posterior = -PI/8.0 + (PI/8.0) * sin(time_base);


    // --- 2. Calcular factores de mezcla (smoothstep) ---
    // t_davantera: 0.0 si y < 0.55, 1.0 si y > 0.75
    float t_davantera = smoothstep(0.55, 0.75, vertex.y);
    
    // t_posterior: 0.0 si y > 0.5, 1.0 si y < 0.05
    float t_posterior = smoothstep(0.5, 0.05, vertex.y);

    
    // --- 3. Calcular deformación (Rotación en X con pivote) ---
    
    // a) Deformación delantera (Pivote RD en y=0.65)
    float c_d = 0.65;
    float cos_d = cos(angle_davantera);
    float sin_d = sin(angle_davantera);
    
    vec4 P_davantera = vec4(
        vertex.x,
        (vertex.y - c_d) * cos_d - vertex.z * sin_d + c_d,
        (vertex.y - c_d) * sin_d + vertex.z * cos_d,
        1.0
    );
    vec3 N_davantera = vec3(
        normal.x,
        normal.y * cos_d - normal.z * sin_d,
        normal.y * sin_d + normal.z * cos_d
    );

    // b) Deformación posterior (Pivote RT en y=0.35)
    float c_p = 0.35;
    float cos_p = cos(angle_posterior);
    float sin_p = sin(angle_posterior);
    
    vec4 P_posterior = vec4(
        vertex.x,
        (vertex.y - c_p) * cos_p - vertex.z * sin_p + c_p,
        (vertex.y - c_p) * sin_p + vertex.z * cos_p,
        1.0
    );
    vec3 N_posterior = vec3(
        normal.x,
        normal.y * cos_p - normal.z * sin_p,
        normal.y * sin_p + normal.z * cos_p
    );

    // --- 4. Mezclar (blend) las deformaciones ---
    // Mezclamos la parte delantera
    vertex_objectspace = mix(vertex_objectspace, P_davantera, t_davantera);
    normal_objectspace = mix(normal_objectspace, N_davantera, t_davantera);
    
    // Mezclamos la parte posterior (sobre el resultado anterior)
    vertex_objectspace = mix(vertex_objectspace, P_posterior, t_posterior);
    normal_objectspace = mix(normal_objectspace, N_posterior, t_posterior);

    // ==============================================================

    // Calcular la normal en Eye Space (con la normal deformada)
    vec3 N = normalize(normalMatrix * normal_objectspace);

    // Calcular el color (Gris 0.8 * N.z)
    frontColor = vec4(0.8, 0.8, 0.8, 1.0) * N.z;

    // Pasar la coordenada de textura
    vtexCoord = texCoord;

    // Calcular la posición final (con el vértice deformado)
    gl_Position = modelViewProjectionMatrix * vertex_objectspace;
}