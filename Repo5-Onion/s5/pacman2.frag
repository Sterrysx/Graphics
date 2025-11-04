#version 330 core

in vec4 frontColor;
in vec2 vtexCoord;
out vec4 fragColor;
in vec3 N;

const vec4 white = vec4(0.9,0.9,0.9,1);
const vec4 red = vec4(1,0,0,1);

uniform sampler2D pacman0;


void main()
{
    vec2 celda = vec2(1.0/6.0,1.);
    float n = 13.0;
    vec2 pos = vec2(vtexCoord.s*n,vtexCoord.t*n);
    vec2 tpos = fract(pos);


    if(pos.x >= 1 && pos.x < 2 && pos.y >= 1 && pos.y < 2) fragColor = texture(pacman0, vec2(tpos.x/6.+ 1/6.,tpos.y));
    //bottom right
    else if(pos.x < 1 && pos.y < 1 ) fragColor = texture(pacman0, vec2((1-tpos.x)/6.+ 4/6.,1-tpos.y));
    //bottom right
    else if(pos.x >= 12 && pos.y < 1) fragColor = texture(pacman0, vec2(tpos.x/6.+ 4/6.,1-tpos.y));
    //top left
    else if (pos.x < 1 && pos.y >= 12) fragColor = texture(pacman0, vec2((1-tpos.x)/6.+ 4/6.,tpos.y));
    //top right
    else if (pos.x >= 12 && pos.y >= 12)  fragColor = texture(pacman0, vec2(tpos.x/6.+ 4/6.,tpos.y));
    //paret hor
    else if(pos.y < 1. || pos.y >= 12.) fragColor = texture(pacman0,vec2(tpos.x/6. + 3/6.,tpos.y));
    //paret vert
    else if(pos.x < 1. || pos.x >= 12.) fragColor = texture(pacman0,vec2(tpos.y/6. + 3/6.,tpos.x));
    //mondeas
    else if(mod(pos.x,3)  < 2 ) fragColor = texture(pacman0, vec2(tpos.x/6.+ 3/6.,tpos.y));
    else fragColor = texture(pacman0, vec2(tpos.x/6.+ 5/6.,tpos.y));
}
