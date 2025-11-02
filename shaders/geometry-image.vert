#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

uniform sampler2D positionMap;
uniform sampler2D normalMap1;


uniform vec4 lightAmbient;
uniform vec4 lightDiffuse;
uniform vec4 lightSpecular;
uniform vec4 lightPosition;

uniform vec4 matAmbient;
uniform vec4 matDiffuse;
uniform vec4 matSpecular;
uniform float matShininess;


out vec4 frontColor;
out vec2 vtexCoord;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform int mode = 0;

void main()
{
    vtexCoord = texCoord;

    vec2 st = (vertex.xy  + 1.0)/2.0 * (0.996 - 0.004) + 0.004;
    vec4 geamC = texture(positionMap, st);
    vec4 normC = texture(normalMap1, st);

    vec3 N = normalize(normalMatrix * (normC*2.0 - 1.0).xyz);

    switch (mode) {
        case 0: frontColor = geamC; break;
        case 1: frontColor = geamC * N.z; break;
        case 2: frontColor = vec4(N, 1.0); break;
        case 3: 
        case 4: frontColor = vec4(normC.xyz, 1.0); break;
        default: 
            frontColor = vec4(1.0, 0.0, 0.0, 1.0); // Set to red to indicate an error
            break;
    }

    gl_Position = modelViewProjectionMatrix * geamC;
}
