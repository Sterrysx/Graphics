#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;

out vec2 vertexTextureCoordinates;
out vec3 vertexNormal;

uniform float radius;
uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

void main() {
	vertexTextureCoordinates = (4.0 / radius) * (vertex.xy + vertex.zx);
	vertexNormal = normalMatrix * normal;
	gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
}
