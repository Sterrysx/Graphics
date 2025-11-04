#version 330 core

in vec4 frontColor;
out vec4 fragColor;
in vec3 eyeVertex;

vec3 normal(vec3 A){
    vec3 AB = dFdx(A);
    vec3 BC = dFdy(A);
    return normalize(cross(AB,BC));
}
void main()
{
    fragColor = vec4(frontColor.xyz * normal(eyeVertex).z,1.0);
}
