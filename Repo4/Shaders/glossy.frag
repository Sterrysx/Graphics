#version 330 core
in vec3 P;
in vec3 N;
uniform sampler2D glossy;
uniform int r = 5;
uniform float width = 512;
uniform float height = 512;

vec4 sampleTexture(sampler2D sampler, vec2 st, int r) {
	vec4 color = vec4(0);
	int n = 2 * r + 1;
	for (int i = -r; i <= r; i++) {
		for (int j = -r; j <= r; j++) {
			color += texture2D(sampler, st + vec2(i / width, j / height));
		}
	}
	return color / n / n;
	return texture2D(sampler, st);
}

vec4 sampleSphereMap(sampler2D sampler, vec3 R) {
	float z = sqrt((R.z + 1.0) / 2.0);
	vec2 st = vec2((R.x / (2.0 * z) + 1.0) / 2.0, (R.y / (2.0 * z) + 1.0) / 2.0);
	return sampleTexture(sampler, st, r);
}

void main() {
	vec3 obs = vec3(0.0);
	vec3 I = normalize(P - obs);
	vec3 R = reflect(I, N);
	gl_FragColor = sampleSphereMap(glossy, R);
}
