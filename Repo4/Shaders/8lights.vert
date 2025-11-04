#version 330 core

layout (location = 0) in vec3 position;
layout (location = 1) in vec3 normal;

out vec3 vs_position;
out vec3 vs_normal;

uniform mat4 modelViewProjectionMatrix, modelViewMatrix;
uniform mat3 normalMatrix;

void main() {
	vs_position = (modelViewMatrix * vec4(position, 1.0)).xyz;
	vs_normal = normalMatrix * normal;
	gl_Position = modelViewProjectionMatrix * vec4(position, 1.0);
}
