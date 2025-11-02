#version 330 core

layout (location = 0) in vec3 position;
layout (location = 1) in vec3 normal;
layout (location = 3) in vec2 texturePosition;

out vec3 P;
out vec3 N;
out vec2 TP;

uniform mat4 modelViewProjectionMatrix, modelViewMatrix;
uniform mat3 normalMatrix;

void main() {
	P = (modelViewMatrix * vec4(position, 1.0)).xyz;
	N = normalMatrix * normal;
	TP = fract(texturePosition);
	gl_Position = modelViewProjectionMatrix * vec4(position, 1.0);
}
