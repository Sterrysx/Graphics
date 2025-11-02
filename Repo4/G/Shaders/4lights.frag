#version 330 core

const vec3 red = vec3(1, 0, 0);
const vec3 yellow = vec3(1, 1, 0);
const vec3 green = vec3(0, 1, 0);
const vec3 blue = vec3(0, 0, 1);

in vec3 No;
in vec3 Vo;

uniform mat4 modelViewMatrixInverse;
uniform float time;
uniform bool rotate = true;

vec4 light(vec3 V, vec3 N, vec3 P, vec3 lightPos, vec3 lightColor) {
	const float shininess = 100.0;
	const float Kd = 0.5;
	N = normalize(N);
	vec3 L = normalize(lightPos-P);
	vec3 R = reflect(-L, N);
	float NdotL = max(0.0, dot(N, L));
	float RdotV = max(0.0, dot(R, V));
	float spec = pow(RdotV, shininess);
	return vec4(Kd * lightColor * NdotL + vec3(spec), 0.0);
}

void main() { 
	vec3 V = normalize((modelViewMatrixInverse * vec4(0, 0, 0, 1)).xyz - Vo);
	
	vec3 lightPos[4];
	vec3 lightColor[4];
	lightPos[0] = vec3(0, 10, 0);
	lightPos[1] = vec3(0, -10, 0);
	lightPos[2] = vec3(10, 0, 0);
	lightPos[3] = vec3(-10, 0, 0);
	lightColor[0] = green;
	lightColor[1] = yellow;
	lightColor[2] = blue;
	lightColor[3] = red;
	
	if (rotate) {
		float c = cos(time);
		float s = sin(time);
		mat3 rotation = mat3(c, s, 0.0, -s, c, 0.0, 0.0, 0.0, 1.0);
		for (int i = 0; i < 4; i++) {
			lightPos[i] = rotation * lightPos[i];
		}
	}

	gl_FragColor = vec4(0.0);
	for (int i = 0; i < 4; i++) {
		lightPos[i] = (modelViewMatrixInverse * vec4(lightPos[i], 1.0)).xyz;
		gl_FragColor += light(V, No, Vo, lightPos[i], lightColor[i]);
	}
}
