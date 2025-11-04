#version 330 core

layout (location = 0) in vec3 position;

out vec3 vs_position;

uniform mat4 modelViewMatrix, modelViewProjectionMatrix;
uniform float time, amplitude = 0.1;

vec3 rotation() {
	float angle = - amplitude * time;
	float c = cos(angle);
	float s = sin(angle);
	mat3 rotate = mat3(c, 0, s, 0, 1, 0, -s, 0, c);
	return rotate * position;
}

void main() {
	vs_position = (modelViewMatrix * vec4(rotation(), 1.0)).xyz;
	gl_Position = modelViewProjectionMatrix * vec4(rotation(), 1.0);
}
