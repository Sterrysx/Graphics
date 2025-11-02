#version 330 core

const float pi = 3.141592;

layout (location = 0) in vec3 position;
layout (location = 1) in vec3 normal;
layout (location = 3) in vec3 texturePosition;

out vec4 frontColor;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform float time;
uniform float amplitude = 0.1;
uniform float freq = 1.0;

vec3 animation(vec3 P, vec3 normal, float s) {
	float phi = 2.0 * pi * s;
	return P + normal * amplitude * sin(2.0 * pi  * freq * time + phi);
}

void main() {
	vec3 N = normalize(normalMatrix * normal);
	frontColor = vec4(N.z, N.z, N.z, 1.0);
	gl_Position = modelViewProjectionMatrix * vec4(animation(position, normal, texturePosition.s), 1.0);
}
