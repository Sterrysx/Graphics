#version 330 core

in vec4 frontColor;
in vec3 N;

out vec4 fragColor;

void main() {
	fragColor = vec4(frontColor.xyz * normalize(N).z, 1.0);
}
