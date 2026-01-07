#include "Inverter.h"
#include "glwidget.h"


void Inverter::linkShaders()
{
    vs = new QOpenGLShader(QOpenGLShader::Vertex, this);
    vs->compileSourceFile("Inverter.vert");
    cout << "VS log:" << vs->log().toStdString() << endl;

    fs = new QOpenGLShader(QOpenGLShader::Fragment, this);
    fs->compileSourceFile("Inverter.frag");
    cout << "FS log:" << fs->log().toStdString() << endl;

    program = new QOpenGLShaderProgram(this);
    program->addShader(vs);
    program->addShader(fs);
    program->link();
    cout << "Link log:" << program->log().toStdString() << endl;
}

void Inverter::onPluginLoad()
{
	linkShaders();
}

void Inverter::preFrame()
{
	program->bind();
    QMatrix4x4 MVP = camera()->projectionMatrix() * camera()->viewMatrix();
    program->setUniformValue("modelViewProjectionMatrix", MVP);
    QMatrix3x3 N = camera()->viewMatrix().normalMatrix();
    program->setUniformValue("normalMatrix", N);
	program->setUniformValue("mousePosition", mousePosition);
}

void Inverter::mousePressEvent(QMouseEvent * event)
{
	GLWidget & widget = * glwidget();
	widget.makeCurrent();
	mousePosition[0] = event->x();
	mousePosition[1] = widget.height() - event->y();
}
