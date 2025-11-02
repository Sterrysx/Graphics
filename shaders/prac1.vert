#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;
out vec2 vtexCoord;

const float pi = 3.141592;

uniform mat4 projectionMatrix;
uniform mat3 normalMatrix;
uniform mat4 modelViewMatrix;
uniform mat4 modelViewProjectionMatrix;

uniform int test = 0;
uniform vec3 boundingBoxMin;
uniform vec3 boundingBoxMax;
uniform vec2 mousePosition;
uniform float radius = 150;
uniform float time;
uniform vec2 viewport;

vec2 getMousePositionWindowSpace() {
    if(test == 0) return mousePosition;
    if(test == 1) return vec2(400,520);
    if(test == 2) return vec2(600,225);
    if(test == 3) return vec2(200,375);
    return vec2(400,300);
}

void main()
{
    vec3 N = normalize(normalMatrix * normal);
    vtexCoord = texCoord;
    float boundingBoxLength = distance(boundingBoxMin, boundingBoxMax);

    vec4 eyeVertex = modelViewMatrix * vec4(vertex, 1.0);
    vec4 clipVertex = projectionMatrix * eyeVertex;
    vec2 screenVertex = vec2((clipVertex.x / clipVertex.w), (clipVertex.y / clipVertex.w));
    vec2 windowVertex = vec2(((screenVertex.x + 1.0) / 2) * viewport.x, ((screenVertex.y + 1.0) / 2) * viewport.y);
    
    float d = distance(windowVertex, getMousePositionWindowSpace());
    float t = smoothstep(0.0, 1.0, d / radius);
    
    float thickness = boundingBoxLength * 0.03 * (1.0 - t); // Invert t for correct thickness
    vec4 displacedVertex = vec4(vertex, 1.0) + vec4(N, 0.0) * thickness;
    
    gl_Position = modelViewProjectionMatrix * displacedVertex;

    // Use the original normal to compute frontColor
    frontColor = vec4(1.0, t, t, 1.0) * max(N.z, 0.0); // Clamp N.z to avoid negative colors
}
