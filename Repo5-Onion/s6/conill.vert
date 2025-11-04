#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;
out vec2 vtexCoord;

uniform mat4 modelMatrix;
uniform mat4 viewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 modelViewMatrix;
uniform mat4 modelViewProjectionMatrix;

uniform mat4 modelMatrixInverse;
uniform mat4 viewMatrixInverse;
uniform mat4 projectionMatrixInverse;
uniform mat4 modelViewMatrixInverse;
uniform mat4 modelViewProjectionMatrixInverse;

uniform mat3 normalMatrix;

uniform vec4 lightAmbient; // similar a gl_LightSource[0].ambient
uniform vec4 lightDiffuse; // similar a gl_LightSource[0].diffuse
uniform vec4 lightSpecular; // similar a gl_LightSource[0].specular
uniform vec4 lightPosition; // similar a gl_LightSource[0].position
// (sempre estarà en eye space)
uniform vec4 matAmbient; // similar a gl_FrontMaterial.ambient
uniform vec4 matDiffuse; // similar a gl_FrontMaterial.diffuse
uniform vec4 matSpecular; // similar a gl_FrontMaterial.specular
uniform float matShininess; // similar a gl_FrontMaterial.shininess


uniform sampler2D positionMap;
uniform sampler2D normalMap1;

uniform int mode = 3;

void main()
{
    vec3 N = normalize(normalMatrix * normal);
    
    vec2 st = ((vertex.xy + vec2(1,1)) / 2) * (0.996-0.004) + vec2(0.004);
    vtexCoord = st;

    vec3 pt = texture(positionMap, st).xyz;
    vec3 nt = texture(normalMap1, st).xyz;
    nt = nt*2 - vec3(1.);
    nt = normalize(normalMatrix * nt);
    if(mode == 0)
    {
        frontColor = vec4(pt,1.0);
    }
    else if(mode == 1)
    {
        frontColor = vec4(pt,1.0) * nt.z;
    }
    else if(mode == 2)
    {
        vec3 N = nt;
        vec3 Position = (modelViewMatrix * vec4(pt.xyz,1)).xyz;
        vec3 V = normalize(vec3(0,0,0) -Position); //posicio del observador es 0,0,0
        vec3 L = normalize(vec3(lightPosition.xyz - Position));
        vec3 R = normalize(2 * dot(N,L) * N - L);
        float NdotL = max(0,dot(N,L));
        float RdotV = max(0,dot(R,V));
        RdotV = pow(RdotV,matShininess);

        if(NdotL > 0) frontColor = matAmbient*lightAmbient + matDiffuse*lightDiffuse*NdotL + matSpecular*lightSpecular*RdotV;
        else frontColor = matAmbient*lightAmbient + matDiffuse*lightDiffuse*NdotL;
    }
    else if(mode == 3)
    {
        vec3 N = nt;
        vec3 Position = (modelViewMatrix * vec4(pt.xyz,1)).xyz;
        vec3 V = normalize(vec3(0,0,0) -Position); //posicio del observador es 0,0,0
        vec3 L = normalize(vec3(lightPosition.xyz - Position));
        vec3 R = normalize(2 * dot(N,L) * N - L);
        float NdotL = max(0,dot(N,L));
        float RdotV = max(0,dot(R,V));
        RdotV = pow(RdotV,matShininess);

        if(NdotL > 0) frontColor = matAmbient*lightAmbient + vec4(pt,1.)*lightDiffuse*NdotL + matSpecular*lightSpecular*RdotV;
        else frontColor = matAmbient*lightAmbient + vec4(pt,1.)*lightDiffuse*NdotL;
    }
    

    gl_Position = modelViewProjectionMatrix * vec4(pt, 1.0);
}
