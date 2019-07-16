
#include "translator.h"

Translator::Translator() {
  furl = "";
}

Translator::~Translator() {
}


void Translator::setURL(string url) {furl = url;}

void Translator::setID(int id) {fID = id;}

void Translator::run() {

  char * homedir = getenv("HOME");

  QProcess process;
  string cmd = homedir + (string)"/Lynx/YouTubeDLer/gettitle " + furl;
  //std::cout << "CMD: " << cmd << std::endl;
  process.start(cmd.c_str());
  //while(!process.waitForStarted());
  //bool retval = false;
  //QByteArray buffer;
  process.waitForFinished(-1);
  //while(!process.waitForFinished()) printf("PROC: %i \n",process.waitForFinished());
  resultReady(process.readAllStandardOutput());
  process.close();
  
}
