#version 330 core

layout (location = 0) in vec3 position;

out vec3 P;

uniform mat4 modelViewProjectionMatrix;

void main() {
	P = position;
	gl_Position = modelViewProjectionMatrix * vec4(position, 1.0);
}
