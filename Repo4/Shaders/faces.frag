#version 330 core

const vec4 black = vec4(0, 0, 0, 1);
const vec4 white = vec4(1, 1, 1, 1);

in vec2 vs_texturePosition;

out vec4 fragColor;

uniform sampler2D photo , mask1;
uniform int mode = 4;

vec4 f(sampler2D sampler, vec2 st) {
	vec4 M = vec4(0);
	for (int i = -1; i <= 1; i++) {
		for (int j = -1; j <= 1; j++) {
			M += texture(sampler, st + vec2(i / 256.0, j / 256.0));
		}
	}
	return M / 9;
}

void main() {
	if (mode == 0) {
		fragColor = texture(photo, vs_texturePosition);
	} else if (mode == 1) {
		float p = texture(mask1, vs_texturePosition).r;
		if (p < 0.1) fragColor = texture(photo, vs_texturePosition);
		else fragColor = black;
	} else if (mode == 2) {
		float p = texture(mask1, vs_texturePosition).r;
		fragColor = mix(texture(photo, vs_texturePosition), white, 0.9 * p);
	} else if (mode == 3) {
		float p = texture(mask1, vs_texturePosition).r;
		float offset = p / 200.0 * sin(200.0 * vs_texturePosition.s);
		fragColor = texture(photo, vs_texturePosition + vec2(0, offset));
	} else if (mode == 4) {
		float p = texture(mask1, vs_texturePosition).r;
		vec4 M = f(photo, vs_texturePosition);
		fragColor = mix(texture(photo, vs_texturePosition), M, p);
	}
}
