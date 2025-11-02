#version 330 core

in vec3 P;
in vec3 N;

out vec4 fragColor;

uniform bool worldSpace;
uniform sampler2D sampler;
uniform mat4 modelViewMatrixInverse;

vec4 sampleSphereMap(sampler2D sampler, vec3 R) {
	float z = sqrt((R.z + 1.0) / 2.0);
	vec2 st = vec2((R.x / (2.0 * z) + 1.0) / 2.0, (R.y / (2.0 * z) + 1.0) / 2.0);

	return texture(sampler, st);
}

void main() {
	vec3 O;
	if (worldSpace) O = modelViewMatrixInverse[3].xyz;
	else O = vec3(0, 0, 0);
	vec3 V = normalize(P - O);
	vec3 R = reflect(V, N);
	fragColor = sampleSphereMap(sampler, R);
}
