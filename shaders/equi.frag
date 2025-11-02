#version 330 core

//in vec4 frontColor;
out vec4 fragColor;

in vec3 fragPos;

uniform sampler2D panorama;
const float PI = 3.14159265359;


void main()
{
	vec3 normalizedPos = normalize(fragPos);
	
	float theta = atan(normalizedPos.z, normalizedPos.x);
	float psi = asin(normalizedPos.y);

	vec2 st = vec2(theta/(2*PI), (psi/PI) + 0.5);
	
	fragColor = texture(panorama, st);
}
