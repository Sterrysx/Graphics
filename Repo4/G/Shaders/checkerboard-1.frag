#version 330 core

in vec2 vtexCoord;

out vec4 fragColor;

const vec4 black = vec4(0.0);
const vec4 gray = vec4(0.8);

void main() {
	vec2 v = mod(vtexCoord, 0.25) - vec2(0.125);
	fragColor = v.x * v.y > 0 ? gray : black;
}
