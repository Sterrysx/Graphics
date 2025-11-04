#version 330 core

layout (location = 0) in vec3 position;
layout (location = 3) in vec2 texturePosition;

out vec2 vertTexturePosition;

uniform mat4 modelViewProjectionMatrix;

void main() {
	vertTexturePosition = texturePosition;
	gl_Position = modelViewProjectionMatrix * vec4(position, 1.0);
}
