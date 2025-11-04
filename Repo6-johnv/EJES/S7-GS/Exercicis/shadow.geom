#version 330 core

const vec4 black = vec4(0, 0, 0, 1);

layout(triangles) in;
layout(triangle_strip, max_vertices = 6) out;
       

in vec4 vfrontColor[];
out vec4 gfrontColor;

uniform mat4 modelViewProjectionMatrix;
uniform vec3 boundingBoxMin;

vec3 shadow(vec3 vertex) {
	return vec3(vertex.x, boundingBoxMin.y, vertex.z);
}

void main(void) {
	for (int i = 0; i < 3; i++) {
		gfrontColor = vfrontColor[i];
		gl_Position = modelViewProjectionMatrix *
			gl_in[i].gl_Position;
		EmitVertex();
	}
	
	EndPrimitive();
	
	for (int i = 0; i < 3; i++) {
		gfrontColor = black;
		gl_Position = modelViewProjectionMatrix *
			vec4(shadow(gl_in[i].gl_Position.xyz), 1.0);
		EmitVertex();
	}
	
	EndPrimitive();
}

