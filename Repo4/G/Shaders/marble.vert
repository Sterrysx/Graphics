#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;

out vec4 V;
out vec3 N;

uniform mat4 modelViewProjectionMatrix;

void main() {
	N = normal;
	V = vec4(vertex, 1.0);
	gl_Position = modelViewProjectionMatrix * V;
	
}
