#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;
out vec2 vtexCoord;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

uniform sampler2D positionMap;
uniform sampler2D normalMap1;
uniform int mode = 1;

void main()
{
    vtexCoord = texCoord;

    vec2 st = (vertex.xy  + 1.0)/2.0 * (0.996 - 0.004) + 0.004;
    vec4 geomCol = texture(positionMap, st);
    vec4 normCol = texture(normalMap1, st);

    vec3 N = normalize(normalMatrix * (normCol*2.0 - 1.0).xyz);

    if (mode == 0) frontColor = geomCol;
    else if (mode == 1) frontColor = geomCol * N.z;

    gl_Position = modelViewProjectionMatrix * geomCol;
}
