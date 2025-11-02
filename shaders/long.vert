#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

uniform vec3 boundingBoxMin;
uniform vec3 boundingBoxMax;

uniform float t = 0.4;
uniform float scale = 4.0;

void main()
{
    float c = mix(boundingBoxMin.y, boundingBoxMax.y, t);
    vec3 N = normalize(normalMatrix * normal);
    frontColor = vec4(color,1.0) * N.z;

    vec3 newVertex = vertex;

    if(vertex.y < c)
    {
        mat4 glScale = mat4(1, 0.0, 0.0, 0.0,
                            0.0, scale, 0.0, 0.0,
                            0.0, 0.0, 1, 0.0,
                            0.0, 0.0, 0.0, 1.0);
        newVertex = (glScale * vec4(newVertex, 1.0)).xyz;
    } else {
        float d = c * scale - c;
        mat4 glTranslate = mat4(1, 0.0, 0.0, 0.0,
                                0.0, 1, 0.0, 0,
                                0.0, 0.0, 1, 0.0,
                                0.0, d, 0.0, 1.0);
        newVertex = (glTranslate * vec4(newVertex, 1.0)).xyz;
    }
    gl_Position = modelViewProjectionMatrix * vec4(newVertex, 1.0);
}
