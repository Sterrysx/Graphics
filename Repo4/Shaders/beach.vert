#version 330 core

layout (location = 0) in vec3 position;
layout (location = 2) in vec3 normal;
layout (location = 3) in vec2 textureCoordinates;

out vec3 vertNormal;
out vec2 vertTextureCoordinates;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

void main() {
	vertNormal = normalize(normalMatrix * normal);
	vertTextureCoordinates = textureCoordinates;
	gl_Position = modelViewProjectionMatrix * vec4(position, 1.0);
}
