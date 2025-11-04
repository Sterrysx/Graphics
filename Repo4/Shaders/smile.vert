#version 330 core

layout (location = 0) in vec3 position;
layout (location = 1) in vec3 normal;
layout (location = 3) in vec2 texturePosition;

out vec3 vs_normal;
out vec2 vs_texturePosition;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

void main() {
	vs_normal = normalMatrix * normal;
	vs_texturePosition = texturePosition;
	gl_Position = modelViewProjectionMatrix * vec4(position, 1.0);
}
