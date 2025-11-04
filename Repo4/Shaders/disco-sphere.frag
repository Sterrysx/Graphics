#version 330 core

in vec3 vs_position;

out vec4 fragColor;

uniform sampler2D sampler;

vec3 vertexNormal(vec3 position) {
	vec3 AB = dFdx(position);
	vec3 AC = dFdy(position);
	return normalize(cross(AB, AC));
}

void main() {
	vec3 normal = vertexNormal(vs_position);
	fragColor = texture(sampler, normal.xy) * normal.z;
}
