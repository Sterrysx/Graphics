#version 330 core

in vec2 st;
out vec4 fragColor;

uniform vec3 boundingBoxMax;

const vec4 taronja = vec4(1, 0.7, 0, 1);
const vec4 negre = vec4(0);

bool inside(vec2 p, float r) {
    return distance(st*vec2(4.0/3.0, 1.3), p) <= r;
}

vec4 printFons() {
	vec2 C = vec2(0.5, 0.5);
	float t = smoothstep(0.0, distance(C, boundingBoxMax.xy), distance(st, C));
	return mix(taronja, negre, t);
}

void main() {
	fragColor = printFons();
	if (inside(vec2(0.5, 0.75), 0.1) || inside(vec2(0.8, 0.75), 0.1)) return; 
	else if (inside(vec2(0.67, 0.65), 0.26) && !inside(vec2(0.67, 0.71), 0.26)) return; 
    else if (inside(vec2(0.675, 0.62), 0.4)) fragColor = negre; 
}