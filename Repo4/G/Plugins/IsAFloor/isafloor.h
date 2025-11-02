#ifndef _ISAFLOOR_H
#define _ISAFLOOR_H

#include "plugin.h" 

class IsAFloor: public QObject, public Plugin
{
	Q_OBJECT
	Q_PLUGIN_METADATA(IID "Plugin") 
	Q_INTERFACES(Plugin)

  public:
	void onPluginLoad();
	void preFrame();
	void onObjectAdd();

  private:
  	float lambda;
	float computeLambda(const Object & object);
	void showLambda();
	void linkShaders();
	QOpenGLShaderProgram * program;
    QOpenGLShader * fs, * vs; 
};

#endif
