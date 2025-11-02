#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 3) in vec2 texCoord;

out vec2 vtexCoord;

uniform mat4 modelViewProjectionMatrix;

vec3 scale(vec3 vertex) {
	return vec3(vertex.x, 0.5 * vertex.y, vertex.z);
}

void main() {
	vtexCoord = texCoord;
	gl_Position = modelViewProjectionMatrix * vec4(scale(vertex), 1.0);
}
