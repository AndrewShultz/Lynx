#ifndef TRANSLATOR_H
#define TRANSLATOR_H

#include "stdio.h"
#include <fstream>
#include <iostream>
#include <string>
#include <vector>
#include <unistd.h>

#include <QApplication>
#include <QMainWindow>
#include <QShortcut>
#include <QMessageBox>
#include <QScrollArea>
#include <QVBoxLayout>
#include <QTableWidget>
#include <QProgressBar>
#include <QPlainTextEdit>
#include <QHeaderView>
#include <QProcess>
#include <QTimer>
#include <QThread>

using namespace std;

class Translator : public QThread
{
  
  Q_OBJECT

 public:
  Translator();
  ~Translator();
  void setURL(string url);
  void setID(int id);
  string furl;
  int fID;

 private:
  void run();
 signals:
  void resultReady(const char* song);
  
};


#endif
