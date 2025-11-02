#version 330 core

layout (location = 0) in vec3 position;
layout (location = 1) in vec3 normal;

out vec3 vertColor;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform vec2 mousePosition;
uniform float mouseOverrideX = -1;
uniform vec2 viewport = vec2(800, 600);

vec4 rotateY(vec4 P, float angle) {
	float s = sin(angle);
	float c = cos(angle);
	return mat4(c, 0, -s, 0, 0, 1, 0, 0, s, 0, c, 0, 0, 0, 0, 1) * P;
}

void main() {
	float x = mouseOverrideX >= 0 ? mouseOverrideX : mousePosition.x;
	float angle = x / viewport.x * 2 - 1;

	float t;
	if (position.y < 1.45) t = 0;
	else if (position.y < 1.55) t = smoothstep(1.45, 1.55, position.y);
	else t = 1;

	float s = sin(angle * t);
	float c = cos(angle * t);
	mat4 rotate = mat4(c, 0, -s, 0, 0, 1, 0, 0, s, 0, c, 0, 0, 0, 0, 1);

	gl_Position = modelViewProjectionMatrix * rotate * vec4(position, 1.0);
	vec3 N = normalize(normalMatrix * (rotate * vec4(normal, 0)).xyz);
	vertColor = N.zzz;
}
