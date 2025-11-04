#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;
out vec2 vtexCoord;
uniform int test = 0;

uniform mat4 projectionMatrix;
uniform mat3 normalMatrix;
uniform mat4 modelViewMatrix;
uniform vec3 boundingBoxMin; // cantonada mínima de la capsa englobant
uniform vec3 boundingBoxMax; // cantonada màxima de la capsa englobant
uniform vec2 mousePosition;

uniform float radius = 300;
uniform vec2 viewport;

vec2 getMousePositionWindowSpace() {
    if(test == 0) return mousePosition;
    if(test == 1) return vec2(400,520);
    if(test == 2) return vec2(600,225);
    if(test == 3) return vec2(200,375);
    return vec2(400,300);
}

vec4 blanco = vec4(1.0);
vec4 rojo = vec4(1.0,0.0,0.0,1.0);

void main()
{
    vec4 P = modelViewMatrix * vec4(vertex,1.0);

    float diagonal = distance(boundingBoxMax,boundingBoxMax);
    diagonal = 0.03 * diagonal;
    
    mat4 translate = mat4(
        vec4(1.0, 0.0, 0.0, 0.0),
        vec4(0.0, 1.0, 0.0, 0.0),
        vec4(0.0, 0.0, 1.0, 0.0),
        vec4(0.0,  0.0,  diagonal,  1.0)
    );

    
    vec4 P_aux = translate * P;
    vec4 projected = projectionMatrix * P;
    vec3 ndc = projected.xyz / projected.w;
    vec2 P_window = (ndc.xy * 0.5 + 0.5) * viewport;
    float d = distance(P_window, getMousePositionWindowSpace());
    float t = smoothstep(0.85*radius, 0.05*radius, d); 

    vec4 colorMOUSE = mix(blanco, rojo, t);
    
    vec3 N = normalize(normalMatrix * normal);
    frontColor = colorMOUSE * N.z;
    vtexCoord = texCoord;
    gl_Position = projectionMatrix * P_aux;
}
