#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;
out vec2 vtexCoord;

uniform vec4 lightAmbient;
uniform vec4 lightDiffuse;
uniform vec4 lightSpecular;
uniform vec4 lightPosition;

uniform vec4 matAmbient;
uniform vec4 matDiffuse;
uniform vec4 matSpecular;
uniform float matShininess;


uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform mat4 modelViewMatrix;

void main()
{
    vec3 N = normalize(normalMatrix * normal);
    vec3 pos = vec3(modelViewMatrix * vec4(vertex, 1.0));
    vec3 V = normalize(-pos);
    vec3 L = normalize(vec3(lightPosition.xyz - pos));
    vec3 R = normalize(2 * dot(L, N) * N - L);

    vec4 ambient = lightAmbient * matAmbient;
    vec4 diffuse = lightDiffuse * matDiffuse * max(dot(N, L), 0.0);
    vec4 specular = lightSpecular * matSpecular * pow(max(dot(R, V), 0.0), matShininess);

    if (max(0.0,dot(N,L)) > 0) frontColor = ambient + diffuse + specular;
    else frontColor = ambient + diffuse;

    vtexCoord = texCoord;
    gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
}
