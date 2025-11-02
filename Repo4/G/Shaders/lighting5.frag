#version 330 core

in vec3 Vo; // Coordenades del vèrtex (objecte o observador).
in vec3 No; // Direcció de la normal del vèrtex (objecte o vèrtex).

out vec4 fragColor;

uniform mat4 modelViewMatrixInverse;
uniform vec4 lightAmbient, lightDiffuse, lightSpecular;
uniform vec4 lightPosition; // Coordenades del focus de llum (observador).
uniform vec4 matAmbient, matDiffuse, matSpecular;
uniform float matShininess;
uniform bool world;

vec4 light(vec3 N, vec3 V, vec3 L) {
	N = normalize(N);
	V = normalize(V);
	L = normalize(L);
	vec3 R = reflect(-L, N); // normalize(2 * dot(N, L) * N - L);
	float NdotL = max(0.0, dot(N, L));
	float RdotV = max(0.0, dot(R, V));
	float Idiff = NdotL;
	float Ispec = 0.0;
	if (NdotL > 0.0) Ispec = pow(RdotV, matShininess);
	return matAmbient * lightAmbient +
	       matDiffuse * lightDiffuse * Idiff +
	       matSpecular * lightSpecular * Ispec;
}

void main() {
	vec3 L, N, V;
	
	if (world) {
		// Direcció del focus de llum (d'observador a objecte).
		L = normalize((modelViewMatrixInverse * lightPosition).xyz - Vo);
		N = normalize(No);
		// Direcció de l'observador (d'observador a objecte).
		V = normalize((modelViewMatrixInverse * vec4(vec3(0.0), 1.0)).xyz - Vo);
	} else {
		// Direcció del focus de llum (d'observador a vèrtex).
		L = normalize(lightPosition.xyz - Vo);
		N = normalize(No);
		// Direcció de l'observador (d'observador a vèrtex).
		V = normalize(vec3(0.0) - Vo);
	}
	
	fragColor = light(N, V, L);
}
