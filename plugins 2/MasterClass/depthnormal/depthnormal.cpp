#include "depthnormal.h"
#include "glwidget.h"

void Depthnormal::linkShaders()
{

	vsNorm = new QOpenGLShader(QOpenGLShader::Vertex, this);
	vsNorm->compileSourceFile("normal.vert");
	cout << "VS log:" << vsNorm->log().toStdString() << endl;
	
	fsNorm = new QOpenGLShader(QOpenGLShader::Fragment, this);
	fsNorm->compileSourceFile("normal.frag");
	
	programNorm = new QOpenGLShaderProgram(this);
	programNorm->addShader(vsNorm);
	programNorm->addShader(fsNorm);
	programNorm->link();

	vsDepth = new QOpenGLShader(QOpenGLShader::Vertex, this);
	vsDepth->compileSourceFile("depth.vert");
	cout << "VS log:" << vsDepth->log().toStdString() << endl;
	
	fsDepth = new QOpenGLShader(QOpenGLShader::Fragment, this);
	fsDepth->compileSourceFile("depth.frag");
	
	programDepth = new QOpenGLShaderProgram(this);
	programDepth->addShader(vsDepth);
	programDepth->addShader(fsDepth);
	programDepth->link();
	

}

void Depthnormal::onPluginLoad()
{
	GLWidget &g = *glwidget();
	g.makeCurrent();
	linkShaders();
	
}

void Depthnormal::preFrame()
{
	
}

void Depthnormal::postFrame()
{
	
}

void Depthnormal::onObjectAdd()
{
	
}

bool Depthnormal::drawScene()
{
	return false; // return true only if implemented
}

bool Depthnormal::drawObject(int)
{
	return false; // return true only if implemented
}

bool Depthnormal::paintGL()
{
	    GLWidget &g = *glwidget();
    g.makeCurrent();
    // Pass 1. Draw scene
    g.glClearColor(0,0,0,0);
    g.glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);

	int w = g.width();
	int h = g.height();
	float aspect = float(w) / float(h);

	camera()->setAspectRatio(aspect/2.0f);

	glViewport(0, 0, w/2, h);
    programDepth->bind();
    programDepth->setUniformValue("modelViewProjectionMatrix", g.camera()->projectionMatrix() * g.camera()->viewMatrix());
    // bind textures

	if (drawPlugin()) drawPlugin()->drawScene();
	programDepth->release();

	glViewport(w/2, 0, w/2, h);
    programNorm->bind();
    programNorm->setUniformValue("modelViewProjectionMatrix", g.camera()->projectionMatrix() * g.camera()->viewMatrix());

    if (drawPlugin()) drawPlugin()->drawScene();
   	programNorm->release();
	return true;
}

void Depthnormal::keyPressEvent(QKeyEvent *)
{
	
}

void Depthnormal::mouseMoveEvent(QMouseEvent *)
{
	
}

