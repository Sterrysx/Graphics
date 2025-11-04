#version 330 core

const vec3 C = vec3(0, 0, 0);  // Centre del pla.
const float w = 4;             // Amplada del pla.
const float h = 4;             // Alçada del pla.
const float planeDepth = -1.5; // Profunditat inicial del pla.
const float eta = 1.7;         // Quocient dels índexs de refracció.

in vec3 vertPosition;
in vec2 vertTexturePosition;

out vec4 fragColor;

uniform sampler2D sampler;
uniform float time;
uniform mat4 modelViewMatrixInverse;

float currentPlaneDepth() {
	float s = sin(time);
	return planeDepth - s * s;
}

// Punt d'intersecció del vector de P cap a dir amb el pla a profunditat z.
vec2 planeIntersection(vec3 P, vec3 dir, float z) {
	// z = P.z + k * dir.z => k = (z - P.z) / dir.z
	float k = (z - P.z) / dir.z;
	float x = P.x + k * dir.x;
	float y = P.y + k * dir.y;
	return vec2(x, y);
}

// El punt P és dins el rectangle centrat a C d'amplada w i alçada h?
bool pointIsInsideRectangle(vec2 P, vec2 C, float w, float h) {
	return abs(P.x - C.x) <= w / 2 && abs(P.y - C.y) <= h / 2;
}

// Coordenades de textura del punt.
vec2 rectangleTextureCoordinates(vec2 P, vec2 C, float w, float h) {
	float s = (P.x - C.x) / w + 0.5;
	float t = (P.y - C.y) / h + 0.5;
	return vec2(s, t);
}

// XXX No és la funció original.
// Des de la càmera, al punt V de l'esfera hi veiem el punt del pla
// que interseca amb el vector des de P cap a dir.
void trace(vec3 V, out vec3 P, out vec3 dir) {
	vec3 O = modelViewMatrixInverse[3].xyz;
	vec3 I = normalize(V - O);
	// Com que l'esfera és unitària i centrada a l'origen
	// els punts equivalen a les normals (N = V).
	vec3 R = refract(I, V, 1 / eta);
	// Sabem que P = V + R * d i que P és un punt de l'esfera, per tant, que
	// P.x ^ 2 + P.y ^ 2 + P.z ^ 2 = 1. Substituïm P per V + R * d i resolem
	// l'equació de segon grau. Una solució es d = 0 i l'altra la que fem servir.
	float a = dot(R, R);
	float b = 2 * dot(V, R);
	float c = dot(V, V) - 1;
	float d = (-b + sqrt(b * b - 4 * a * c)) / (2 * a);
	P = V + R * d;
	dir = refract(-R, P, eta);
}

void main() {
	if (vertPosition.z == planeDepth) {
		fragColor = texture(sampler, vertTexturePosition);
	} else {
		vec3 P, dir, V = vertPosition;
		trace(V, P, dir);
		vec2 Q = planeIntersection(P, dir, currentPlaneDepth());
		if (pointIsInsideRectangle(Q, C.xy, w, h)) {
			vec2 st = rectangleTextureCoordinates(Q, C.xy, w, h);
			fragColor = texture(sampler, st);
		} else {
			fragColor = vec4(0.97);
		}
	}
}
