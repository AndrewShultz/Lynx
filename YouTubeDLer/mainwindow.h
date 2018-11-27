#ifndef MAINWINDOW_H
#define MAINWINDOW_H

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
#include <QKeyEvent>
#include <QLineEdit>

#include "translator.h"
#include "downloader.h"

#include "fileentry.h"
#include "titleHolder.h"

class MainWindow : public QMainWindow {
  Q_OBJECT

 public:
  explicit MainWindow(string infilename, string outdir, int wid=1000, QWidget *parent = 0);
  void show();
  ~MainWindow();

  private slots:

    void slotShortcutCtrlP();
    void slotShortcutCtrlQ();
    
    void rundownloader();
    void updateName(const TitleHolder *tname, const int &id);
    void downloadsuccessupdate();
    
 signals:
      void windowShown();
      void windowLoaded();
      void appStarting();
      
 private:
      QShortcut       *keyCtrlP;
      QShortcut       *keyCtrlD;
      QShortcut       *keyCtrlQ;
      QWidget *window;
      QVBoxLayout *layout;
      string finfilename;
      int fcnt;
      int pcnt;
      QTableWidget *tw;
      bool firstload;
      bool firstTimeShown;
      string ftemptitle;
      string foutdir;

      vector<FileEntry*> fentries;
      
      int hh, ww, ww2;
      int ndownrunning;

};

#endif // MAINWINDOW_H
