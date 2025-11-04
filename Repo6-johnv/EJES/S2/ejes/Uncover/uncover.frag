#version 330 core
in float x;

out vec4 fragColor;

const vec4 blue = vec4(0.0, 0.0, 1.0, 1.0);

uniform float time = 0;
uniform float period = 2;

void main() {
	if ((x + 1.0) / 2.0 <= time / period) fragColor = blue;
	else discard;
}
