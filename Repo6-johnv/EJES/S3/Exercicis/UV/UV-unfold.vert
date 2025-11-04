#version 330 core

layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;
layout (location = 2) in vec3 color;
layout (location = 3) in vec2 texCoord;

out vec4 frontColor;
out vec2 vtexCoord;

// Rectangle de l'espai de textura visualitzat.
uniform vec2 Min = vec2(-1.0, -1.0);
uniform vec2 Max = vec2(1.0, 1.0);

void main() {
	frontColor = vec4(color, 1);
	vec2 xy = vec2(2.0) * (texCoord - Min) / (Max - Min) - vec2(1.0);
	gl_Position = vec4(xy, 0.0, 1.0);
}
