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
    // == "Flag" LOGIC GOES HERE ==
    // ==============================================================
    
    // Create a new vertex variable
    vec4 new_vertex = vec4(vertex, 1.0);
    
    // Scale the Y coordinate by 0.5 to make the
    // 1x1 plane into a 1x0.5 (2:1 aspect ratio) rectangle
    new_vertex.y = new_vertex.y * 0.5;

    // ==============================================================

    // Calculate the final position using the MODIFIED vertex
    gl_Position = modelViewProjectionMatrix * new_vertex;
}