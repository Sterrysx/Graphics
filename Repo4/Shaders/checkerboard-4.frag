#version 330 core

in vec2 vtexCoord;

out vec4 fragColor;

uniform float n = 8;
uniform float r = 9;

const vec4 red = vec4(1.0, 0.0, 0.0, 1.0);


void main() {
	vec2 v = mod(vtexCoord, 1.0 / n);
	// b + g = 1 / n => b + r * b = 1 / n => b = 1 / n / (r + 1)
	float w = 1.0 / n / (r + 1);
	if (v.x < w || v.y < w) fragColor = red;
	else discard;
}
