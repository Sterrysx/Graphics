#ifndef _MYPLUGIN_H
#define _MYPLUGIN_H

#include "plugin.h" 

class MyPlugin: public QObject, public Plugin
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
	GLuint boxVAO;
	QOpenGLShaderProgram * program;
	QOpenGLShader * vs, * fs;
	void linkShaders();
	void createBox(GLWidget & widget);
	void drawBox(GLWidget & widget, const Box & box);
};

#endif
