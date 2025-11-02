#version 330 core

in vec4 frontColor;
out vec4 fragColor;
in vec2 vtexCoord;

uniform float n = 8;

bool isBlack(float s, float t) {
    if (int(mod(s*n, 2.0)) != int(mod(t*n, 2.0))) return true;
    else return false;

}

void main()
{
    if (isBlack(vtexCoord.x, vtexCoord.y)) fragColor = vec4(0.0, 0.0, 0.0, 1.0);
    else fragColor = vec4(0.8);
}
