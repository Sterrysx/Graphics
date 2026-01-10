#ifndef _SHOWCOLOR_H
#define _SHOWCOLOR_H

#include "plugin.h" 
#include <QPainter>

class ShowColor: public QObject, public Plugin
{
	Q_OBJECT
	Q_PLUGIN_METADATA(IID "Plugin") 
	Q_INTERFACES(Plugin)

  public:
	 void postFrame();
	 void mousePressEvent(QMouseEvent *);
	 
  private:
	QPainter painter;
	GLubyte color[3];
	void showColor();
};

#endif
