#version 330 core

const float pi = 3.141592;
const vec4 red = vec4(1, 0, 0, 1);
const vec4 yellow = vec4(1, 1, 0, 1);
const vec4 green = vec4(0, 1, 0, 1);
const vec4 cyan = vec4(0, 1, 1, 1);
const vec4 blue = vec4(0, 0, 1, 1);
const vec4 magenta = vec4(1, 0, 1, 1);

in vec2 vs_texturePosition;

out vec4 fragColor;

uniform sampler2D fbm0;
uniform float time, f = 0.1;

void main() {
	float r = texture(fbm0, vs_texturePosition).r;
	float phi = 2 * pi * r;
	float s = sin(2 * pi * f * time + phi);
	float k = s * 3;
	float f = fract(k);
	if (k <= -2) fragColor = mix(red, yellow, f);
	else if (k <= -1) fragColor = mix(yellow, green, f);
	else if (k <= 0) fragColor = mix(green, cyan, f);
	else if (k <= 1) fragColor = mix(cyan, blue, f);
	else if (k <= 2) fragColor = mix(blue, magenta, f);
	else if (k <= 3) fragColor = mix(magenta, red, f);
}
