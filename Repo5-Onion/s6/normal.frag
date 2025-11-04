#version 330 core

in vec4 frontColor;
in vec2 vtexCoord;
out vec4 fragColor;
in vec3 N;

const vec4 white = vec4(0.9,0.9,0.9,1);
const vec4 red = vec4(1,0,0,1);



in vec3 vPosition;

void main()
{
    vec3 k = normalize(cross(dFdx(vPosition),dFdy(vPosition)));
    fragColor = frontColor*k.z;
}
