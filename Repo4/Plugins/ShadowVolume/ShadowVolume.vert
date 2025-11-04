#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 2) in vec3 color;

uniform mat4 modelViewProjectionMatrix;

out vec3 vertColor;

void main() {
	vertColor = color;
	gl_Position = modelViewProjectionMatrix * vec4(vertex,1.0);
}

