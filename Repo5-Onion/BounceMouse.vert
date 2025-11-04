#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;
out vec2 vtexCoord;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

uniform float time;
uniform int test = 0;
uniform float amplitude = 0.1;
uniform vec3 boundingBoxMax;
uniform vec3 boundingBoxMin;
uniform vec2 mousePosition;
uniform float radius = 300;
uniform vec2 viewport;



uniform float freq = 1.0;             // en Hz
float PI = acos(-1.0);

vec2 getMousePositionWindowSpace() {
    if(test == 0) return mousePosition;
    if(test == 1) return vec2(400,520);
    if(test == 2) return vec2(600,225);
    if(test == 2) return vec2(200,375);
    return vec2(400,300);

}

void main()
{       
    float diagonal = length(boundingBoxMax - boundingBoxMin);
    float offset = 0.03 * diagonal;
    vec3 N = normalize(normalMatrix * normal); 

    vec4 P = modelViewProjectionMatrix * vec4(vertex, 1.0);
    vec3 ndc = P.xyz / P.w;
    vec2 windowPos = (ndc.xy * 0.5 + 0.5) * viewport;

    vec2 mouseWin = getMousePositionWindowSpace();
    float d = length(mouseWin - windowPos);

    float inner = 0.05 * radius;
    float outer = 0.80 * radius;
    float t = smoothstep(outer, inner, d);


    vec3 displacedVertex = vertex + N * (offset * t);

    vec3 baseColor = mix(vec3(1.0, 1.0, 1.0), vec3(1.0, 0.0, 0.0), t);
    float light = clamp(N.z, 0.0, 1.0);
    vec3 finalColor = baseColor * light;

    frontColor = vec4(finalColor, 1.0);
    vtexCoord = texCoord;

    gl_Position = modelViewProjectionMatrix * vec4(displacedVertex, 1.0);

}
