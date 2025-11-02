#version 330 core

const vec4 white = vec4(1, 1, 1, 1);

layout(triangles) in;
layout(triangle_strip, max_vertices = 50) out;

in vec3 vertNormal[];
in vec4 vertColor[];

out vec4 geomColor;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform float disp = 0.05;

vec3 normal(vec3 A, vec3 B, vec3 C) {
	vec3 AB = normalize(B - A);
	vec3 AC = normalize(C - A);
	return normalize(normalMatrix * normalize(cross(AB, AC)));
}

vec3 average(vec3 A, vec3 B, vec3 C) {
	return (A + B + C) / 3;
}

void emitSpikedTriangle(vec3 V0, vec3 V1, vec3 V2, vec4 C0, vec4 C1, vec4 C2, vec3 N) {
	vec3 V3 = average(V0, V1, V2) + N * disp;
	float f0 = normal(V0, V1, V3).z;
	float f1 = normal(V1, V2, V3).z;
	float f2 = normal(V2, V0, V3).z;
	
	geomColor = C0 * f0;
	gl_Position = modelViewProjectionMatrix * vec4(V0, 1.0);
	EmitVertex();
	geomColor = C1 * f0;
	gl_Position = modelViewProjectionMatrix * vec4(V1, 1.0);
	EmitVertex();
	geomColor = white * f0;
	gl_Position = modelViewProjectionMatrix * vec4(V3, 1.0);
	EmitVertex();
	EndPrimitive();

	geomColor = C1 * f1;
	gl_Position = modelViewProjectionMatrix * vec4(V1, 1.0);
	EmitVertex();
	geomColor = C2 * f1;
	gl_Position = modelViewProjectionMatrix * vec4(V2, 1.0);
	EmitVertex();
	geomColor = white * f1;
	gl_Position = modelViewProjectionMatrix * vec4(V3, 1.0);
	EmitVertex();
	EndPrimitive();
	
	geomColor = C2 * f2;
	gl_Position = modelViewProjectionMatrix * vec4(V2, 1.0);
	EmitVertex();
	geomColor = C0 * f2;
	gl_Position = modelViewProjectionMatrix * vec4(V0, 1.0);
	EmitVertex();
	geomColor = white * f2;
	gl_Position = modelViewProjectionMatrix * vec4(V3, 1.0);
	EmitVertex();
	EndPrimitive();
}

void main(void) {
	//if (gl_PrimitiveIDIn > 0) return;
	vec3 N = normalize(average(vertNormal[0], vertNormal[1], vertNormal[2]));
	emitSpikedTriangle(
		gl_in[0].gl_Position.xyz,
		gl_in[1].gl_Position.xyz,
		gl_in[2].gl_Position.xyz,
		vertColor[0], vertColor[1], vertColor[2],
		N);
}
