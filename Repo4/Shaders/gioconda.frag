#version 330 core

const vec2 eye = vec2(0.393, 0.652);
const vec2 mouth = vec2(0.45, 0.48);
const vec2 offset = mouth - eye;
const float radius = 0.025;

in vec2 vtexCoord;

out vec4 fragColor;

uniform sampler2D map0;
uniform float time;

void main() {
	if (fract(time) > 0.5 && distance(vtexCoord, eye) <= radius) {
		fragColor = texture(map0, vtexCoord + offset);
	} else {
		fragColor = texture(map0, vtexCoord);
	}
}
