#include "FragPhong.h"
#include "glwidget.h"

void FragPhong::onPluginLoad()
{
    vs = new QOpenGLShader(QOpenGLShader::Vertex, this);
    vs->compileSourceFile("FragPhong.vert");
    cout << "VS log:" << vs->log().toStdString() << endl;

    fs = new QOpenGLShader(QOpenGLShader::Fragment, this);
    fs->compileSourceFile("FragPhong.frag");
    cout << "FS log:" << fs->log().toStdString() << endl;

    program = new QOpenGLShaderProgram(this);
    program->addShader(vs);
    program->addShader(fs);
    program->link();
    cout << "Link log:" << program->log().toStdString() << endl;
}

void FragPhong::preFrame()
{
	program->bind();
	QMatrix4x4 MV = camera()->viewMatrix();
    program->setUniformValue("modelViewMatrix", MV);
    QMatrix4x4 MVP = camera()->projectionMatrix() * camera()->viewMatrix();
    program->setUniformValue("modelViewProjectionMatrix", MVP);
    QMatrix3x3 N = camera()->viewMatrix().normalMatrix();
    program->setUniformValue("normalMatrix", N);
}

void FragPhong::postFrame()
{
	program->release();
}

void FragPhong::onObjectAdd()
{
	
}

bool FragPhong::drawScene()
{
	return false; // return true only if implemented
}

bool FragPhong::drawObject(int)
{
	return false; // return true only if implemented
}

bool FragPhong::paintGL()
{
	return false; // return true only if implemented
}

void FragPhong::keyPressEvent(QKeyEvent *)
{
	
}

void FragPhong::mouseMoveEvent(QMouseEvent *)
{
	
}

