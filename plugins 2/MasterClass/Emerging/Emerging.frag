#version 330 core

in vec4 frontColor;
out vec4 fragColor;

uniform float files;
void main()
{
    if(gl_FragCoord.y > files ) discard;
    fragColor = frontColor;
}
