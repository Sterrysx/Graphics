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
uniform vec4 lightAmbient, lightDiffuse, lightSpecular;
uniform vec4 ligthPosition; // COORdenadas del foco de luz
uniform vec4 matAmbient, matDiffuse, matSpecular;
uniform float matShininess;

vec4 phong(vec3 L, vec3 N, vec3 V){
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

void main()
{
    //Coordenadas del vertice (objeto al OBS)
    vec3 OBS = (modelViewMatrix* vec4(vertex,1.0)).xyz;

    //Direccion del foco de luz (del OBS a Vertex)
    vec3 L = normalize (ligthPosition.xyz - OBS);

    //Direccion normal del vertice
    vec3 N = normalize(normalMatrix * normal);
    //Direccion del OBS al verte
    vec3 V = normalize(vec3(0.0)-OBS);

    frontColor = phong(L,N,V);
    vtexCoord = texCoord;
    gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
}
