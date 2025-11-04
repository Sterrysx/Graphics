#version 330 core
        
layout(triangles) in;
layout(triangle_strip, max_vertices = 36) out;

in vec4 vfrontColor[];
out vec4 gfrontColor;
out vec3 color;
out vec2 texCoord;

uniform float size = 0.07;
uniform float depth = -0.01;

void main( void )
{
	for( int i = 0 ; i < 3 ; i++ )
	{
		gfrontColor = vfrontColor[i];
		gl_Position = gl_in[i].gl_Position;
		texCoord = vec2(-1.0);      // valor que indicarà que no s'ha de texturar
		EmitVertex();
	}
	 EndPrimitive();

	 // Rectangulo en el centro (triangle strip de 2x2)
    vec2 tex[4] = vec2[4](
        vec2(0.0, 0.0),
        vec2(1.0, 0.0),
        vec2(0.0, 1.0),
        vec2(1.0, 1.0)
    );
	vec3 ndc0 = gl_in[0].gl_Position.xyz / gl_in[0].gl_Position.w;
	vec3 ndc1 = gl_in[1].gl_Position.xyz / gl_in[1].gl_Position.w;
	vec3 ndc2 = gl_in[2].gl_Position.xyz / gl_in[2].gl_Position.w;
	vec3 center = (ndc0 + ndc1 + ndc2) / 3.0;
	vec4 C = vec4(center, 1.0);


vec2 offset[4] = vec2[4](
        vec2(-size, -size),
        vec2( size, -size),
        vec2(-size,  size),
        vec2( size,  size)
    );

    for (int i = 0; i < 4; ++i) {
        gl_Position = vec4(C.xy + offset[i], C.z + depth, 1.0);
        color = vec3(1.0, 1.0, 0.0); // groc
        texCoord = tex[i] * 7.0;    // mapatge procedural de 0 a 7
        EmitVertex();
    }
    EndPrimitive();
}
	