#include "ShowDegree.h"
#include "glwidget.h"

void ShowDegree::onPluginLoad()
{
	const Object &obj = scene()->objects()[0];
	const int nCares = obj.faces().size();
	const int nVertex = obj.vertices().size();
	grauMig = double(nCares*3)/nVertex;
}

void ShowDegree::preFrame()
{
	
}

void ShowDegree::postFrame()
{
	painter.begin(glwidget());
	QFont font;
	font.setPixelSize(15);
	painter.setFont(font);
	//painter.setPen(QColor(255,0,0));

	painter.drawText(5, 20, QString("%1").arg(grauMig));
	painter.end();
}

void ShowDegree::onObjectAdd()
{
	
}

bool ShowDegree::drawScene()
{
	return false; // return true only if implemented
}

bool ShowDegree::drawObject(int)
{
	return false; // return true only if implemented
}

bool ShowDegree::paintGL()
{
	return false; // return true only if implemented
}

void ShowDegree::keyPressEvent(QKeyEvent *)
{
	
}

void ShowDegree::mouseMoveEvent(QMouseEvent *)
{
	
}

