#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;

out vec4 frontColor;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform float time;
uniform float scale = 8.0;

float triangleWave(float x) {
	return abs(mod(x, 2.0) - 1.0);
}

vec3 bounce(vec3 vertex) {
	vec3 t = vec3(triangleWave(time / 1.618), triangleWave(time), 0.0);
	vec3 T0 = vec3(-1.0, -1.0, 0.0);
	vec3 V = vec3(2.0, 2.0, 0.0);
	vec3 T = scale * (T0 + V * t);
	return (T + vertex) / scale;
}

void main() {
	vec3 N = normalize(normalMatrix * normal);
	frontColor = vec4(0.3 * N.z, 0.3 * N.z, 0.9 * N.z, 1.0);
	gl_Position = modelViewProjectionMatrix * vec4(bounce(vertex), 1.0);
}
