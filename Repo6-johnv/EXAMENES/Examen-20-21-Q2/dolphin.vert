#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;
out vec2 vtexCoord;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform float time;
const float PI = 3.1416;
uniform vec3 boundingBoxMax;
uniform vec3 boundingBoxMin;

float punt(float x) {
	return (boundingBoxMax.y - boundingBoxMin.y)*x + boundingBoxMin.y;
}


void main()
{
    vec3 verteaux= vertex;

    float RT = punt(0.35);
    float RD = punt(0.65);
    if (vertex.y <= RT){   
        float TT1 = punt(0.5);
        float TT2 = punt(0.05);
        float factor = smoothstep(TT1,TT2,vertex.y);
    	float angulo = min(0.0, -PI/4.0*sin(time));

        mat4 rotX = mat4(
            1.0,     0.0,      0.0,    0.0,
            0.0,  cos(angulo),   sin(angulo),    0.0,
            0.0, -sin(angulo),   cos(angulo),    0.0,
            0.0,     0.0,      0.0,    1.0
        );
        verteaux = (rotX * vec4(vertex, 1.0)).xyz;
        verteaux = mix(vertex,verteaux.xyz,factor);
    }
    else if (vertex.y >= RD){
        float TD1 = punt(0.55);
        float TD2 = punt(0.75);
		float factor = smoothstep(TD1, TD2, vertex.y);
		float angulo = PI/32.0*sin(time + 0.25);

          mat4 rotX = mat4(
            1.0,     0.0,      0.0,    0.0,
            0.0,  cos(angulo),   -sin(angulo),    0.0,
            0.0, sin(angulo),   cos(angulo),    0.0,
            0.0,     0.0,      0.0,    1.0
        );

        verteaux = (rotX * vec4(vertex, 1.0)).xyz;
        verteaux = mix(vertex,verteaux.xyz,factor);
    }
  
    vec3 color_aux = vec3(0.8, 0.8, 0.8);
    vec3 N = normalize(normalMatrix * normal);
    frontColor = vec4(color_aux,1.0) * N.z;
    vtexCoord = texCoord;
    gl_Position = modelViewProjectionMatrix * vec4(verteaux, 1.0);
}
