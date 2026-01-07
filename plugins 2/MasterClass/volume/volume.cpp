#include "volume.h"
#include "glwidget.h"

Point Volume::faceCentroid(const Object & object, const Face & face) {
	Point centroid;
	int n = face.numVertices();
	for (int i = 0; i < n; i++) {
		centroid += object.vertices()[face.vertexIndex(i)].coord();
	}
	return centroid / n;
}

float Volume::faceArea(const Object & object, const Face & face) {
	const Point & p0 = object.vertices()[face.vertexIndex(0)].coord();
	const Point & p1 = object.vertices()[face.vertexIndex(1)].coord();
	const Point & p2 = object.vertices()[face.vertexIndex(2)].coord();
	return Vector::crossProduct(p1 - p0, p2 - p0).length() / 2;
}

float Volume::objectVolume(const Object & object) {
	float volume = 0;
	for (const Face & face : object.faces()) {
		const Point & C = faceCentroid(object, face);
		const Vector & N = face.normal();
		float A = faceArea(object, face);
		volume += C.y() * N.y() * A;
	}
	return volume;
}

void Volume::onPluginLoad()
{
	const vector <Object> & objects = glwidget()->scene()->objects();
	if (objects.size() > 0) {
		cout << "Volume: " << objectVolume(objects[0]) << endl;
	}
}

void Volume::preFrame()
{
	
}

void Volume::postFrame()
{
	
}

void Volume::onObjectAdd()
{
	
}

bool Volume::drawScene()
{
	return false; // return true only if implemented
}

bool Volume::drawObject(int)
{
	return false; // return true only if implemented
}

bool Volume::paintGL()
{
	return false; // return true only if implemented
}

void Volume::keyPressEvent(QKeyEvent *)
{
	
}

void Volume::mouseMoveEvent(QMouseEvent *)
{
	
}
