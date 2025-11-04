#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec3 OBS;
out vec3 N;
out vec4 frontColor;
out vec2 vtexCoord;

uniform mat4 modelViewMatrix;
uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

void main()
{
    //Coordenadas del vertice (del objeto al observador)
    OBS = (modelViewMatrix * vec4(vertex,1.0)).xyz;

    // Dirección de la normal del vèrtex (d'objecte a vèrtex).
    N = normalize(normalMatrix * normal);
    
    frontColor = vec4(color,1.0) * N.z;
    vtexCoord = texCoord;
    gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
}
