#version 330 core

const vec3 red = vec3(1, 0, 0);
const vec3 yellow = vec3(1, 1, 0);
const vec3 green = vec3(0, 1, 0);
const vec3 cyan = vec3(0, 1, 1);
const vec3 blue = vec3(0, 0, 1);

layout (location = 0) in vec3 vertex;

out vec4 frontColor;

uniform mat4 modelViewProjectionMatrix;
uniform vec3 boundingBoxMin;
uniform vec3 boundingBoxMax;

vec3 gradient(vec3 vertex) {
	float height = boundingBoxMax.y - boundingBoxMin.y;
	float y = (vertex.y - boundingBoxMin.y) / height;
	float f = fract(4.0 * y);
	
	// n / 4 <= y < (n + 1) / 4 =>
	// n <= 4 * y < n + 1 =>
	// 0 <= fract(4 * y) < 1
	if      (y < 0.25) return mix(red, yellow, f);
	else if (y < 0.50) return mix(yellow, green, f);
	else if (y < 0.75) return mix(green, cyan, f);
	else if (y < 1.00) return mix(cyan, blue, f);
	else return blue;
	
	/*
	if      (y < 0.25) return vec3(1, y / 0.25, 0);
	else if (y < 0.50) return vec3(1 - (y - 0.25) / 0.25, 1, 0);
	else if (y < 0.75) return vec3(0, 1, (y - 0.5) / 0.25);
	else               return vec3(0, 1 - (y - 0.75) / 0.25, 1);
	*/
}

void main() {
	frontColor = vec4(gradient(vertex), 1.0);
	gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
}
