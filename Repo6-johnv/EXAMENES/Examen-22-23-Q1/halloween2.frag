#version 330 core

in vec4 frontColor;
out vec4 fragColor;

vec4 naranja = vec4(1.0,0.5,0.0,1.0);
vec4 negro=  vec4(0.0,0.0,0.0,1.0);

uniform vec3 boundingBoxMax;

in vec2 vtexCoord;
bool dentro (vec2 C,float r){
    return distance (vtexCoord* vec2(4.0/3.0, 1.3) ,C) <= r;
}

vec4 pintarFondo(){
    vec2 C = vec2(0.5, 0.5);
	float t = smoothstep(0.0, distance(C, boundingBoxMax.xy), distance(vtexCoord, C));
	return mix(naranja, negro, t);
    }

void main()
{
    fragColor = pintarFondo();
    if (dentro(vec2(0.535, 0.78), 0.11) || dentro(vec2(0.8, 0.78), 0.11)) return; // Ulls
	else if (dentro(vec2(0.67, 0.65), 0.26) && !dentro(vec2(0.67, 0.71), 0.26)) return; // Mitja Lluna
    else if (dentro(vec2(0.675, 0.62), 0.4)) fragColor = negro; // Rodona
    else if (vtexCoord.s >= 0.47 && vtexCoord.s <= 0.53 && vtexCoord.t >= 0.78 && vtexCoord.t <= 0.9) fragColor = negro; // Palet
}
