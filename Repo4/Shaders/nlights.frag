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

vec4 phong(vec3 L, vec3 N, vec3 V, float diffuseFactor) {
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

	return diffuse * diffuseFactor + specular;
}

void main() {
	vec3 N = normalize(vs_normal);
	vec3 V = normalize(vec3(0) - vs_position);
	fragColor = vec4(0);
	for (int i = 0; i < n; i++) {
		float x = radius * cos(i * 2 * pi / n);
		float y = radius * sin(i * 2 * pi / n);
		vec3 L = normalize(vec3(x, y, 0) - vs_position);
		fragColor += phong(L, N, V, 1 / sqrt(n));
	}
}
