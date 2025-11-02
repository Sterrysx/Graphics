#version 330 core
        
layout(triangles) in;
layout(triangle_strip, max_vertices = 36) out;

in vec4 vfrontColor[];
out vec4 gfrontColor;
out vec2 gtexCoord;

uniform vec4 lightPosition = vec4(10, 0, 0, 1);
uniform float w = 0.3;
uniform mat4 projectionMatrix;



void main( void )
{
	for( int i = 0 ; i < 3 ; i++ )
	{
		gfrontColor = vfrontColor[i];
		gl_Position = gl_in[i].gl_Position;
		gtexCoord = vec2(-1.0, -1.0);
		EmitVertex();
	}
    EndPrimitive();

	if (gl_PrimitiveIDIn == 0) {

		vec4 lpn = projectionMatrix * lightPosition;
		float alpha = lpn.w;
		lpn /= alpha;
		
		gtexCoord = vec2(1, 1);
		vec4 pos = lpn + vec4(w, w, 0, 0);
		gl_Position = pos * alpha;
		EmitVertex();
		
		gtexCoord = vec2(0, 1);
		pos = lpn + vec4(-w, w, 0, 0);
		gl_Position = pos * alpha;
		EmitVertex();
		
		gtexCoord = vec2(1, 0);
		pos = lpn + vec4(w, -w, 0, 0);
		gl_Position = pos * alpha;
		EmitVertex();
		
		gtexCoord = vec2(0, 0);
		pos = lpn + vec4(-w, -w, 0, 0);
		gl_Position = pos * alpha;
		EmitVertex();
		EndPrimitive();
	}
}
