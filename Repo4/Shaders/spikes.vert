#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;

out vec3 vertNormal;
out vec4 vertColor;

uniform mat3 normalMatrix;

void main() {
	vec3 N = normalize(normalMatrix * normal);
	vertNormal = normal;
	vertColor = vec4(color * N.z, 1.0);
	gl_Position = vec4(vertex, 1.0);
}
