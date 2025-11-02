#version 330 core

in vec2 vtexCoord;

out vec4 fragColor;

uniform sampler2D foc0;
uniform sampler2D foc1;
uniform sampler2D foc2;
uniform sampler2D foc3;
uniform float slice = 0.1;
uniform float time;

void main() {
	int frame = int(time / slice) % 4;
	switch (frame) {
		case 0: fragColor = texture(foc0, vtexCoord); break;
		case 1: fragColor = texture(foc1, vtexCoord); break;
		case 2: fragColor = texture(foc2, vtexCoord); break;
		case 3: fragColor = texture(foc3, vtexCoord); break;
	}
}
