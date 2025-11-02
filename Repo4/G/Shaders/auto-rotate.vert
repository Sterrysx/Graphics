#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 2) in vec3 color;

out vec4 frontColor;

uniform mat4 modelViewProjectionMatrix;
uniform float time;
uniform float speed = 0.5;

vec3 rotation(vec3 vertex) {
	float angle = speed * time;
	float c = cos(angle);
	float s = sin(angle);
	return mat3(c, 0.0, -s, 0.0, 1.0, 0.0, s, 0.0, c) * vertex;
}

void main() {
	frontColor = vec4(color,1.0);
	gl_Position = modelViewProjectionMatrix * vec4(rotation(vertex), 1.0);
}
