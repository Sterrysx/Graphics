#version 330 core

in vec2 vtexCoord;

out vec4 fragColor;

uniform sampler2D map;
uniform float time;
uniform float a = 0.4;
const float pi = 3.141592;

vec4 parallaxHallucination(sampler2D sampler, vec2 st) {
	vec4 color = texture(sampler, st);
	float m = max(max(color.r, color.g), color.b);
	float angle = 2 * pi * time;
	float c = cos(angle);
	float s = sin(angle);
	vec2 u = mat2(c, -s, s, c) * vec2(m);
	vec2 offset = a / 100.0 * u;
	return texture(sampler, st + offset);
}

void main() {
	fragColor = parallaxHallucination(map, vtexCoord);
}
