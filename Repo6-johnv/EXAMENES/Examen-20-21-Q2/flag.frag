#version 330 core

in vec4 frontColor;
out vec4 fragColor;


vec4 azul = vec4(0.0,0.0,1.0,1.0);
vec4 verde = vec4(0.0,0.75,0.0,1.0);
vec4 amarillo=  vec4(1.0,1.0,0.0,1.0);

uniform vec3 boundingBoxMax;

in vec2 vtexCoord;

bool dentro_circulo (vec2 C,float r){
    return distance (vtexCoord ,C) <= r;
}

void main()
{
    if (vtexCoord.s >= 0.0 && vtexCoord.s <= 1.0 && vtexCoord.t >= 0.1 && vtexCoord.t <= 0.9) fragColor = verde;
    else discard;
    if (vtexCoord.s >= 0.1 && vtexCoord.s <= 0.9 && vtexCoord.t >= 0.25 && vtexCoord.t <= 0.75) fragColor= amarillo;
    if (dentro_circulo (vec2(0.5,0.5),0.18)&& ! (dentro_circulo(vec2(0.51, 0.62), 0.26) && !dentro_circulo(vec2(0.51, 0.64), 0.26))) fragColor= azul;

}
