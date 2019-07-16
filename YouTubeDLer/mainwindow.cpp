#include "mainwindow.h"


MainWindow::MainWindow(string infilename, string outdir, int wid, QWidget *parent) : QMainWindow(parent) {
  
  finfilename = infilename;
  foutdir = outdir;
  firstload = false;
  firstTimeShown = true;
  
  hh = 30;
  ww = wid*0.99;
  ww2 = 960;  
  ndownrunning = 0;
  
  this->setSizePolicy(QSizePolicy(QSizePolicy::Expanding,QSizePolicy::Expanding));
  this->setContentsMargins(0,0,0,0);
  this->setStyleSheet("QWidget {background-color: #333333;color: #fffff8;} ");

  tw = new QTableWidget(1,3);
  tw->horizontalHeader()->setStretchLastSection(true);
  tw->setHorizontalHeaderLabels(QStringList() << tr("Song") << tr("Operation") << tr("Progress"));
  int w1 = ww*(8.0/10.5);
  int w2 = ww*(1.0/10.5);
  printf("%i \t %i \n",w1,w2);
  tw->setColumnWidth(0, w1);
  tw->setColumnWidth(1, w2);
  tw->setColumnWidth(2, w2);
  tw->setStyleSheet("QWidget {background-color: #333333;color: #fffff8;}  QHeaderView::section {background-color: #646464;padding: 4px;border: 1px solid #fffff8;font-size: 10pt;}  QTableWidget { gridline-color: #fffff8;font-size: 12pt;} QTableWidget QTableCornerButton::section { background-color: #646464; border: 1px solid #fffff8; }");
  
  keyCtrlP = new QShortcut(this); 
  keyCtrlQ = new QShortcut(this); 
  keyCtrlD = new QShortcut(this); 
  window = new QWidget();
  layout = new QVBoxLayout();

  keyCtrlP->setKey(Qt::CTRL + Qt::Key_P); 
  connect(keyCtrlP, SIGNAL(activated()), this, SLOT(slotShortcutCtrlP()));

  keyCtrlQ->setKey(Qt::CTRL + Qt::Key_Q); 
  connect(keyCtrlQ, SIGNAL(activated()), this, SLOT(slotShortcutCtrlQ()));

  keyCtrlD->setKey(Qt::CTRL + Qt::Key_D); 
  connect(keyCtrlD, SIGNAL(activated()), this, SLOT(rundownloader()));

  QTimer::singleShot(0, this, SIGNAL(appStarting()));

  layout->setSpacing(0);
  layout->setMargin(0);
  layout->setContentsMargins(0,0,0,0);
  layout->addWidget(tw);
		  
  window->setStyleSheet("margin: 0px; padding: 0px;");
  window->setLayout(layout);
  window->setStyleSheet("margin: 0px; padding: 0px;");

  this->setCentralWidget(window);

  int readcnt = 0;
  string line;
  ifstream infile(finfilename.c_str());
  while(getline(infile,line)) {
    fentries.push_back(new FileEntry(foutdir,tw,line,readcnt));
    readcnt++;
  }
  infile.close();

  window->resize(ww,hh*(fentries.size()+1));
  resize(ww,hh*(fentries.size()+1));
  window->setFixedSize(ww,hh*(fentries.size()+1));
  setFixedSize(ww,hh*(fentries.size()+1));

}

MainWindow::~MainWindow() {
}

void MainWindow::slotShortcutCtrlP() {
  ((QProgressBar*)tw->cellWidget(0,2))->setValue(pcnt*10);
  pcnt++;
}

void MainWindow::slotShortcutCtrlQ() {
  QApplication::quit();
}

void MainWindow::updateName(const TitleHolder *tname, const int &id) {
  string out = tname->text().toStdString();
  fentries[id]->fname = out;
  printf("%s\n",out.c_str());
}


void MainWindow::show()
{
  QMainWindow::show();
  QApplication::processEvents();
  emit windowShown();
  if (firstTimeShown == true) {
    firstTimeShown = false;
    emit windowLoaded();
  }
}


void MainWindow::rundownloader() {
    
  for(int i=0; i<fentries.size(); i++) {
    //connect(down[i], &Downloader::resultReady, this, &MainWindow::tempFun);
    //connect(fentries[i]->downloader, &Downloader::supdate, this, &MainWindow::downloadupdate);
    //retrydownload:
    if(ndownrunning<4 && !fentries[i]->fstarted) {
      connect(fentries[i]->downloader, &Downloader::successDownload, this, &MainWindow::downloadsuccessupdate);
      //pool->start(fentries[i]);
      fentries[i]->run();
      ndownrunning++;
    }
      //else {
      //usleep(200000);
      //goto retrydownload;
      //}
    
  }
  
}

void MainWindow::downloadsuccessupdate() {
  ndownrunning--;
  //printf("SUCCESS!!!\n");
  rundownloader();
}

