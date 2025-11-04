
#version 330 core
in vec2 vtexCoord;
out vec4 fragColor;
uniform float n = 8;
const vec4 black = vec4(0.0);
const vec4 gray = vec4(0.8);
void main() {
	vec2 v = mod(vtexCoord, 2.0 / n) - vec2(1.0 / n);
	fragColor = v.x * v.y > 0 ? gray : black;
}