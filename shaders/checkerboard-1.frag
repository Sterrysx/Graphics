#version 330 core

in vec4 frontColor;
in vec2 vtexCoord;
out vec4 fragColor;

int nx = 8;
int ny = 8;

bool isBlack(float s, float t) {
    if (int(mod(s*nx, 2.0)) != int(mod(t*ny, 2.0))) return true;
    else return false;

}

void main()
{
    if (isBlack(vtexCoord.x, vtexCoord.y)) fragColor = vec4(0.0, 0.0, 0.0, 1.0);
    else fragColor = vec4(0.8);
}
