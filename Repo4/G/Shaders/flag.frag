#version 330 core

const vec4 black = vec4(0.0, 0.0, 0.0, 1.0);
const vec4 red = vec4(1.0, 0.0, 0.0, 1.0);
const vec4 yellow = vec4(1.0, 1.0, 0.0, 1.0);
const vec4 green = vec4(0.0, 1.0, 0.0, 1.0);
const vec4 cyan = vec4(0.0, 1.0, 1.0, 1.0);
const vec4 blue = vec4(0.0, 0.0, 1.0, 1.0);
const vec4 magenta = vec4(1.0, 0.0, 1.0, 1.0);
const vec4 white = vec4(1.0, 1.0, 1.0, 1.0);

in vec2 vtexCoord;

out vec4 fragColor;

// -2 <= x <= 2
// -1.5 <= y <= 1.5

bool circle(vec2 xy, vec2 center, float radius) {
	return distance(xy, center) <= radius;
}

bool rectangle(vec2 xy, vec2 center, float halfWidth, float halfHeight) {
	return distance(xy.x, center.x) <= halfWidth &&
	       distance(xy.y, center.y) <= halfHeight;
}

void main() {
	vec2 xy = vec2(4.0 * vtexCoord.x - 2.0, 3.0 * vtexCoord.y - 1.5);
	if (circle(xy, vec2(0.75, 0.0), 0.75)) fragColor = white;
	else if (circle(xy, vec2(-0.75, 0.0), 1.0) &&
	       ! circle(xy, vec2(-0.25, 0.0), 0.9)) fragColor = white;
	else if (rectangle(xy, vec2(0.0), 2.0, 1.5)) fragColor = red;
	else discard;
}
