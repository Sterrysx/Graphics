#version 330 core

in vec4 frontColor;
out vec4 fragColor;
uniform float edge0 = 0.35;
uniform float edge1 = 0.4;
in vec3 N;
in vec3 vertices; 


void main()
{
    vec3 NF = normalize(N);
    vec3 verticesF = normalize(-vertices);

    float c = dot(NF,verticesF);   

    fragColor = vec4(smoothstep(edge0, edge1,c));
}
