#version 330 core
				
layout(triangles) in;
layout(triangle_strip, max_vertices = 36) out;

in vec3 vertNormal[];

out vec3 geomNormal;
out vec3 geomPosition;

uniform mat4 modelViewProjectionMatrix;
uniform float d = 0.5;

void emitTriangleExtrusion(vec3 V0, vec3 V1, vec3 V2, vec3 N) {
	vec3 U0 = V0 + d * N;
	vec3 U1 = V1 + d * N;
	vec3 U2 = V2 + d * N;

	geomNormal = -N;
	geomPosition = V0;
	gl_Position = modelViewProjectionMatrix * vec4(V0, 1);
	EmitVertex();
	geomPosition = V1;
	gl_Position = modelViewProjectionMatrix * vec4(V1, 1);
	EmitVertex();
	geomPosition = V2;
	gl_Position = modelViewProjectionMatrix * vec4(V2, 1);
	EmitVertex();
	EndPrimitive();

	geomNormal =  normalize(cross(V1 - V0, U0 - V0));
	geomPosition = V0;
	gl_Position = modelViewProjectionMatrix * vec4(V0, 1);
	EmitVertex();
	geomPosition = V1;
	gl_Position = modelViewProjectionMatrix * vec4(V1, 1);
	EmitVertex();
	geomPosition = U0;
	gl_Position = modelViewProjectionMatrix * vec4(U0, 1);
	EmitVertex();
	geomPosition = U1;
	gl_Position = modelViewProjectionMatrix * vec4(U1, 1);
	EmitVertex();
	EndPrimitive();

	geomNormal =  normalize(cross(V0 - V2, U2 - V2));
	geomPosition = V2;
	gl_Position = modelViewProjectionMatrix * vec4(V2, 1);
	EmitVertex();
	geomPosition = V0;
	gl_Position = modelViewProjectionMatrix * vec4(V0, 1);
	EmitVertex();
	geomPosition = U2;
	gl_Position = modelViewProjectionMatrix * vec4(U2, 1);
	EmitVertex();
	geomPosition = U0;
	gl_Position = modelViewProjectionMatrix * vec4(U0, 1);
	EmitVertex();
	EndPrimitive();

	geomNormal =  normalize(cross(V2 - V1, U1 - V1));
	geomPosition = V1;
	gl_Position = modelViewProjectionMatrix * vec4(V1, 1);
	EmitVertex();
	geomPosition = V2;
	gl_Position = modelViewProjectionMatrix * vec4(V2, 1);
	EmitVertex();
	geomPosition = U1;
	gl_Position = modelViewProjectionMatrix * vec4(U1, 1);
	EmitVertex();
	geomPosition = U2;
	gl_Position = modelViewProjectionMatrix * vec4(U2, 1);
	EmitVertex();
	EndPrimitive();
}

vec3 average(vec3 P0, vec3 P1, vec3 P2) {
	return (P0 + P1 + P2) / 3;
}

void main(void) {
	//if (gl_PrimitiveIDIn > 0) return;
	vec3 normal = normalize(average(vertNormal[0], vertNormal[1], vertNormal[2]));		 
	emitTriangleExtrusion(
		gl_in[0].gl_Position.xyz,
		gl_in[1].gl_Position.xyz,
		gl_in[2].gl_Position.xyz,
		normal);
}
