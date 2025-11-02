#version 330 core

// Al computador de referència passa el test.

in vec2 vtexCoord;

out vec4 fragColor;

const float a = 1.0 / 9.0;
const vec4 red = vec4(1.0, 0.0, 0.0, 1.0);
const vec4 yellow = vec4(1.0, 1.0, 0.0, 1.0);

void main() {
	int franga = int(vtexCoord.s / a) % 9;
	fragColor = franga % 2 == 0 ? yellow : red;
}
