#version 330 core
        
layout(triangles) in;
layout(triangle_strip, max_vertices = 36) out;

in vec4 vfrontColor[];
out vec4 gfrontColor;
uniform bool culling = true;
uniform mat4 modelViewProjectionMatrix;
out vec3 P;
out vec3 C;
in vec3 NEyeSpace[];
void main( void )
{
	if (culling){
		if(NEyeSpace[0].z < 0 && NEyeSpace[1].z  < 0 && NEyeSpace[2].z  < 0 ) return;
	}
	vec3 center = (gl_in[0].gl_Position.xyz+gl_in[1].gl_Position.xyz+gl_in[2].gl_Position.xyz) /3.0;
	for( int i = 0 ; i < 3 ; i++ )
	{
		gfrontColor = vfrontColor[i];
		gl_Position = modelViewProjectionMatrix * gl_in[i].gl_Position;
		P = gl_in[i].gl_Position.xyz;
		C = center;
		EmitVertex();
	}
    EndPrimitive();
}
