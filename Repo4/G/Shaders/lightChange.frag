#version 330 core

const float pi = 3.141592;

in vec3 P;
in vec3 N;
in vec2 TP;

out vec4 fragColor;

uniform vec4 lightPosition, lightSpecular, matSpecular;
uniform float matShininess;
uniform float time;
uniform sampler2D sampler;

vec4 lightDiffuse() {
	if (int(time) % 2 == 0) return vec4(mix(0, 0.8, fract(time)));
	else return vec4(mix(0.8, 0, fract(time)));
}

vec4 matDiffuse(vec2 st) {
	int s = int(time) / 2;
	float x = (s / 3 % 4 + st.s) / 4.0;
	float y = (2 - s % 3 + st.t) / 3.0;
	return texture(sampler, vec2(x, y));
}

vec4 phong(vec3 L, vec3 N, vec3 V) {
	vec4 diffuse, specular;
	float NL = dot(N, L);

	if (NL > 0) {
		vec3 R = reflect(-L, N); // normalize(2.0 * dot(N, L) * N - L);
		float RV = max(0.0, dot(R, V));
		diffuse = matDiffuse(TP) * lightDiffuse() * NL;
		specular = matSpecular * lightSpecular * pow(RV, matShininess);
	} else {
		diffuse = vec4(0.0);
		specular = vec4(0.0);
	}

	return diffuse + specular;
}

void main() {
	vec3 N = normalize(N);
	vec3 V = normalize(vec3(0) - P);
	vec3 L = normalize(lightPosition.xyz - P);
	fragColor = phong(L, N, V);
}
