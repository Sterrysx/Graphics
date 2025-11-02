#include "FrameRate.h"
#include "glwidget.h"

void FrameRate::updateFPS()
{
	cout << "FPS: " << frames << endl;
	frames = 0;
}

void FrameRate::onPluginLoad()
{
	frames = 0;
	connect(&timer, SIGNAL(timeout()), this, SLOT(updateFPS()));
    timer.setInterval(1000);
    timer.start();
}

void FrameRate::preFrame()
{
	frames += 1;
}

void FrameRate::postFrame()
{
	
}

void FrameRate::onObjectAdd()
{
	
}

bool FrameRate::drawScene()
{
	return false; // return true only if implemented
}

bool FrameRate::drawObject(int)
{
	return false; // return true only if implemented
}

bool FrameRate::paintGL()
{
	return false; // return true only if implemented
}

void FrameRate::keyPressEvent(QKeyEvent *)
{
	
}

void FrameRate::mouseMoveEvent(QMouseEvent *)
{
	
}

