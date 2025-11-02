#version 330 core

const vec3 red = vec3(1, 0, 0);
const vec3 green = vec3(0, 1, 0);
const vec3 blue = vec3(0, 0, 1);

layout (triangles) in;
layout (triangle_strip, max_vertices = 19) out;

in vec3 vertColor[];

out vec3 geomColor;

uniform vec3 boundingBoxMin, boundingBoxMax;
uniform mat4 modelViewProjectionMatrix;
uniform mat4 modelViewMatrix;

void emitBoundingBoxVertices() {
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
	geomColor = red;
	gl_Position = xyZ;
	EmitVertex();
	gl_Position = xYZ;
	EmitVertex();
	gl_Position = xyz;
	EmitVertex();
	gl_Position = xYz;
	EmitVertex();
	EndPrimitive();
	geomColor = blue;
	gl_Position = xyz;
	EmitVertex();
	gl_Position = xYz;
	EmitVertex();
	gl_Position = Xyz;
	EmitVertex();
	gl_Position = XYz;
	EmitVertex();
	EndPrimitive();
	geomColor = red;
	gl_Position = Xyz;
	EmitVertex();
	gl_Position = XYz;
	EmitVertex();
	gl_Position = XyZ;
	EmitVertex();
	gl_Position = XYZ;
	EmitVertex();
	EndPrimitive();
	geomColor = green;
	gl_Position = xyZ;
	EmitVertex();
	gl_Position = xyz;
	EmitVertex();
	gl_Position = XyZ;
	EmitVertex();
	gl_Position = Xyz;
	EmitVertex();
	EndPrimitive();
}

bool cameraIsInsideBoundingBox() {
	vec4 m = modelViewMatrix * vec4(boundingBoxMin, 1);
	vec4 M = modelViewMatrix * vec4(boundingBoxMax, 1);
	return m.x < 0 && 0 < M.x && m.y < 0 && 0 < M.y && m.z < 0 && 0 < M.z;   
}

void main(void) {
	for (int i = 0; i < 3; i++) {
		geomColor = (cameraIsInsideBoundingBox() ? 2 : 1) * vertColor[i];
		gl_Position = gl_in[i].gl_Position;
		EmitVertex();
	}
	
	EndPrimitive();
	
	if (gl_PrimitiveIDIn == 0) {
		emitBoundingBoxVertices();
	}
}
