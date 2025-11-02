#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;

out vec3 P;
out vec3 N;

uniform bool worldSpace = true;
uniform mat3 normalMatrix;
uniform mat4 modelViewProjectionMatrix, modelViewMatrix;

void main() {
	if (worldSpace) {
		P = vertex;
		N = normal;
	} else {
		P = (modelViewMatrix * vec4(vertex, 1.0)).xyz;
		N = normalMatrix * normal;
	}
	gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
}

