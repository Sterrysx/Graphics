#version 330 core

const vec4 blue = vec4(0.0, 0.0, 1.0, 1.0);
const float ppd = 1.0 / 6.0;  // Pixels per digit.
const float tpd = 1.0 / 10.0; // Texels per digit.

in vec2 vtexCoord;

out vec4 fragColor;

uniform sampler2D colorMap;

void main() {
	float s;
	int digit = int(vtexCoord.x / ppd);
	switch (digit) {
		case 0: s = (vtexCoord.x / ppd - 0) * tpd; break;
		case 1: s = (vtexCoord.x / ppd - 1) * tpd; break;
		case 2: s = (vtexCoord.x / ppd - 2) * tpd; break;
		case 3: s = (vtexCoord.x / ppd - 3) * tpd; break;
		case 4: s = (vtexCoord.x / ppd - 4) * tpd; break;
		case 5: s = (vtexCoord.x / ppd - 5) * tpd; break;
	}

	vec2 st = vec2(s, vtexCoord.y);
	vec4 color = texture(colorMap, st);

	if (color.a < 0.5) discard;
	else fragColor = blue;
}
