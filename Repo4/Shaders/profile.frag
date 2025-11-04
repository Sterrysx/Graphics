#version 330 core

const vec3 yellow = vec3(0.7, 0.6, 0.0);

in vec3 vs_color;
in vec3 vs_vertex;
in vec3 vs_normal;

out vec3 fragColor;

uniform float epsilon = 0.1;
uniform float light = 0.5;

void main() {
	vec3 N = normalize(vs_normal);
	vec3 V = normalize(vs_vertex);
	if (dot(-V, N) < epsilon) fragColor = yellow;
	else fragColor = vs_color * light * N.z;
}
