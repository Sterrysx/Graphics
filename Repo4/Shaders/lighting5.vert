#version 330 core

layout (location = 0) in vec3 vertex; // Coordenades del vèrtex (objecte).
layout (location = 1) in vec3 normal; // Direcció de la normal del vèrtex (objecte).

out vec3 Vo;
out vec3 No;

uniform mat4 modelViewMatrix;
uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform mat4 modelViewMatrixInverse;
uniform bool world = true;

void main() {
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

	gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
}
