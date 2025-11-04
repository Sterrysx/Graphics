#version 330 core

in vec4 frontColor;
in vec2 vtexCoord;
out vec4 fragColor;
uniform int N = 3;
uniform sampler2D hole;
const float R = 0.2;
void main()
{
    vec2 center = vec2(0.5);
    vec2 delta = vtexCoord - center;
    float dist = length(delta);
    vec4 color;
     if (N == 0 || dist >= R) {
        // Fuera del círculo o sin repeticiones
        color = texture(hole, vtexCoord);
    }
    else{
    for (int i = 0; i < N; ++i ){
        float scale = pow(0.5, float(i)); // mitad cada iteración
        vec2 coord = center + delta / scale;
        color += texture(hole, coord);
    }
    color /= float(N); // promedio nose lo que hace
    }
    fragColor = color;
}
