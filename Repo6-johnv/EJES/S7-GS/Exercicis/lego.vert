#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 2) in vec3 color;

out vec3 vertColor;

void main() {
	vertColor = color;
	gl_Position = vec4(vertex, 1.0);
}
