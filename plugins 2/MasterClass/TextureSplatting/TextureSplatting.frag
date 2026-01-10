#version 330 core

in vec2 vertexTextureCoordinates;
in vec3 vertexNormal;

out vec4 fragColor;

uniform sampler2D sampler0;
uniform sampler2D sampler1;
uniform sampler2D sampler2;

void main() {
	float p = texture(sampler0, vertexTextureCoordinates).r;
	vec4 color1 = texture(sampler1, vertexTextureCoordinates);
	vec4 color2 = texture(sampler2, vertexTextureCoordinates);
	fragColor = mix(color1, color2, p) * vertexNormal.z;
}
