#ifndef _RESSALTARSELECCIONAT_H
#define _RESSALTARSELECCIONAT_H

#include "plugin.h" 

class RessaltarSeleccionat: public QObject, public Plugin
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

	 void createCube();
  private:
	GLuint cube_VAO;
	GLuint coordBuffer;
	GLuint colorVBO;


	QOpenGLShaderProgram *program;
	QOpenGLShader *fshader;
	QOpenGLShader *vshader;
	bool created;
};

#endif
