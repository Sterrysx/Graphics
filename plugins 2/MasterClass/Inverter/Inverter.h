#ifndef _INVERTER_H
#define _INVERTER_H

#include "plugin.h" 

class Inverter: public QObject, public Plugin
{
	Q_OBJECT
	Q_PLUGIN_METADATA(IID "Plugin") 
	Q_INTERFACES(Plugin)

  public:
	void onPluginLoad();
	void preFrame();

  private:
  	QVector2D mousePosition;
	void linkShaders();
	QOpenGLShaderProgram * program;
    QOpenGLShader * fs, * vs;
    void mousePressEvent(QMouseEvent *);
};

#endif
