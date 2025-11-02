#version 330 core

layout (location = 0) in vec3 position;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;

out vec3 vertColor;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

void main() {
	vec3 N = normalize(normalMatrix * normal);
	vertColor = color * N.z;
	gl_Position = modelViewProjectionMatrix * vec4(position, 1.0);
}
