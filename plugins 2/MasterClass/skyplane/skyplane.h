#ifndef _SKYPLANE_H
#define _SKYPLANE_H

#include "plugin.h" 

class Skyplane: public QObject, public Plugin
{
	Q_OBJECT
	Q_PLUGIN_METADATA(IID "Plugin") 
	Q_INTERFACES(Plugin)

  public:
	 void onPluginLoad();
	 void postFrame();

	 void onObjectAdd();
	 bool drawScene();
	 bool drawObject(int);

	 bool paintGL();

	 void keyPressEvent(QKeyEvent *);
	 void mouseMoveEvent(QMouseEvent *);
  private:
  	QOpenGLShaderProgram * program;
	QOpenGLShader * vs, * fs;
	QOpenGLShaderProgram * programMir;
	QOpenGLShader * vsMir, * fsMir;
	void linkShaders();
	void loadText(GLWidget & g);
	GLuint textureId0;
	// add private methods and attributes here
};

#endif
