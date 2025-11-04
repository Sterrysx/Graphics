#version 330 core

layout (location = 0) in vec3 position;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;

out vec4 vs_color;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform vec3 boundingBoxMin, boundingBoxMax;
uniform float t = 0.4;
uniform float scale = 4.0;

void main() {
	vec3 N = normalize(normalMatrix * normal);
	vs_color = vec4(color * N.z, 1);
	float c = mix(boundingBoxMin.y, boundingBoxMax.y, t);
	if (position.y < c) {
		vec3 S = vec3(1, scale, 1);
		gl_Position = modelViewProjectionMatrix * vec4(position * S, 1.0);
	} else {
		vec3 T = vec3(0, (scale - 1) * c, 0);
		gl_Position = modelViewProjectionMatrix * vec4(position + T, 1.0);
	}
}
