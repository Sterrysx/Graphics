#version 330 core

in vec3 geomColor;

out vec4 fragColor;

void main() {
	fragColor = vec4(geomColor, 1);
}
