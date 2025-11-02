#version 330 core

// Coordenades del vèrtex (objecte).
layout (location = 0) in vec3 vertex;
// Direcció de la normal del vèrtex (objecte).
layout (location = 1) in vec3 normal;

out vec4 frontColor;

uniform mat4 modelViewMatrix;
uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform vec4 lightAmbient, lightDiffuse, lightSpecular;
uniform vec4 lightPosition; // Coordenades del focus de llum (observador).
uniform vec4 matAmbient, matDiffuse, matSpecular;
uniform float matShininess;

vec4 phong(vec3 L, vec3 N, vec3 V) {
	vec4 ambient = matAmbient * lightAmbient;
	vec4 diffuse;
	vec4 specular;
	float NL = dot(N, L);

	if (NL > 0.0) {
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
	// Coordenades del vèrtex (d'objecte a observador).
	vec3 V_obs = (modelViewMatrix * vec4(vertex, 1.0)).xyz;
	// Direcció del focus de llum (de observador a vèrtex).
	vec3 L = normalize(lightPosition.xyz - V_obs);
	// Direcció de la normal del vèrtex (vèrtex).
	vec3 N = normalize(normalMatrix * normal);
	// Direcció de l'observador (de observador a vèrtex).
	vec3 V = normalize(vec3(0.0) - V_obs);
	frontColor = phong(L, N, V);
	gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
}
