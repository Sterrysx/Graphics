#version 330 core

in vec4 frontColor;
in vec2 vtexCoord;

out vec4 fragColor;

uniform sampler2D map0;

void main() {
	fragColor = frontColor * texture(map0, vtexCoord);
}
