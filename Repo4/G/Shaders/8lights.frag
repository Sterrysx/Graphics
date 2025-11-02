#version 330 core

const float pi = 3.141592;

in vec3 vs_position;
in vec3 vs_normal;

out vec4 fragColor;

uniform int n = 4;
uniform float radius = 10;
uniform vec4 lightDiffuse, lightSpecular;
uniform vec4 matDiffuse, matSpecular;
uniform float matShininess;
uniform vec3 boundingBoxMin, boundingBoxMax;
uniform mat4 modelViewMatrix;

vec4 phong(vec3 L, vec3 N, vec3 V, float diffuseFactor) {
	vec4 diffuse;
	vec4 specular;
	float NL = dot(N, L);

	if (NL > 0) {
		vec3 R = reflect(-L, N);
		float RV = max(0.0, dot(R, V));
		diffuse = matDiffuse * lightDiffuse * NL;
		specular = matSpecular * lightSpecular * pow(RV, matShininess);
	} else {
		diffuse = vec4(0.0);
		specular = vec4(0.0);
	}

	return diffuse * diffuseFactor + specular;
}

void main() {
	vec3 N = normalize(vs_normal);
	vec3 V = normalize(vec3(0) - vs_position);
	vec3 C = (boundingBoxMin + boundingBoxMax) / 2;
	vec3 d = (boundingBoxMax - boundingBoxMin) / 2;
	fragColor = vec4(0);
	for (int i = -1; i < 2; i += 2) {
		for (int j = -1; j < 2; j += 2) {
			for (int k = -1; k < 2; k += 2) {
				vec3 P = (modelViewMatrix * vec4(C + d * vec3(i, j, k), 1)).xyz;
				vec3 L = normalize(P - vs_position);
				fragColor += phong(L, N, V, 0.5);
			}
		}
	}
}
