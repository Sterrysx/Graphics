#version 330 core

in vec3 vertColor;

out vec4 fragColor;

uniform vec2 mousePosition;

void main() {
	float d = distance(mousePosition, gl_FragCoord.xy);
	if (d > 100) fragColor = vec4(vertColor, 1);
	else fragColor =  vec4(1 - vertColor, 1);
}
