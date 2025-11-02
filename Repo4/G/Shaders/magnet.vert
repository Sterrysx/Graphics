#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;

out vec3 vs_color;

uniform mat4 modelViewProjectionMatrix;
uniform mat4 modelViewMatrixInverse;
uniform mat3 normalMatrix;
uniform vec4 lightPosition;
uniform float n = 4.0;

vec3 magnet(vec3 vertex) {
	vec3 light = (modelViewMatrixInverse * lightPosition).xyz;
	float d = distance(light, vertex);
	float w = clamp(1.0 / pow(d, n), 0, 1);
	return (1.0 - w) * vertex + w * light;
}

void main() {
	vec3 N = normalize(normalMatrix * normal);
	vs_color = N.zzz;
	gl_Position = modelViewProjectionMatrix * vec4(magnet(vertex), 1.0);
}
