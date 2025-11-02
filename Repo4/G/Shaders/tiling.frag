#version 330 core

in vec2 vtexCoord;

out vec4 fragColor;

uniform sampler2D map0;

void main() {
	fragColor = texture(map0, vtexCoord);
}
