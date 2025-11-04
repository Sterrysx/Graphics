#version 330 core

layout (location = 0) in vec3 position;
layout (location = 1) in vec3 normal;

out vec3 vertColor;
out vec3 vertPosition;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

void main() {
	vec3 N = normalize(normalMatrix * normal);
	vertPosition = position;
	vertColor = N.zzz;
	gl_Position = modelViewProjectionMatrix * vec4(position, 1.0);
}
