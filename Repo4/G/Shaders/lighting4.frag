#version 330 core

in vec3 V_obs; // Coordenades del vèrtex (observador).
in vec3 N_ver; // Direcció de la normal del vèrtex (vèrtex).

out vec4 fragColor;

uniform vec4 lightAmbient, lightDiffuse, lightSpecular;
uniform vec4 lightPosition; // Coordenades del focus de llum (observador).
uniform vec4 matAmbient, matDiffuse, matSpecular;
uniform float matShininess;

vec4 phong(vec3 L, vec3 N, vec3 V) {
	vec4 ambient = matAmbient * lightAmbient;
	vec4 diffuse;
	vec4 specular;
	float NL = dot(N, L);

	if (NL > 0) {
		vec3 R = reflect(-L, N); // normalize(2.0 * dot(N, L) * N - L);
		float RV = max(0.0, dot(R, V));
		diffuse = matDiffuse * lightDiffuse * NL;
		specular = matSpecular * lightSpecular * pow(RV, matShininess);
	} else {
		diffuse = vec4(0.0);
		specular = vec4(0.0);
	}

	return ambient + diffuse + specular;
}

void main() {
	// Direcció del focus de llum (d'observador a vèrtex).
	vec3 L = normalize(lightPosition.xyz - V_obs);
	vec3 N = normalize(N_ver);
	// Direcció de l'observador (d'observador a vèrtex).
	vec3 V = normalize(vec3(0.0) - V_obs);
	fragColor = phong(L, N, V);
}
