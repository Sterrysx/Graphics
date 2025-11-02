#version 330 core

in vec4 vertPosition;
in vec3 vertNormal;

out vec4 fragColor;

uniform sampler2D sampler;

void main() {
	vec2 st = vertPosition.xy / vertPosition.w; 
	vec4 color = texture(sampler, st);
	fragColor = color * normalize(vertNormal).z;
}
