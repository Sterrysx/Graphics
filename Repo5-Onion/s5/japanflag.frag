#version 330 core

in vec4 frontColor;
in vec2 vtexCoord;
out vec4 fragColor;
in vec3 N;

const vec4 white = vec4(0.9,0.9,0.9,1);
const vec4 red = vec4(1,0,0,1);

uniform bool classic = true;

float aaastep(float threshold, float x) {
    float with = 0.7*length(vec2(dFdx(x),dFdy(x)));

    return smoothstep(threshold-with,threshold+with,x);
}



void main()
{
    if(classic)
    {
        float radi = distance(vtexCoord,vec2(0.5));
        float d = aaastep(0.2,radi);
        fragColor = mix(red,white,d);
    }
    else 
    {
        float radi = distance(vtexCoord,vec2(0.5));
        vec2 v = vtexCoord - vec2(0.5);
        float a = atan(v.x, v.y);
        float phi = acos(-1)/16;
        bool raig = mod(a/phi +0.5,2) < 1;
        if(radi <= 0.2 || raig) fragColor = red;
        else fragColor = white;
    }
}
