#include "ShowColor.h"
#include "glwidget.h"

void ShowColor::showColor()
{
	QFont font;
	int size = 15;
	font.setPixelSize(size);
	painter.begin(glwidget());
	painter.setFont(font);
	painter.drawText(0, 1 * size, QString("Color RGB: ")
		+ QString::number(color[0]) + " "
		+ QString::number(color[1]) + " "
		+ QString::number(color[2]));
	painter.end();
}

void ShowColor::postFrame()
{
	showColor();
}

void ShowColor::mousePressEvent(QMouseEvent * event)
{
	GLWidget & widget = * glwidget();
	widget.makeCurrent();
	int x = event->x();
	int y = widget.height() - event->y();
	glReadPixels(x, y, 1, 1, GL_RGB, GL_UNSIGNED_BYTE, color);
}
