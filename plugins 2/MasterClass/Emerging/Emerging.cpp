#include "Emerging.h"
#include "glwidget.h"
#include <cmath>


void Emerging::linkShaders()
{

	vs = new QOpenGLShader(QOpenGLShader::Vertex, this);
	vs->compileSourceFile("Emerging.vert");
	cout << "VS log:" << vs->log().toStdString() << endl;
	
	fs = new QOpenGLShader(QOpenGLShader::Fragment, this);
	fs->compileSourceFile("Emerging.frag");
	
	program = new QOpenGLShaderProgram(this);
	program->addShader(vs);
	program->addShader(fs);
	program->link();
	

}

void Emerging::onPluginLoad()
{
	GLWidget &g = *glwidget();
    	g.makeCurrent();
	linkShaders();
	t.start();
}

void Emerging::preFrame()
{
	GLWidget &g = *glwidget();
	g.makeCurrent();
	program->bind();

	
	
	
	float temps = t.elapsed()/1000.f;
	float d= fmod(temps,2.0);
	float files=0;
	if(d <=1.f){
		files =0*(1-d)+(float)(g.height())*d; 
	
	}else{
	
		files =0*d+(float)(g.height())*(2-d); 	
		cout<<"files: "<<files<<endl;
	}
	QMatrix4x4 MVP = camera()->projectionMatrix() * camera()->viewMatrix();
    program->setUniformValue("modelViewProjectionMatrix", MVP);
	QMatrix3x3 normalMatrix = camera()->viewMatrix().normalMatrix();
	program->setUniformValue("normalMatrix", normalMatrix);
    program->setUniformValue("files",files);

    	
}

void Emerging::postFrame()
{
	program->release();
}

void Emerging::onObjectAdd()
{
	
}

bool Emerging::drawScene()
{
	return false; // return true only if implemented
}

bool Emerging::drawObject(int)
{
	return false; // return true only if implemented
}

bool Emerging::paintGL()
{
	return false; // return true only if implemented
}

void Emerging::keyPressEvent(QKeyEvent *)
{
	
}

void Emerging::mouseMoveEvent(QMouseEvent *)
{
	
}

