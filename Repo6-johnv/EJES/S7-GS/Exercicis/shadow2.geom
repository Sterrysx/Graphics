
#version 330 core
const vec4 black = vec4(0, 0, 0, 1);
const vec4 cyan = vec4(0, 1, 1, 1);

layout(triangles) in;
layout(triangle_strip, max_vertices = 36) out;

in vec4 vfrontColor[];
out vec4 gfrontColor;
uniform mat4 modelViewProjectionMatrix;
uniform vec3 boundingBoxMin, boundingBoxMax;

vec3 shadow(vec3 vertex) {
	return vec3(vertex.x, boundingBoxMin.y, vertex.z);
}

vec3 boundingBoxCenter() {
	return (boundingBoxMin + boundingBoxMax) / 2;
}

vec3 boundingBoxBase() {
	vec3 center = boundingBoxCenter();
	center.y = boundingBoxMin.y;
	return center;
}

void emitSquare(vec3 center, float r) {
	gl_Position = modelViewProjectionMatrix * vec4(center + vec3(-r, 0, +r), 1);
	EmitVertex();
	gl_Position = modelViewProjectionMatrix * vec4(center + vec3(-r, 0, -r), 1);
	EmitVertex();
	gl_Position = modelViewProjectionMatrix * vec4(center + vec3(+r, 0, +r), 1);
	EmitVertex();
	gl_Position = modelViewProjectionMatrix * vec4(center + vec3(+r, 0, -r), 1);
	EmitVertex();
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
	
	if (gl_PrimitiveIDIn == 0) {
		float squareLength = distance(boundingBoxMin, boundingBoxMax);
		vec3 squareCenter = boundingBoxBase() - vec3(0, 0.01, 0);
		gfrontColor = cyan;
		emitSquare(squareCenter, squareLength / 2);
	}
}

