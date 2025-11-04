#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;

out vec3 vs_color;
out vec3 vs_vertex;
out vec3 vs_normal;

uniform mat4 modelViewProjectionMatrix;
uniform mat4 modelViewMatrix;
uniform mat3 normalMatrix;

void main() {
	vs_normal = normalMatrix * normal;
	vs_vertex = (modelViewMatrix * vec4(vertex, 1.0)).xyz;
	vs_color = color;
	gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
}
