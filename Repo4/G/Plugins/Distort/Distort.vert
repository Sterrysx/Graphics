#version 330 core

layout (location = 0) in vec3 coordinates;

uniform mat4 modelViewProjectionMatrix;

void main() {
	gl_Position = modelViewProjectionMatrix * vec4(coordinates, 1.0);
}
