#version 330 core

out vec4 fragColor;

in vec2 st;

uniform sampler2D heightMap;
uniform float smoothness = 25.0;

uniform mat3 normalMatrix;

float epsilon = 1.0/128;

void main()
{

	float r = texture(heightMap, st).r;
	float x = texture(heightMap, st + vec2(epsilon, 0.0)).r;
	float y = texture(heightMap, st + vec2(0.0, epsilon)).r;
	
	vec2 G = vec2( (x-r) / epsilon, (y-r) / epsilon);
	vec3 N = (normalize(vec3(-G.x, -G.y, smoothness)));
	vec3 N_eyespace = normalMatrix * N;
  fragColor = vec4(N_eyespace.z);
}
