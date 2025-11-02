#version 330 core

// --- INPUTS (from your 3D model) ---
layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

// --- OUTPUTS (to the Fragment Shader) ---
out vec2 vtexCoord;

// --- UNIFORMS (from the viewer) ---
uniform mat4 modelViewProjectionMatrix;

void main()
{
    // Pass the texture coordinate
    vtexCoord = texCoord;

    // ==============================================================


    // ==============================================================

    // Calculate the final position
    gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
}
