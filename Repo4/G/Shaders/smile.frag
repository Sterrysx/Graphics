#version 330 core

const vec4 black = vec4(0);
const vec2 C1 = vec2(0.34, 0.65);
const vec2 C2 = vec2(0.66, 0.65);
const float r = 0.05;

in vec3 vs_normal;
in vec2 vs_texturePosition;

out vec4 fragColor;

uniform sampler2D colormap;

bool pointIsInsideCircle(vec2 point, vec2 center, float radius) {
	return distance(point, center) <= radius;
}

void main() {
	vec3 N = vs_normal;
	if (pointIsInsideCircle(vs_texturePosition, C1 - 0.1 * N.xy, r) ||
	    pointIsInsideCircle(vs_texturePosition, C2 - 0.1 * N.xy, r)) {
		fragColor = black;
	} else {
		fragColor = texture(colormap, vs_texturePosition);
	}
}
