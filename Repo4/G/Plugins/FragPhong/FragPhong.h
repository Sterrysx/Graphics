#ifndef _FRAGPHONG_H
#define _FRAGPHONG_H

#include "plugin.h" 

class FragPhong: public QObject, public Plugin
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
	QOpenGLShaderProgram * program;
    QOpenGLShader * fs, * vs; 
};

#endif
