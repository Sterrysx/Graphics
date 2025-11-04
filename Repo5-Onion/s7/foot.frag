#version 330 core

in vec4 frontColor;
in vec2 vtexCoord;
out vec4 fragColor;

uniform sampler2D foot0;
uniform sampler2D foot1;
uniform sampler2D foot2;
uniform sampler2D foot3;

const float R = 80.0;

uniform int layer = 1;

uniform vec2 mousePosition;
uniform bool virtualMouse = false;
uniform float mouseX, mouseY; 

uniform vec2 viewport;

vec2 mouse()
{
	if (virtualMouse) return vec2(mouseX, mouseY);
	else return mousePosition;
}

void main()
{
    vec2 pos = vtexCoord*viewport;
    float dist = distance(mouse(),pos);
    if(dist >= R) fragColor = texture(foot0, vtexCoord);
    else
    {
        vec4 inside;
        vec4 outside = texture(foot0, vtexCoord);
        if(layer == 0) inside = texture(foot0, vtexCoord);
        else if(layer == 1) inside = texture(foot1, vtexCoord);
        else if(layer == 2) inside = texture(foot2, vtexCoord);
        else if(layer == 3) inside = texture(foot3, vtexCoord);
        fragColor = mix(inside,outside,dist/R);
        //fragColor = vec4(1,0,0,1);
    }
}
