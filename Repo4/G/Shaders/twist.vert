#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 2) in vec3 color;

out vec4 frontColor;

uniform mat4 modelViewProjectionMatrix;
uniform float time;

vec3 twist(vec3 vertex) {
	float angle = 0.4 * vertex.y * sin(time);
	float c = cos(angle);
	float s = sin(angle);
	mat3 rotation = mat3(c, 0.0, -s, 0.0, 1.0, 0.0, s, 0.0, c);
	return rotation * vertex;
}

void main() {
	frontColor = vec4(color, 1.0);
	gl_Position = modelViewProjectionMatrix * vec4(twist(vertex), 1.0);
}
