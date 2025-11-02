#version 330 core

in vec2 vtexCoord;

out vec4 fragColor;

uniform int nstripes = 16;
uniform vec2 origin = vec2(0.0);

const vec4 red = vec4(1.0, 0.0, 0.0, 1.0);
const vec4 yellow = vec4(1.0, 1.0, 0.0, 1.0);

void main() {
	int franga = int(distance(vtexCoord, origin) / (1.0 / nstripes));
	fragColor = franga % 2 == 0 ? red : yellow;
}
