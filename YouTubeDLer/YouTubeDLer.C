#include <QApplication>
#include <QMainWindow>
#include <QScreen>
#include <QScrollArea>
#include <QProcess>
#include <QMenu>
#include <QtCore>
#include <QObject>
#include <QVBoxLayout>
#include <QPlainTextEdit>
#include <QLineEdit>
#include <QPushButton>
#include <QProgressBar>
#include <QSlider>
#include <QShortcut>
#include "mainwindow.h"

#include <QScreen>

MainWindow *mainWindow = 0;
QProcess process;
QPlainTextEdit *plainTextEdit = 0;
QProgressBar *progressBar = 0;
QProgressBar *progressBar2 = 0;
int cnt = 0;

int main(int argc, char **argv) {

  QApplication app (argc, argv);
  QRect screenrect = app.primaryScreen()->geometry();
  mainWindow = new MainWindow("/home/dulain/Music/messorem.txt","/home/dulain/Music/Messorem/",screenrect.width());
  mainWindow->move(screenrect.left(), screenrect.top());
  mainWindow->show();
  
  return app.exec();
  
}
