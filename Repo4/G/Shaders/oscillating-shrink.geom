#version 330 core

const float pi = 3.141592;

layout(triangles) in;
layout(triangle_strip, max_vertices = 3) out;

in vec4 vertColor[];

out vec4 geomColor;

uniform mat4 modelViewProjectionMatrix;
uniform float time;
uniform float speed = 1;

void emitTriangle() {
	for (int i = 0; i < 3; i++) {
		geomColor = vertColor[i];
		gl_Position = modelViewProjectionMatrix * gl_in[i].gl_Position;
		EmitVertex();
	}
}

vec3 baricentre(vec3 A, vec3 B, vec3 C) {
	return (A + B + C) / 3;
}

void emitShrunkTriangle(float shrinkFactor) {
	vec3 centre = baricentre(
		gl_in[0].gl_Position.xyz,
		gl_in[1].gl_Position.xyz,
		gl_in[2].gl_Position.xyz);
	for (int i = 0; i < 3; i++) {
		vec3 direction = gl_in[i].gl_Position.xyz - centre;
		vec3 position = gl_in[i].gl_Position.xyz - direction * shrinkFactor;
		geomColor = vertColor[i];
		gl_Position = modelViewProjectionMatrix * vec4(position, 1.0);
		EmitVertex();
	}
}

void main(void) {
	float shrinkFactor = abs(sin(2 * pi * 0.5 * time * speed));
	if (gl_PrimitiveIDIn % 2 == int(time * speed) % 2) emitTriangle();
	else emitShrunkTriangle(shrinkFactor);
}
