#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec2 vtexCoord;
out vec2 st;       // Coordenadas de textura para el FS
out vec3 normalVS; // Normal transformada a eye space
out vec3 fragPos;  // Posición en eye space

uniform mat4 modelViewProjectionMatrix;
uniform mat4 modelViewMatrix;
uniform mat3 normalMatrix;
uniform sampler2D heightMap;
uniform float scale;

void main()
{
    // Coordenadas de textura adhoc
    st = 0.49 * vertex.xy + vec2(0.5);

    // Obtener altura de la textura (componente roja)
    float r = texture(heightMap, st).r;

    // Aplicar desplazamiento en la dirección de la normal
    vec3 displacedVertex = vertex + normal * (scale * r);

    // Transformar la normal a eye space
    vec3 N = normalize(normalMatrix * normal);
    normalVS = N;

    // Transformar la posición del vértice a eye space
    fragPos = vec3(modelViewMatrix * vec4(displacedVertex, 1.0));


    // Pasar coordenadas de textura al FS
    vtexCoord = texCoord;

    // Proyectar el vértice final
    gl_Position = modelViewProjectionMatrix * vec4(displacedVertex, 1.0);
}
