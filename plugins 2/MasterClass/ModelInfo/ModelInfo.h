#ifndef _MODELINFO_H
#define _MODELINFO_H

#include "plugin.h" 
#include <QPainter>

class ModelInfo: public QObject, public Plugin
{
	Q_OBJECT
	Q_PLUGIN_METADATA(IID "Plugin") 
	Q_INTERFACES(Plugin)

  public:
	 void onPluginLoad();
	 void preFrame();
	 void postFrame();

	 void onObjectAdd();
	 bool drawScene();
	 bool drawObject(int);

	 bool paintGL();

	 void keyPressEvent(QKeyEvent *);
	 void mouseMoveEvent(QMouseEvent *);
  private:
	int objectCount;
	int vertexCount;
	int faceCount;
	int triangleCount;
	void computeInfo();
	void printInfo();
	QPainter painter;
	void drawInfo();
};

#endif
