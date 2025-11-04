#version 330 core

layout(triangles) in;
layout(triangle_strip, max_vertices = 3) out;

in vec4 vertColor[];

out vec4 geomColor;

uniform mat4 modelViewProjectionMatrix;
uniform float time;

void main(void) {
	int n = int(100 * time);
	
	if (gl_PrimitiveIDIn < n) {
		for (int i = 0; i < 3; i++) {
			geomColor = vertColor[i];
			gl_Position = modelViewProjectionMatrix * gl_in[i].gl_Position;
			EmitVertex();
		}
	}
}
