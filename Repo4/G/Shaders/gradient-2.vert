#version 330 core

const vec3 red = vec3(1, 0, 0);
const vec3 yellow = vec3(1, 1, 0);
const vec3 green = vec3(0, 1, 0);
const vec3 cyan = vec3(0, 1, 1);
const vec3 blue = vec3(0, 0, 1);

layout (location = 0) in vec3 vertex;

out vec4 frontColor;

uniform mat4 modelViewProjectionMatrix;

vec3 gradient(vec4 vertex) {
	float y = (vertex.y / vertex.w + 1.0) / 2.0;
	float f = fract(4.0 * y);
	
	if      (y < 0.00) return red;
	else if (y < 0.25) return mix(red, yellow, f);
	else if (y < 0.50) return mix(yellow, green, f);
	else if (y < 0.75) return mix(green, cyan, f);
	else if (y < 1.00) return mix(cyan, blue, f);
	else               return blue;
}

void main() {
	gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
	frontColor = vec4(gradient(gl_Position), 1.0);
}
