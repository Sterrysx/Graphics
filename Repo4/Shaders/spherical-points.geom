#version 330 core

layout(triangles) in;
layout(triangle_strip, max_vertices = 24) out;

out vec2 geomTexturePosition;

uniform mat4 projectionMatrix;
uniform float side = 0.1;

vec3 average(vec3 A, vec3 B, vec3 C) {
	return (A + B + C) / 3;
}

void emitSquare(vec3 P, float d) {
	float r = d / 2;
	vec3 xy = P + vec3(-r, -r, 0);
	vec3 xY = P + vec3(-r,  r, 0);
	vec3 Yx = P + vec3( r, -r, 0);
	vec3 XY = P + vec3( r,  r, 0);

	geomTexturePosition = vec2(0, 0);
	gl_Position = projectionMatrix * vec4(xy, 1);
	EmitVertex();
	geomTexturePosition = vec2(0, 1);
	gl_Position = projectionMatrix * vec4(xY, 1);
	EmitVertex();
	geomTexturePosition = vec2(1, 0);
	gl_Position = projectionMatrix * vec4(Yx, 1);
	EmitVertex();
	geomTexturePosition = vec2(1, 1);
	gl_Position = projectionMatrix * vec4(XY, 1);
	EmitVertex();
	EndPrimitive();
}

void main(void) {
	emitSquare(gl_in[0].gl_Position.xyz, side);
}
