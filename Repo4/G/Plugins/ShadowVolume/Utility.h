#include <QOpenGLShader>
#include <QOpenGLShaderProgram>
#include <iostream>

using namespace std;

class Utility {
	public:
		static void linkShaders(QObject * object,
			QOpenGLShaderProgram ** program,
			const char * vertexShaderFilename,
			const char * geometryShaderFilename, 
			const char * fragmentShaderFilename);
};
