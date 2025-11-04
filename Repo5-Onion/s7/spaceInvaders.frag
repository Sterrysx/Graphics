#version 330 core

in vec4 frontColor;
in vec2 vtexCoord;
out vec4 fragColor;

uniform sampler2D colormap;

void main()
{
    float n = 15.0;
    vec2 p = vtexCoord*n;
    vec2 t = fract(p);
    p = floor(p);
    //cano
    if(p.x == 7 && p.y == 0) fragColor = texture(colormap,t/4. + vec2(3/4.,1/4.));
    //escuts
    else if(p.y == 1 && floor(mod(p.x,4)) == 1) fragColor = texture(colormap,t/4+ vec2(3/4.,0.));
    //aliens
    else if(p.y > 2 && p.y < n-1 && p.x > 0 && p.x < n - 1) fragColor = texture(colormap,t/4+ vec2(floor(mod(p.y,3))/4.,floor(mod(p.y,4))/4.)); 
    //fons
    else fragColor = vec4(0.,0.,0.,1.);
}
