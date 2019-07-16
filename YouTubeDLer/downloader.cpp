#include "downloader.h"

Downloader::Downloader() {
  debug = true;
}

Downloader::Downloader(string url, string out, int id) {
  furl = url;
  fout = out;
  fID = id;
}

Downloader::~Downloader() {
}

void Downloader::runupdate() {
  string tmp = process.readAllStandardOutput().toStdString();
  //std::cout << "COUT: " << tmp << std::endl;
  emit supdate(tmp.c_str(),fID);
}

void Downloader::run() {
  if(debug) cout << __PRETTY_FUNCTION__ << endl;

  emit startingDownload();
  
  char * homedir = getenv("HOME");
  
  string cmd = homedir + (string)"/Lynx/YouTubeDLer/getMP3 " + furl + (string)" " + fout;
  //string cmd = (string)"/home/dulain/qtPrograms/test5/tscript " + furl + (string)" " + fout;
  string outnmae = fout + (string)".mp3";

  QObject::connect(&process, SIGNAL(readyReadStandardOutput()), this, SLOT(runupdate()));  
  std::cout << "CMD: " << cmd << std::endl;
  process.start(cmd.c_str());
  process.waitForFinished(-1);
    
  //resultReady(fID,process.readAllStandardOutput());
  process.close();

  emit successDownload();

}
