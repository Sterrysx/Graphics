#version 330 core

in vec4 frontColor;
out vec4 fragColor;
uniform int mode=2;
uniform vec4 matAmbient, matDiffuse, matSpecular;
uniform float matShininess;
uniform vec4 lightAmbient, lightDiffuse, lightSpecular, lightPosition;

in vec2 vtexCoord;
const vec4 negro= vec4 (0, 0, 0, 1.0);
const vec4 gris= vec4 (0.8, 0.8, 0.8, 1.0);;
const vec4 piel= vec4(1.0, 0.8, 0.6,1.0);
const vec4 blanco= vec4(1.0);

uniform mat3 normalMatrix;
uniform mat4 modelViewMatrix;

bool dentro (vec2 C,float r){
    return distance (vtexCoord ,C) <= r;
} 

void main()
{
    if (mode >= 0 && mode <= 2 && dentro(vec2(0.0,0.0),1.0) )fragColor = negro;
    if (mode >= 1 && mode <= 2 && dentro(vec2(0.0,0.0),1.0) )fragColor = vec4(sqrt(1 - vtexCoord.x*vtexCoord.x - vtexCoord.y*vtexCoord.y));
    if (mode == 2 && dentro(vec2(0.0,0.0),1.0) ){
        vec3 P = vec3(vtexCoord.x, vtexCoord.y, sqrt(1 - vtexCoord.x*vtexCoord.x - vtexCoord.y*vtexCoord.y));
		vec3 N = normalize(normalMatrix*P);
		P = (modelViewMatrix*vec4(P, 1.0)).xyz;
        vec3 L = normalize(lightPosition.xyz - P);
		vec3 R = normalize(2.0*dot(N, L)*N - L);
		float specular = dot(N, L) < 0 ? 0.0f : 1.0f;
		vec3 V = normalize(-P);
		fragColor = lightAmbient*matAmbient + lightDiffuse*matDiffuse*max(0.0f, dot(N, L)) + lightSpecular*matSpecular*max(0.0f, pow(dot(R, V), matShininess))*specular;
    }

    else discard;
}
