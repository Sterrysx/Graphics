#version 330 core

const vec4 red = vec4(1.0, 0.0, 0.0, 1.0);

in vec2 vtexCoord;

out vec4 fragColor;

void main() {
	bool h = vtexCoord.x < 0.1 ||
	         vtexCoord.x > 0.9;
	bool d = vtexCoord.x >= 0.5 && abs(vtexCoord.x - vtexCoord.y) < 0.1 ||
	         vtexCoord.x < 0.5 && abs(1.0 - vtexCoord.x - vtexCoord.y) < 0.1;

	if (h || d) fragColor = red;
	else discard;
}
