#version 330 core

layout (location = 0) in vec3 position;
layout (location = 1) in vec3 normal;

out vec4 vs_color;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform float angle = 0.5;

void main() {
	float t;
	if (position.y <= 1.45) t = 0;
	else if (position.y < 1.55) t = smoothstep(1.45, 1.55, position.y);
	else t = 1;
	float s = sin(angle * t);
	float c = cos(angle * t);
	mat4 rotate = mat4(c, 0, -s, 0, 0, 1, 0, 0, s, 0, c, 0, 0, 0, 0, 1);
	gl_Position = modelViewProjectionMatrix * rotate * vec4(position, 1.0);
	vec3 N = normalize(normalMatrix * (rotate * vec4(normal, 0)).xyz);
	vs_color = vec4(N.zzz, 1);
}
