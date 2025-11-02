#version 330 core

const vec4 red = vec4(1, 0, 0, 1);
const vec4 yellow = vec4(1, 1, 0, 1);
const float areamax = 0.0005;

layout(triangles) in;
layout(triangle_strip, max_vertices = 3) out;

out vec4 geomColor;

uniform mat4 projectionMatrix;

float triangleArea(vec3 A, vec3 B, vec3 C) {
	return length((B - A) * (C - A));
}

void main(void) {
	float area = triangleArea(
		gl_in[0].gl_Position.xyz,
		gl_in[1].gl_Position.xyz,
		gl_in[2].gl_Position.xyz);
		
	geomColor = mix(red, yellow, area / areamax);
	
	for (int i = 0; i < 3; i++) {
		gl_Position = projectionMatrix * gl_in[i].gl_Position;
		EmitVertex();
	}
	
	EndPrimitive();
}
