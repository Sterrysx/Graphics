#version 330 core

const vec3 blue = vec3(0, 0, 1);
const vec3 cyan = vec3(0, 1, 1);

in vec3 vs_position;

out vec4 fragColor;

uniform vec3 origin = vec3(1, 0, 0), axis = vec3(0, 1, 0);
uniform float slice = 0.1;

//uniform vec3 origin = vec3(0, 0, 0), axis = vec3(0, 0, 1);
//uniform float slice = 0.05;

float lineDistance(vec3 linePoint, vec3 direction, vec3 point) {
	return length(cross(linePoint - point, direction)) / length(direction);
}

void main() {
	float d = lineDistance(origin, normalize(axis), vs_position);
	fragColor = vec4(mix(cyan, blue, step(slice, mod(d, 2 * slice))), 1);
}
