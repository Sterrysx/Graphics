#version 330 core

layout(triangles) in;
layout(triangle_strip, max_vertices = 3) out;

in vec4 vertColor[];
in vec3 vertNormal[];

out vec4 geomColor;

uniform mat4 modelViewProjectionMatrix;
uniform float speed = 1.2;
uniform float time;

vec3 explosion(vec3 P, vec3 direction) {
	return P + speed * time * direction;
}

vec3 average(vec3 P1, vec3 P2, vec3 P3) {
	return (P1 + P2 + P3) / 3;
}

void main(void) {
	vec3 direction = average(vertNormal[0], vertNormal[1], vertNormal[2]);
	for (int i = 0; i < 3; i++) {
		geomColor = vertColor[i];
		gl_Position = modelViewProjectionMatrix *
			vec4(explosion(gl_in[i].gl_Position.xyz, direction), 1.0);
		EmitVertex();
	}
}
