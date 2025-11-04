#version 330 core

in vec3 geomNormal;
in vec3 geomPosition;

out vec4 fragColor;

uniform sampler2D grass_top, grass_side;
uniform float d;

void main() {
	vec2 st;

	if (geomNormal.z == 0) {
		fragColor = texture(grass_side, vec2(
			4 * (geomPosition.x - geomPosition.y), 1 - geomPosition.z / d));
		
	} else {
		fragColor = texture(grass_top, 4 * geomPosition.xy);
	}
}
