#version 330 core

in vec3 vs_color;

out vec3 fragColor;

void main() {
	fragColor = vs_color;
}
