#version 330 core

in vec4 frontColor;
out vec4 fragColor;

void main()
{
    fragColor = vec4(vec3(gl_FragCoord.z),1.f);
}
