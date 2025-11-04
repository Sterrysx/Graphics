#version 330 core

const float pi = 3.141592;

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;

out vec4 frontColor;

uniform mat4 modelViewMatrix;
uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform vec3 boundingBoxMin, boundingBoxMax;
uniform float time;
uniform bool eyespace = true;

vec3 oscillation(vec3 vertex) {
	float y = eyespace ? (modelViewMatrix * vec4(vertex, 1.0)).y : vertex.y;
	float r = distance(boundingBoxMin, boundingBoxMax) / 2.0;
	float d = (r / 10.0) * y;
	return vertex + normal * d * sin(2.0 * pi * time);
}

void main() {
	frontColor = vec4(color, 1.0);
	gl_Position = modelViewProjectionMatrix * vec4(oscillation(vertex), 1.0);
}
