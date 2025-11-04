#version 330 core

const vec4 white = vec4(1, 1, 1, 1);
const vec4 black = vec4(0, 0, 0, 1);
const vec4 gray = vec4(0.8, 0.8, 0.8, 1);
const vec4 skin = vec4(1, 0.8, 0.6, 1);
const vec2 head = vec2(0.5, 0.4);
const float headRadius = 0.35;
const vec2 leftEar = vec2(0.2, 0.8);
const vec2 rightEar = vec2(0.8, 0.8);
const float earRadius = 0.2;
const vec2 leftEyeBase = vec2(0.4, 0.25);
const vec2 rightEyeBase = vec2(0.6, 0.25);
const float eyeBaseRadius = 0.11;
const float eyeBaseScale = 0.5;
const vec2 mouthBase = vec2(0.5, 0.6);
const float mouthBaseRadius = 0.28;
const float mouthBaseScale = 2;
const vec2 whiteLeftEye = vec2(0.4, 0.25);
const vec2 whiteRightEye = vec2(0.6, 0.25);
const float whiteEyeRadius = 0.08;
const float whiteEyeScale = 0.5;
const vec2 blackLeftEye = vec2(0.4, 0.22);
const vec2 blackRightEye = vec2(0.6, 0.22);
const float blackEyeRadius = 0.04;
const float blackEyeScale = 0.5;

in vec2 vs_texturePosition;

out vec4 fragColor;

uniform int mode = 2;

bool circle(vec2 xy, vec2 center, float radius) {
	return distance(xy, center) <= radius;
}

bool ellipse(vec2 xy, vec2 center, float radius, float scale) {
	return distance(xy * vec2(1, scale), center) <= radius;
}

void main() {
	fragColor = gray;
	
	if (mode >= 0) {
		if (circle(vs_texturePosition, head, headRadius)) fragColor = black;
		if (circle(vs_texturePosition, leftEar, earRadius)) fragColor = black;
		if (circle(vs_texturePosition, rightEar, earRadius)) fragColor = black;
	}
	
	if (mode >= 1) {
		if (ellipse(vs_texturePosition, leftEyeBase, eyeBaseRadius, eyeBaseScale)) fragColor = skin;
		if (ellipse(vs_texturePosition, rightEyeBase, eyeBaseRadius, eyeBaseScale)) fragColor = skin;
		if (ellipse(vs_texturePosition, mouthBase, mouthBaseRadius, mouthBaseScale)) fragColor = skin;
	}
	
	if (mode >= 2) {
		if (ellipse(vs_texturePosition, whiteLeftEye, whiteEyeRadius, whiteEyeScale)) fragColor = white;
		if (ellipse(vs_texturePosition, whiteRightEye, whiteEyeRadius, whiteEyeScale)) fragColor = white;
		if (ellipse(vs_texturePosition, blackLeftEye, blackEyeRadius, blackEyeScale)) fragColor = black;
		if (ellipse(vs_texturePosition, blackRightEye, blackEyeRadius, blackEyeScale)) fragColor = black;
	}
}
