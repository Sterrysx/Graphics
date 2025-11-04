#version 330 core
        
layout(triangles) in;
layout(triangle_strip, max_vertices = 36) out;

in vec4 vfrontColor[];
out vec4 gfrontColor;
uniform int mode = 3;
uniform float cut = -0.25;
out vec2 gTexCoord; // només per modes 2 i 3

uniform mat4 modelViewProjectionMatrix;

vec3 cubeVerts[8] = vec3[](
    vec3(-1,-1,-1), vec3(1,-1,-1), vec3(-1,1,-1), vec3(1,1,-1),
    vec3(-1,-1,1), vec3(1,-1,1), vec3(-1,1,1), vec3(1,1,1)
);

int cubeFaces[36] = int[](
    0,1,2,  2,1,3,  // cara -Z (0)
    4,6,5,  5,6,7,  // cara +Z (1)
    0,2,4,  4,2,6,  // cara -X (2)
    1,5,3,  3,5,7,  // cara +X (3)
    2,3,6,  6,3,7,  // cara +Y (4)
    0,4,1,  1,4,5   // cara -Y (5)
);

void main( void )
{
	vec3 C = (gl_in[0].gl_Position.xyz+gl_in[1].gl_Position.xyz+gl_in[2].gl_Position.xyz)/3.0;

	if (mode == 1) {
            // (x,y,z) ∈ [-1,1] → (r,g,b) ∈ [0,1]
            gfrontColor = vec4((C + vec3(1.0)) * 0.5, 1.0);
        } else {
            gfrontColor = vec4((C + vec3(1.0)) * 0.5, 1.0);
        }
  if (mode == 3 && C.x >= cut && C.y >= cut && C.z >= cut) {
        return; // cap vèrtex es genera
    }
	 float s = 0.08; // meitat del costat (0.16 / 2)

    // Generar els 36 vèrtexs del cub a partir de les cares
    for (int i = 0; i < 36; ++i) {
        vec3 offset = cubeVerts[cubeFaces[i]] * s;
        vec4 pos = modelViewProjectionMatrix * vec4(C + offset, 1.0);
        gl_Position = pos;

		// Coordenades de textura (per marginat)
        if (mode >= 2) {
            // Generem s,t ∈ [0,1] segons posició del vèrtex dins la cara
            vec3 v = cubeVerts[cubeFaces[i]];

			// segons la cara
			int faceId = i / 6;  // cada 6 vèrtexs = una cara (2 triangles)

			if (faceId == 0 || faceId == 1)      // cara -Z o +Z (pla XY)
				gTexCoord = (v.xy + vec2(1.0)) * 0.5;
			else if (faceId == 2 || faceId == 3) // cara -X o +X (pla YZ)
				gTexCoord = (v.zy + vec2(1.0)) * 0.5;
			else if (faceId == 4 || faceId == 5) // cara -Y o +Y (pla XZ)
				gTexCoord = (v.xz + vec2(1.0)) * 0.5;
		
            // projectem els vèrtexs al pla XY per simplificar (no ideal però suficient)
            gTexCoord = (v.xy + vec2(1.0)) * 0.5;


        }

        EmitVertex();
        if (i % 3 == 2) EndPrimitive();
    }
}
