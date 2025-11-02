#version 330 core

layout (location = 0) in vec3 position;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;

out vec4 vertColor;
out vec3 vertNormal;

void main() {
	vertColor = vec4(color, 1.0);
	vertNormal = normal;
	gl_Position = vec4(position, 1.0);
}
