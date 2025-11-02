#version 330 core


in vec3 vP;
in vec3 vN;

out vec4 fragColor;


uniform float edge0 = 0.35;
uniform float edge1 = 0.4;

void main()
{
    vec3 V = normalize(-vP);
    vec3 N = normalize(vN);
    float c = dot(V, N);
    fragColor = vec4(smoothstep(edge0, edge1, c));   
}
