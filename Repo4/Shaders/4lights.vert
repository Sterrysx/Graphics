#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;

out vec3 No;
out vec3 Vo;

uniform mat4 modelViewProjectionMatrix;

void main() {
	No = normal;
	Vo = vertex;
	gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
}
