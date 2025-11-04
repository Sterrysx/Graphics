#ifndef _FRAMERATE_H
#define _FRAMERATE_H

#include "plugin.h" 
#include <QElapsedTimer>
#include <QTimer>

class FrameRate: public QObject, public Plugin
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
  public slots:
	void updateFPS();
  private:
	QTimer timer;
	int frames;
};

#endif
