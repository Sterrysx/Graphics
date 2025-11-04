#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;

out vec4 frontColor;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform float time;

vec4 zoom(vec4 position) {
	float scale = 0.5 + abs(sin(time));
	return vec4(position.xy * scale, position.zw);
}

void main() {
	vec3 N = normalize(normalMatrix * normal);
	frontColor = vec4(color * N.z, 1.0);
	gl_Position = zoom(modelViewProjectionMatrix * vec4(vertex, 1.0));
}
