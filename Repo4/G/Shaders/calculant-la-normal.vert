#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 2) in vec3 color;

out vec3 eyeVertex;
out vec3 vertexColor;

uniform mat4 modelViewMatrix, modelViewProjectionMatrix;

void main() {
	eyeVertex = (modelViewMatrix * vec4(vertex, 1.0)).xyz;
	vertexColor = color;
	gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
}
