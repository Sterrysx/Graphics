#version 330 core

in vec2 vtexCoord;

out vec4 fragColor;

const vec4 red = vec4(1.0, 0.0, 0.0, 1.0);
const vec4 white = vec4(1.0, 1.0, 1.0, 1.0);

uniform bool antialiasing = false;
uniform vec2 center = vec2(0.5, 0.5);
uniform float radius = 0.2;

void main() {
	float k, d = distance(vtexCoord, center);
	
	if (antialiasing) {
		float w = length(vec2(dFdx(d), dFdy(d)));
		k = smoothstep(radius - w, radius + w, d);
	} else {
		k = step(radius, d);
	}
	
	fragColor = mix(red, white, k);
}
