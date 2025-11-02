#ifndef _OBJSEL_H
#define _OBJSEL_H

#include "plugin.h" 

class ObjSel: public QObject, public Plugin
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
	 void mouseReleaseEvent(QMouseEvent *);
  private:
  	GLuint boxId;
	QOpenGLShader * boxVertexShader, * boxFragmentShader;
	QOpenGLShaderProgram * boxShaderProgram;
	QOpenGLShaderProgram * selectionShaderProgram;
	QOpenGLShader * selectionVertexShader, * selectionFragmentShader;

	void createBox(GLWidget &);
	void linkBoxShaders();	
	void linkSelectionShaders();
	void drawBox(GLWidget &, const Box &);
};

#endif
