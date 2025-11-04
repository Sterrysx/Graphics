#version 330 core

in vec2 geomTexturePosition;

out vec4 fragColor;

uniform sampler2D sampler;

void main() {
	vec4 color = texture(sampler, geomTexturePosition);
	if (color.a < 1) discard;
	else fragColor = color;
}
