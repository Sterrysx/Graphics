#version 330 core
const vec3 red = vec3(1, 0, 0);
const vec3 yellow = vec3(1, 1, 0);
const vec3 green = vec3(0, 1, 0);
const vec3 cyan = vec3(0, 1, 1);
const vec3 blue = vec3(0, 0, 1);

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;
out vec2 vtexCoord;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

vec3 gradient (vec4 vertex){
    float y = (vertex.y / vertex.w + 1.0) / 2.0;
	float f = fract(4.0 * y);
        if      (y < 0.00) return red;
        else if (y < 0.25) return mix(red, yellow, f);
        else if (y < 0.50) return mix(yellow, green, f);
        else if (y < 0.75) return mix(green, cyan, f);
        else if (y < 1.00) return mix(cyan, blue, f);
        else               return blue;
}
void main()
{
    vec3 N = normalize(normalMatrix * normal);
    
    vtexCoord = texCoord;
    gl_Position = modelViewProjectionMatrix * vec4(vertex, 1.0);
    frontColor = vec4(gradient(gl_Position), 1.0);
}
