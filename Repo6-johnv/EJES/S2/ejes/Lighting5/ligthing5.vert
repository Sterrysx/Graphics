#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;
out vec2 vtexCoord;
out vec3 Vo;
out vec3 No;


uniform mat4 modelViewMatrix;
uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform mat4 modelViewMatrixInverse;
uniform bool world = true;

void main()
{
    if (world) {
		// Coordenades del vèrtex (objecte).
		Vo = vertex;
		// Direcció de la normal del vèrtex (objecte).
		No = normal;
	} else {
		// Coordenades del vèrtex (d'objecte a observador).
		Vo = (modelViewMatrix * vec4(vertex, 1.0)).xyz;
		// Direcció de la normal del vèrtex (d'objecte a vèrtex).
		No = normalize(normalMatrix * normal).xyz;
	}

    vec3 N = normalize(normalMatrix * normal);
    frontColor = vec4(color,1.0) * N.z;
    vtexCoord = texCoord;
    gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
}
