#version 330 core

// --- INPUTS (from your 3D model) ---
layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

// --- OUTPUTS (to the Fragment Shader) ---
out vec2 vtexCoord;
out vec3 v_normal_eye;   // Added from cheatsheet
out vec3 v_position_eye; // Added from cheatsheet

// --- UNIFORMS (from the viewer) ---
// We need these for the snippets
uniform mat3 normalMatrix;   // Added from cheatsheet
uniform mat4 modelViewMatrix;  // Added from cheatsheet
uniform mat4 projectionMatrix; // Added from cheatsheet

void main()
{
    // Pass the texture coordinate
    vtexCoord = texCoord;

    // --- "Pass Eye Position" Logic ---
    vec4 pos_eye_4 = modelViewMatrix * vec4(vertex, 1.0);
    v_position_eye = vec3(pos_eye_4);

    // --- "Pass Normal" Logic ---
    v_normal_eye = normalize(normalMatrix * normal);
    
    // --- "Pass Eye Position" Logic (continued) ---
    gl_Position = projectionMatrix * pos_eye_4;
}