#version 330 core

const vec3 blue = vec3(0, 0, 1);

layout (location = 0) in vec3 vertex;
layout (location = 3) in vec2 texturePosition;

out vec3 vs_color;

uniform mat4 modelViewProjectionMatrix;
uniform float time;

vec3 fold(vec3 vertex) {
	float angle = - time * texturePosition.s;
	float s = sin(angle);
	float c = cos(angle);
	mat3 rotate = mat3(c, 0, -s, 0, 1, 0, s, 0, c);
	return  rotate *  vertex;
}

void main() {
	vs_color = blue;
	gl_Position = modelViewProjectionMatrix * vec4(fold(vertex), 1.0);
}
