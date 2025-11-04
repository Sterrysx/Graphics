#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 3) in vec2 texturePosition;

out vec2 vs_texturePosition;

uniform mat4 modelViewProjectionMatrix;

void main() {
	vs_texturePosition = texturePosition;
	gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
}
