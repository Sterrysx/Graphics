#version 330 core

in vec4 frontColor;
in vec2 vtexCoord;
out vec4 fragColor;
in vec3 N;

uniform sampler2D explosion;
uniform float time;

void main()
{
    float slice = 1.0/30.0;
    float temps = slice*time;
    float x = -1.0 - floor(temps/8.0);
    fragColor = frontColor * texture(explosion, vec2(vtexCoord.s / 1.0/8.0 + floor(temps)/8.0,vtexCoord.t / 1.0/6.0 + x/6.0));
    fragColor *= fragColor.w;
}
