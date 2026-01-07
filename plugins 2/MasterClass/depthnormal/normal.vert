#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;
out vec2 vtexCoord;
uniform mat3 normalMatrix;
uniform mat4 modelViewProjectionMatrix;

void main()
{
    frontColor = vec4((normalize(normal)+vec3(1.f))/3.f,1.f);
    
    vtexCoord = texCoord;
    gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
}
