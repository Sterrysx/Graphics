#version 330 core

const float pi = 3.141592;

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;

out vec4 frontColor;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform float time;
uniform float amplitude = 0.1;
uniform float freq = 1.0;

vec3 animation(vec3 vertex, vec3 normal) {
	return vertex + normal * amplitude * sin(2.0 * pi * freq * time);
}

void main() {
	vec3 N = normalize(normalMatrix * normal);
	frontColor = vec4(N.z, N.z, N.z, 1.0);
	gl_Position = modelViewProjectionMatrix * vec4(animation(vertex, normal), 1.0);
}
