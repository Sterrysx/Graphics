#version 330 core

const vec3 black = vec3(0, 0, 0);
const vec3 blue = vec3(0, 0, 1);
const vec3 green = vec3(0, 1, 0);
const vec3 cyan = vec3(0, 1, 1);
const vec3 red = vec3(1, 0, 0);
const vec3 magenta = vec3(1, 0, 1);
const vec3 yellow = vec3(1, 1, 0);
const vec3 white = vec3(1, 1, 1);

layout (triangles) in;
layout (triangle_strip, max_vertices = 190) out;

in vec3 vertColor[];

out vec3 geomColor;

uniform vec3 boundingBoxMin, boundingBoxMax;
uniform mat4 modelViewProjectionMatrix;
uniform bool scene;

void emitTriangle(vec4 p0, vec4 p1, vec4 p2) {
	gl_Position = p0;
	EmitVertex();
	gl_Position = p1;
	EmitVertex();
	gl_Position = p2;
	EmitVertex();
	EndPrimitive();
}

void emitBoundingBox() {
	vec3 m = boundingBoxMin;
	vec3 M = boundingBoxMax;
	vec4 xyz = modelViewProjectionMatrix * vec4(m.x, m.y, m.z, 1);
	vec4 xyZ = modelViewProjectionMatrix * vec4(m.x, m.y, M.z, 1);
	vec4 xYz = modelViewProjectionMatrix * vec4(m.x, M.y, m.z, 1);
	vec4 xYZ = modelViewProjectionMatrix * vec4(m.x, M.y, M.z, 1);
	vec4 Xyz = modelViewProjectionMatrix * vec4(M.x, m.y, m.z, 1);
	vec4 XyZ = modelViewProjectionMatrix * vec4(M.x, m.y, M.z, 1);
	vec4 XYz = modelViewProjectionMatrix * vec4(M.x, M.y, m.z, 1);
	vec4 XYZ = modelViewProjectionMatrix * vec4(M.x, M.y, M.z, 1);
	geomColor = white;
	emitTriangle(xYz, xYZ, xyz);
	emitTriangle(xyz, xYZ, xyZ);
	emitTriangle(xyz, Xyz, xYz);
	emitTriangle(xYz, Xyz, XYz);
	emitTriangle(Xyz, XyZ, XYz);
	emitTriangle(XYz, XyZ, XYZ);
	emitTriangle(xyZ, XyZ, xyz);
	emitTriangle(xyz, XyZ, Xyz);
}

void main(void) {
	for (int i = 0; i < 3; i++) {
		geomColor = vertColor[i];
		gl_Position = gl_in[i].gl_Position;
		EmitVertex();
	}
	
	EndPrimitive();
	
	if (gl_PrimitiveIDIn == 0 && scene) {
		emitBoundingBox();
	}
}
