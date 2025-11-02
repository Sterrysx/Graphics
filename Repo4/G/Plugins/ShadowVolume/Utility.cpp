#include <Utility.h>

void Utility::linkShaders(QObject * object,
		QOpenGLShaderProgram ** program,
		const char * vertexShaderFilename,
		const char * geometryShaderFilename, 
		const char * fragmentShaderFilename) {
	(* program) = new QOpenGLShaderProgram(object);

	if (vertexShaderFilename != NULL) {
		QOpenGLShader * vertexShader;
		vertexShader = new QOpenGLShader(QOpenGLShader::Vertex, object);
		vertexShader->compileSourceFile(vertexShaderFilename);
		cout << "Compiled VS:  \"" << vertexShaderFilename << "\"" << endl
		     << vertexShader->log().toStdString();
		(* program)->addShader(vertexShader);
	}
	
	if (geometryShaderFilename != NULL) {
		QOpenGLShader * geometryShader;
		geometryShader = new QOpenGLShader(QOpenGLShader::Geometry, object);
		geometryShader->compileSourceFile(geometryShaderFilename);
		cout << "Compiled GS:  \"" << geometryShaderFilename << "\"" << endl
		     << geometryShader->log().toStdString();
		(* program)->addShader(geometryShader);
	}
	
	if (fragmentShaderFilename != NULL) {
		QOpenGLShader * fragmentShader;
		fragmentShader = new QOpenGLShader(QOpenGLShader::Fragment, object);
		fragmentShader->compileSourceFile(fragmentShaderFilename);
		cout << "Compiled FS:  \"" << fragmentShaderFilename << "\"" << endl
		     << fragmentShader->log().toStdString();
		(* program)->addShader(fragmentShader);
	}

	(* program)->link();
	cout << "Linked shader program" << endl
	     << (* program)->log().toStdString();
}
