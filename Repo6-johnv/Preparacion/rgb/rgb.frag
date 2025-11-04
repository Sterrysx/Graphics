#version 330 core

in vec4 gfrontColor;
in vec2 gTexCoord;
out vec4 fragColor;

uniform int mode = 3;


void main()
{
    fragColor = gfrontColor;
    if (mode >= 2) {
        if (gTexCoord.x < 0.05 || gTexCoord.x > 0.95 ||
            gTexCoord.y < 0.05 || gTexCoord.y > 0.95) {
            fragColor = vec4(0.0);
            
        }
    }
}
