#version 330 core

in vec4 frontColor;
in vec2 vtexCoord;

out vec4 fragColor;

uniform sampler2D map0;
uniform float time;
uniform float speed = 1;

void main() {
	vec2 offset = vec2(1.0) * fract(speed * time);
	fragColor = frontColor * texture(map0, vtexCoord + offset);

}