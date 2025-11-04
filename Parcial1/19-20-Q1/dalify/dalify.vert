#version 330 core

// --- INPUTS (from your 3D model) ---
layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

// --- OUTPUTS (to the Fragment Shader) ---
out vec4 frontColor; // El color final calculado para este vértice
out vec2 vtexCoord;  // La coordenada de textura

// --- UNIFORMS (from the viewer) ---
uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

// --- UNIFORMS (Añadidos para "Dalify") ---
uniform float t = 0.4;
uniform float scale = 4.0;
uniform vec3 boundingBoxMin; // Proporcionado por el viewer
uniform vec3 boundingBoxMax; // Proporcionado por el viewer

void main()
{
    // Estas son tus variables iniciales
    vec4 vertex_objectspace = vec4(vertex, 1.0);
    vec3 normal_objectspace = normal; // No modificamos la normal

    // ==============================================================
    // == STEP 3 (VS) - CÓDIGO DE DEFORMACIÓN "Dalify"
    // ==============================================================
    
    // 1. Calcular 'c' (el punto de corte en Y)
    // Interpolar linealmente entre el min y max de Y usando 't'
    float c = mix(boundingBoxMin.y, boundingBoxMax.y, t);

    // 2. Calcular 'Δ' (Delta, la traslación)
    // El enunciado da la fórmula: c*scale = c + Δ
    // Aislamos Δ: Δ = c*scale - c
    float delta = c * (scale - 1.0);

    // 3. Aplicar la deformación (escalar o trasladar)
    if (vertex_objectspace.y < c)
    {
        // Parte de abajo: ESCALAR
        vertex_objectspace.y = vertex_objectspace.y * scale;
    }
    else
    {
        // Parte de arriba: TRASLADAR
        vertex_objectspace.y = vertex_objectspace.y + delta;
    }

    // ==============================================================

    // Calcular la normal en Eye Space (sin modificar)
    vec3 N = normalize(normalMatrix * normal_objectspace);

    // Calcular el color ("tarea habitual" del esqueleto)
    frontColor = vec4(color, 1.0) * N.z;

    // Pasar la coordenada de textura
    vtexCoord = texCoord;

    // Calcular la posición final usando el VÉRTICE DEFORMADO
    gl_Position = modelViewProjectionMatrix * vertex_objectspace;
}