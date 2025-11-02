#version 330 core

const vec3 black = vec3(0, 0, 0);

in vec2 vs_texturePosition;

out vec4 fragColor;

uniform sampler2D sampler;
uniform int textureSize = 1024, edgeSize = 2;
uniform float threshold = 0.1;

float textureDistance(sampler2D sampler, vec2 point1, vec2 point2) {
	return distance(texture(sampler, point1), texture(sampler, point2));
}

void main() {
	vec2 left = vs_texturePosition + edgeSize * vec2(-1, 0) / textureSize;
	vec2 right = vs_texturePosition + edgeSize * vec2(1, 0) / textureSize;
	vec2 bottom = vs_texturePosition + edgeSize * vec2(0, -1) / textureSize;
	vec2 top = vs_texturePosition + edgeSize * vec2(0, 1) / textureSize;
	float GX = textureDistance(sampler, right, left);
	float GY = textureDistance(sampler, top, bottom);
	float difference = length(vec2(GX, GY));
	if (difference > threshold) fragColor = vec4(black, 1);
	else fragColor = texture(sampler, vs_texturePosition);
}
