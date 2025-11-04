#version 330 core

// --- INPUTS (del modelo 3D) ---
layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

// --- OUTPUTS (al Fragment Shader) ---
out vec2 vtexCoord;

// --- UNIFORMS (del viewer) ---
uniform mat4 modelViewProjectionMatrix;

void main()
{
    // Pasar la coordenada de textura
    vtexCoord = texCoord;

    // Calcular la posición final
    gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
}