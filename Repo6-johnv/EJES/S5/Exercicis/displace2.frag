#version 330 core

in vec2 st;
in vec3 normalVS;
in vec3 fragPos;

out vec4 fragColor;
uniform mat3 normalMatrix;
uniform sampler2D heightMap;
uniform float smoothness;

void main()
{
    // Epsilon para diferencias avanzadas
    float epsilon = 1.0 / 128.0;

    // Obtener valores del height map para calcular el gradiente
    float r  = texture(heightMap, st).r;
    float rx = texture(heightMap, st + vec2(epsilon, 0.0)).r;
    float ry = texture(heightMap, st + vec2(0.0, epsilon)).r;

    vec2 G = vec2((rx - r)/epsilon, (ry - r)/epsilon);

    // Calcular la normal en object space con el gradiente
    vec3 normalObject = normalize(vec3(-G.x, -G.y, smoothness));

    // Convertir la normal a eye space usando la normal transformada en el VS
    vec3 normalEye = normalize(normalMatrix*normalObject);

    // Color basado en la componente Z de la normal en eye space
    fragColor = vec4(vec3(normalEye.z), 1.0) ;
}
