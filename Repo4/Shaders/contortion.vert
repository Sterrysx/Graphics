#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 2) in vec3 color;

out vec4 frontColor;

uniform mat4 modelViewProjectionMatrix;
uniform float time;

vec3 contortion(vec3 vertex) {
	float angle = vertex.y < 0.5 ? 0.0 : (vertex.y - 0.5) * sin(time);
	float c = cos(angle);
	float s = sin(angle);
	vec3 offset = vec3(0.0, 1.0, 0.0);
	mat3 rotation = mat3(1.0, 0.0, 0.0, 0.0, c, s, 0.0, -s, c);
	return rotation * (vertex - offset) + offset;
}

void main() {
	frontColor = vec4(color, 1.0);
	gl_Position = modelViewProjectionMatrix * vec4(contortion(vertex), 1.0);
}
