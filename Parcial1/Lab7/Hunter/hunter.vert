#version 330 core

// --- INPUTS (del modelo 3D) ---
layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;   // Lo mantenemos
layout (location = 2) in vec3 color;    // Lo mantenemos
layout (location = 3) in vec2 texCoord;

// --- OUTPUTS (al Fragment Shader) ---
out vec2 vtexCoord;

// --- UNIFORMS (del viewer) ---
// No usamos 'modelViewProjectionMatrix'
// El problema pide usar la identidad.

void main()
{
    // 1. Pasar la coordenada de textura
    vtexCoord = texCoord;

    // 2. Usar la posición del vértice como posición de clipping
    // (como pide el enunciado)
    gl_Position = vec4(vertex, 1.0);
}