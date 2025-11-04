#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;

out vec4 frontColor;

uniform mat3 normalMatrix;
uniform mat4 modelViewProjectionMatrix;

vec3 projection(vec3 vertex, float radius) {
	return radius * normalize(vertex);
}

void main() {
	vec3 N = normalize(normalMatrix * normal);
	frontColor = vec4(color * N.z, 1.0);
	gl_Position = modelViewProjectionMatrix * vec4(projection(vertex, 1.0), 1.0);
}
