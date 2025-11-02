#version 330 core

in vec2 vtexCoord;

out vec4 fragColor;

uniform sampler2D explosion;
uniform float freq = 30.0;
uniform float time;
const int rows = 6;
const int columns = 8;

void main() {
	int frame = int(time * freq) % (rows * columns);
	int column = frame % columns;
	int row = (rows - 1) - frame / columns;
	float s = (vtexCoord.s + column) / columns;
	float t = (vtexCoord.t + row) / rows;
	vec4 color = texture(explosion, vec2(s, t));
	fragColor = color.a * color;
}
