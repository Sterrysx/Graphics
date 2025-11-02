#version 330 core

in vec2 vs_texturePosition;

out vec4 fragColor;

uniform int mode = 2;
uniform vec4 matAmbient, matDiffuse, matSpecular;
uniform float matShininess;
uniform vec4 lightAmbient, lightDiffuse, lightSpecular, lightPosition;
uniform mat4 modelViewMatrix;
uniform mat3 normalMatrix;

bool circle(vec2 xy, vec2 center, float radius) {
	return distance(xy, center) <= radius;
}

vec4 phong(vec3 L, vec3 N, vec3 V) {
	vec4 ambient = matAmbient * lightAmbient;
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

	return ambient + diffuse + specular;
}

void main() {
	vec2 st = vs_texturePosition * 2 - 1;
	
	if (mode >= 0) {
		if (circle(st, vec2(0), 1)) fragColor = vec4(0);
		else discard;
		
		if (mode >= 1) {
			vec3 P = vec3(st, sqrt(1 - st.s * st.s - st.t * st.t));
			vec3 N = P;
			fragColor = vec4(N.zzz, 1);
		
			if (mode >= 2) {
				P =  (modelViewMatrix * vec4(P, 1)).xyz;
				N = normalize(normalMatrix * N);
				vec3 L = normalize(lightPosition.xyz -  P);
				vec3 V = normalize(vec3(0.0) - P);
				fragColor = phong(L, N, V);
			}
		}
	}
}
