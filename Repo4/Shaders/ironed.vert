#version 330 core

const float pi = 3.141592;

layout (location = 0) in vec3 position;

uniform mat4 modelViewProjectionMatrix;
uniform float amplitude = 0.1;
uniform float time;

vec3 ironed(vec3 P) {
	return vec3(P.x, amplitude * sin(2 * pi * P.x + 3 * time), P.z);
}

void main() {
	gl_Position = modelViewProjectionMatrix * vec4(ironed(position), 1.0);
}
