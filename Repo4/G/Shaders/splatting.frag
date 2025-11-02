#version 330 core

in vec2 vtexCoord;

out vec4 fragColor;

uniform sampler2D noise0;
uniform sampler2D rock1;
uniform sampler2D grass2;

void main() {
	float p = texture(noise0, vtexCoord).r;
	vec4 color1 = texture(rock1, vtexCoord);
	vec4 color2 = texture(grass2, vtexCoord);
	fragColor = mix(color1, color2, p);
	// fragColor = (1 - p) * color1 + p * color2;
}
