#version 330 core

in vec2 vtexCoord;

out vec4 fragColor;

uniform bool classic = false;

const vec4 red = vec4(1.0, 0.0, 0.0, 1.0);
const vec4 white = vec4(1.0, 1.0, 1.0, 1.0);
const vec2 center = vec2(0.5);
const float pi = 3.141592;

void main() {
	bool insideCircle = distance(vtexCoord, center) <= 0.2;
	bool isRed = insideCircle;
	
	if (! classic) {
		vec2 u = vtexCoord - center;
		float theta = atan(u.t, u.s);
		float phi = pi / 16;
		bool insideRay = mod(theta / phi + 0.5, 2) < 1;
		isRed = isRed || insideRay;
	}

	fragColor = isRed ? red : white;	
}
