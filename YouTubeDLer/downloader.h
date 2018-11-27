#ifndef DOWNLOADER_H
#define DOWNLOADER_H

#include "stdio.h"
#include <fstream>
#include <iostream>
#include <string>
#include <vector>
#include <unistd.h>
#include <sys/stat.h>

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

class Downloader : public QThread
{
  
  Q_OBJECT

 public:
  Downloader();
  Downloader(string url, string out, int id);
  ~Downloader();
  inline void setURL(string url){furl = url;};
  inline void setID(int id) {fID = id;};
  inline void setOUT(string out) {fout = out;};
  string furl;
  string fout;
  int fID;

 private:
  
  QProcess process;
  void run();
  
 private slots:
  void runupdate();
 signals:
  void resultReady(const int &id, const char* song);
  void supdate(const char* percent, const int &id);
  void successDownload();
    
};


#endif
