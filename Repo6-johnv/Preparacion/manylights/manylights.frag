#version 330 core

in vec4 frontColor;
out vec4 fragColor;
in vec3 OBS;
in vec3 N;
uniform int NUM = 5;
uniform float decay = 6.0;
uniform vec3 boundingBoxMin;
uniform vec3 boundingBoxMax;
uniform mat4 modelViewMatrix;

//ANTERIOR EJERCICIO
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

void main()
{
    // Direcció del focus de llum (d'observador a vèrtex).
	vec3 V = normalize(vec3(0.0) - OBS);
	vec3 N2 = normalize(N);
    vec4 color = vec4(0.0);
    for (int i = 0; i < (NUM+1); ++i){
        for (int j = 0; j < (NUM+1); ++j){
            for (int k = 0; k < (NUM+1); ++k){
                vec3 pos = mix(boundingBoxMin, boundingBoxMax, vec3(i, j, k) / float(NUM));
                vec4 LeyeSpace = (modelViewMatrix * vec4(pos,1.0));
	            vec3 L = normalize(LeyeSpace.xyz - OBS);
                float d = length(LeyeSpace.xyz - OBS);
                color+= phong(L,N2,V)* exp(-decay * d);
            }
        }
    }
	// Direcció de l'observador (d'observador a vèrtex).
    fragColor = color;
}
