#version 330 core

in vec3 vertNormal;
in vec2 vertTextureCoordinates;

out vec4 fragColor;

uniform sampler2D window;
uniform sampler2D palm1;
uniform sampler2D background2;
uniform float time;

void main() {
	vec2 st = vertTextureCoordinates;
	vec4 C = texture(window, st);
	if (C.a == 1) {
		fragColor = C;
	} else {
		vec2 st1 = st + 0.25 * vertNormal.xy + vec2(0.1 * sin(2 * time) * st.t, 0);
		vec4 D = texture(palm1, st1);
		if (D.a >= 0.5) {
			fragColor = D;
		} else {
			vec2 st2 = st + 0.5 * vertNormal.xy;
			fragColor = texture(background2, st2);
		}
	}
}
