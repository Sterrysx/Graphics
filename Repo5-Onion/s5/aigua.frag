#version 330 core

in vec4 frontColor;
in vec2 vtexCoord;
out vec4 fragColor;
in vec3 N;

const vec4 white = vec4(0.9,0.9,0.9,1);
const vec4 red = vec4(1,0,0,1);

uniform sampler2D fons;
uniform sampler2D noise1;

uniform float time;

void main()
{
    vec4 ns = texture(noise1, vec2(vtexCoord.s + 0.8*time, vtexCoord.t+0.7*time));
    vec2 add = ns.xy*vec2(0.003,-0.005);
    vec4 rocs = texture(fons,vtexCoord+add);
    fragColor = rocs;
}
