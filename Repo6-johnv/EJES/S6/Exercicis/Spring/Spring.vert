#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform float time;

void main()
{
    float t = mod(time,3.5);
    vec3 pos = vertex;
    if (t < 0.5){
    float alpha = pow(2*t,3);
       pos = mix(vec3(0.0),vertex,alpha);
    }
    else {
    float alpha = (t-0.5)/3.0;
       pos = mix(vertex,vec3(0.0),alpha);
    }
    vec3 N = normalize(normalMatrix * normal);
    frontColor = vec4(N.z);
    gl_Position = modelViewProjectionMatrix * vec4(pos, 1.0);
}
