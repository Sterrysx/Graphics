#version 330 core

layout (location = 0) in vec3 position;
layout (location = 1) in vec3 normal;

out vec4 vertPosition;
out vec3 vertNormal;

uniform mat4 modelViewMatrix, modelViewProjectionMatrix;
uniform mat3 normalMatrix;

void main() {
	vertNormal = normalMatrix * normal;
	vertPosition = modelViewProjectionMatrix * vec4(position, 1.0) / 2 + 0.5;
	gl_Position = modelViewProjectionMatrix * vec4(position, 1.0);
}
