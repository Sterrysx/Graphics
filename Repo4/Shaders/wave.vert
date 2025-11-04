#version 330 core

const float pi = 3.141592;

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;

out vec4 frontColor;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform float time;
uniform float amp = 0.5;
uniform float freq = 0.25;

vec3 wave(vec3 vertex) {
	float angle = amp * sin(2.0 * pi * freq * time + vertex.y);
	float c = cos(angle);
	float s = sin(angle);
	mat3 rotation = mat3(1.0, 0.0, 0.0, 0.0, c, s, 0.0, -s, c);
	return rotation * vertex;
}

void main() {
	vec3 N = normalize(normalMatrix * normal);
	frontColor = vec4(color * N.z, 1.0);
	gl_Position = modelViewProjectionMatrix * vec4(wave(vertex), 1.0);
}
