#version 330 core

layout (location = 0) in vec3 vertex; // Coordenades del vèrtex (objecte).
layout (location = 1) in vec3 normal; // Direcció de la normal del vèrtex (objecte).

out vec3 V_obs;
out vec3 N_ver;

uniform mat4 modelViewMatrix;
uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

void main() {
	// Coordenades del vèrtex (d'objecte a observador).
	V_obs = (modelViewMatrix * vec4(vertex, 1.0)).xyz;
	// Direcció de la normal del vèrtex (d'objecte a vèrtex).
	N_ver = normalize(normalMatrix * normal).xyz;
	gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
}
