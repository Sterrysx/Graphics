#version 330 core

const vec4 S = 0.3 * vec4(0, 1, -1, 0);
const vec4 T = 0.3 * vec4(-2, -1, 1, 0);
const vec4 redish = vec4(0.5, 0.2, 0.2, 1.0);
const vec4 white = vec4(1.0);

in vec4 V;
in vec3 N;

out vec4 fragColor;

uniform mat4 modelViewMatrix;
uniform mat3 normalMatrix;
uniform sampler2D noise;

vec4 shading(vec3 N, vec3 Pos, vec4 diffuse) {
	vec3 lightPos = vec3(0.0, 0.0, 2.0);
	vec3 L = normalize(lightPos - Pos);
	vec3 V = normalize(-Pos);
	vec3 R = reflect(-L, N);
	float NdotL = max(0.0, dot(N, L));
	float RdotV = max(0.0, dot(R, V));
	float Ispec = pow(RdotV, 20.0);
	return diffuse * NdotL + Ispec;
}

void main() {
	vec2 st = vec2(dot(S, V), dot(T, V));
	float v = texture(noise, st).r;
	float f = fract(2.0 * v);
	vec4 diffuse = v < 0.5 ? mix(white, redish, f) : mix(redish, white, f);
	vec3 Vobs = (modelViewMatrix * V).xyz;
	vec3 Nobs = normalize(normalMatrix * N);
	fragColor = shading(Nobs, Vobs, diffuse);
}
