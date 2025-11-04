#version 330 core

in vec4 frontColor;
in vec2 vtexCoord;
out vec4 fragColor;
in vec3 N;

const vec4 white = vec4(0.9,0.9,0.9,1);
const vec4 red = vec4(1,0,0,1);

uniform sampler2D heightMap;
uniform float smoothness = 25.0;
uniform mat3 normalMatrix;


void main()
{
    float epsilon = 1.0 / 128.0;
    float h  = texture(heightMap, vtexCoord).r;                     // height al punt actual
    float hx = texture(heightMap, vtexCoord + vec2(epsilon,0)).r;   // height una mica més en X
    float hy = texture(heightMap, vtexCoord + vec2(0,epsilon)).r;   // height una mica més en Y

    vec2 G = vec2((hx - h)/epsilon, (hy - h)/epsilon); // gradient (derivades parcials) 
                // derivada parcial = (f(x+h) - f(x)) / h
    
    
    vec3 n = normalize(vec3(-G.x, -G.y, smoothness));
    n = normalize(normalMatrix * n).xyz;

    fragColor = vec4(n.z);
}
