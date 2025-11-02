#version 330 core

uniform sampler2D colorMap;

uniform float speed = 0.1;
uniform float time = 0.1;

in vec4 frontColor;
in vec2 vtexCoord;
out vec4 fragColor;

void main()
{
    fragColor = frontColor * texture(colorMap, speed * time + vtexCoord);
}
