#include "ModelInfo.h"
#include "glwidget.h"

void ModelInfo::computeInfo()
{
	const vector <Object> & objects = scene()->objects();
	objectCount = objects.size();
	vertexCount = 0;
	faceCount = 0;
	triangleCount = 0;
	for (int i = 0; i < objects.size(); i++) {
		const Object & object = objects[i];
		const vector <Vertex> & vertices = object.vertices();
		const vector <Face> & faces = object.faces();
		vertexCount += vertices.size();
		faceCount += faces.size();
		for (int j = 0; j < faces.size(); j++) {
			const Face & face = faces[j];
			triangleCount += int(face.numVertices() == 3);
		}
	}
}

void ModelInfo::printInfo()
{
	cout << "Number of loaded objects: " << objectCount << endl;
	cout << "Number of vertices: " << vertexCount << endl;
	cout << "Number of polygons: " << faceCount << endl;
	cout << "Number of triangles: " << triangleCount << endl;
}

void ModelInfo::drawInfo()
{
	  QFont font;
	  int size = 10;
	  font.setPixelSize(size);
	  painter.begin(glwidget());
	  painter.setFont(font);
	  painter.drawText(0, 1 * size, QString("Number of loaded objects: ")
	  	+ QString::number(objectCount));
	  painter.drawText(0, 2 * size, QString("Number of vertices: ")
	  	+ QString::number(vertexCount));
	  painter.drawText(0, 3 * size, QString("Number of polygons: ")
	  	+ QString::number(faceCount));
	  painter.drawText(0, 4 * size, QString("Number of triangles: ")
	  	+ QString::number(triangleCount));
	  painter.end();
}

void ModelInfo::onPluginLoad()
{
	computeInfo();
}

void ModelInfo::preFrame()
{
	
}

void ModelInfo::postFrame()
{
	printInfo();
	drawInfo();
}

void ModelInfo::onObjectAdd()
{
	computeInfo();
}

bool ModelInfo::drawScene()
{
	return false; // return true only if implemented
}

bool ModelInfo::drawObject(int)
{
	return false; // return true only if implemented
}

bool ModelInfo::paintGL()
{
	return false; // return true only if implemented
}

void ModelInfo::keyPressEvent(QKeyEvent *)
{
	
}

void ModelInfo::mouseMoveEvent(QMouseEvent *)
{
	
}

