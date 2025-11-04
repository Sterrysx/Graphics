#version 330 core

in vec4 frontColor;
out vec4 fragColor;

const vec4 negro= vec4 (0, 0, 0, 1.0);
const vec4 gris= vec4 (0.8, 0.8, 0.8, 1.0);;
const vec4 piel= vec4(1.0, 0.8, 0.6,1.0);
const vec4 blanco= vec4(1.0);

uniform int mode=2;
uniform vec3 boundingBoxMax;
in vec2 vtexCoord;

bool dentro (vec2 C,float r){
    return distance (vtexCoord ,C) <= r;
}

vec4 pintarFondo(){
    vec2 C = vec2(0.5, 0.5);
	float t = smoothstep(0.0, distance(C, boundingBoxMax.xy), distance(vtexCoord, C));
	return mix(gris, negro, t);
    }

bool dentro_ovalo_x (vec2 C,float r){
    return distance (vtexCoord*vec2(1.0,2.0) ,C) <= r;
}
bool dentro_ovalo_y (vec2 C,float r){
    return distance (vtexCoord*vec2(2.0,1.0) ,C) <= r;
}


void main()
{
    //fragColor = pintarFondo();
    fragColor = gris;
    
    if (dentro(vec2(0.5, 0.5), 0.32)|| dentro(vec2(0.2, 0.8), 0.2) || dentro(vec2(0.8, 0.8), 0.2)) fragColor = negro;
    if ((mode == 1 || mode == 2)&& (dentro_ovalo_x(vec2(0.5, 0.7), 0.25) || dentro_ovalo_y(vec2(0.9, 0.55), 0.2) || dentro_ovalo_y(vec2(1.1, 0.55), 0.2)) ) fragColor = piel;
    if (mode == 2 && (dentro_ovalo_y(vec2(0.9, 0.55), 0.15) || dentro_ovalo_y(vec2(1.1, 0.55), 0.15)) ) fragColor = blanco;
    if ( mode == 2 && (dentro_ovalo_y(vec2(0.89, 0.50), 0.10) || dentro_ovalo_y(vec2(1.11, 0.50), 0.10)) ) fragColor = negro;
}
