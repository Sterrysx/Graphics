#include "ModelInfo.h"
#include "glwidget.h"

void ModelInfo::printModelInfo() {
	Scene* scn = scene();
	int nObj = scn->objects().size();
	int nPoly = 0, nVer = 0, nTri = 0;

	for (int i = 0; i < nObj; i++) {
		const Object& obj = scn->objects()[i];
		int nfaces = obj.faces().size();
		nPoly += nfaces;
		for (int j = 0; j < nfaces; j++) {
			const Face& face = obj.faces()[j];
			nVer += face.numVertices();
			if (face.numVertices()%3 == 0) nTri++;
		}
	}

	cout << "INFO:" << endl;
	cout << " - Num objectes: " << nObj << endl;
	cout << " - Num polígons: " << nPoly << endl;
	cout << " - Num vèrtexs: " << nVer << endl;
	cout << " - Num triangles: " << nTri << endl;
	if (nPoly!=0) cout << " - Percentatge de triangles: " << double(nTri/nPoly) * 100 << '%' << endl;
	else cout << " - Percentatge de triangles: NULL" << endl;
}


void ModelInfo::onPluginLoad()
{
	printModelInfo();
}

void ModelInfo::preFrame()
{

}

void ModelInfo::postFrame()
{

}

void ModelInfo::onObjectAdd()
{
		printModelInfo();

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

