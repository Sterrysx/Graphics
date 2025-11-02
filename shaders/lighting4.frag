#version 330 core

in vec4 frontColor;
in vec3 N;
in vec3 P;

out vec4 fragColor;


uniform vec4 lightAmbient;
uniform vec4 lightDiffuse;
uniform vec4 lightSpecular;
uniform vec4 lightPosition;

uniform vec4 matAmbient;
uniform vec4 matDiffuse;
uniform vec4 matSpecular;
uniform float matShininess;

void main()
{
    vec3 L = normalize(lightPosition.xyz - P);
    vec3 V = normalize(-P);
    vec3 R = normalize(2 * dot(N,L)*N - L);

    float NdotL = max(0.0, dot(N,L));
    float RdotV = max(0.0, dot(R,V));
    RdotV = pow(RdotV, matShininess);

    vec4 ambient = lightAmbient*matAmbient;
    vec4 diffuse = lightDiffuse*matDiffuse*NdotL;
    vec4 specular = lightSpecular*matSpecular*RdotV;

    if(NdotL > 0) fragColor = ambient + diffuse + specular;
    else fragColor = ambient + diffuse;
}
