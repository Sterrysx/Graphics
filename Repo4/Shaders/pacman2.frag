#version 330 core

const int rows = 4;
const int columns = 4;
const int textureRowCount = 1;
const int textureColumnCount = 6;

const mat4 textureRows = mat4(
	0, 0, 0, 0,
	0, 0, 0, 0,
	0, 0, 0, 0,
	0, 0, 0, 0
);

const mat4 textureColumns = mat4(
	4, 3, 3, 4,
	3, 1, 5, 3,
	3, 0, 0, 3,
	4, 3, 3, 4
);

const mat4 textureReflectionX = mat4(
	0, 0, 0, 0,
	0, 0, 0, 0,
	0, 0, 0, 0,
	1, 0, 0, 1
);

const mat4 textureReflectionY = mat4(
	1, 0, 0, 0,
	0, 1, 0, 0,
	0, 1, 0, 0,
	1, 0, 0, 0
);

const mat4 textureTransposition = mat4(
	0, 0, 0, 0,
	1, 0, 0, 1,
	1, 0, 0, 1,
	0, 0, 0, 0
);

in vec2 vertTexturePosition;

out vec4 fragColor;

uniform sampler2D colormap;

void main() {
	float column = vertTexturePosition.s * columns;
	float row = vertTexturePosition.t * rows;
	float textureRow = textureRows[rows - 1 - int(row)][int(column)];
	float textureColumn = textureColumns[rows - 1 - int(row)][int(column)];
	bool transposition = textureTransposition[rows - 1 - int(row)][int(column)] == 1;
	bool reflectionX = textureReflectionX[rows - 1 - int(row)][int(column)] == 1;
	bool reflectionY = textureReflectionY[rows - 1 - int(row)][int(column)] == 1;
	vec2 st;
	
	if (transposition) {
		float aux = row;
		row = column;
		column = aux;
	}

	if (reflectionY)
		st.s = (textureColumn + 1 - fract(column)) / textureColumnCount;
	else
		st.s = (textureColumn + fract(column)) / textureColumnCount;
	
	if (reflectionX)
		st.t = (textureRow + 1 - fract(row)) / textureRowCount;
	else
		st.t = (textureRow + fract(row)) / textureRowCount;

	fragColor = texture(colormap, st);
}
