#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;
out vec2 vtexCoord;

uniform mat4 modelViewMatrix;
uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

uniform int mode = 2;
uniform sampler2D positionMap;
uniform sampler2D normalMap1;

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
    vec2 st = texCoord - vec2(0.496);
    vec3 P = texture(positionMap, st).rgb; 

    vec3 N_obj = texture(normalMap1, st).rgb * 2.0 - 1.0;
    vec3 N = normalize(normalMatrix * N_obj);


    if (mode <1) frontColor = vec4(P,1.0);
    else if (mode < 2)  frontColor = vec4(P,1.0) * N.z;
    else if (mode < 3) {
        //Coordenadas del vertice (del objeto al observador)
    vec3 OBS = (modelViewMatrix * vec4(P,1.0)).xyz;

    // Dirección de la normal del vèrtex (d'objecte a vèrtex).
    N = normalize(normalMatrix * normal);
    vec3 L = normalize(lightPosition.xyz - OBS);
    vec3 V = normalize(vec3(0.0) - OBS);

        frontColor = phong(L,N,V);
    }
    else if (mode == 3) {
    vec3 OBS = (modelViewMatrix * vec4(P, 1.0)).xyz;
    vec3 L = normalize(lightPosition.xyz - OBS);
    vec3 V = normalize(-OBS);

    vec4 ambient = matAmbient * lightAmbient;
    vec4 diffuse = vec4(0.0), specular = vec4(0.0);
    float NL = dot(N, L);
    if (NL > 0.0) {
        vec3 R = reflect(-L, N);
        float RV = max(0.0, dot(R, V));
        diffuse = vec4(P, 1.0) * lightDiffuse * NL;  // P com a matDiffuse
        specular = matSpecular * lightSpecular * pow(RV, matShininess);
    }
    frontColor = ambient + diffuse + specular;
}

    vtexCoord = texCoord;
    gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
}
