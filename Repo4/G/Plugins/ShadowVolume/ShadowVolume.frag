#version 330 core

const vec3 black = vec3(0, 0, 0);

in vec3 geomColor;

out vec3 fragColor;

uniform bool shadow;

void main() {
	fragColor = shadow ? black : geomColor; 
}
