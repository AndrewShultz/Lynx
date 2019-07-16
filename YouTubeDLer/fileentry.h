#ifndef FILEENTRY_H
#define FILEENTRY_H

#include <stdio.h>
#include <math.h>
#include <string.h>
#include <stdio.h>
#include <dirent.h>
#include <sys/types.h>

#include <QLineEdit>

#include "translator.h"
#include "downloader.h"
#include "titleHolder.h"

#define MIN(x,y) ((x) < (y) ? (x) : (y))

using namespace std;

class FileEntry: public QObject {

  Q_OBJECT
  
 public:

  Translator* translator;
  Downloader* downloader;
  string flink;
  string fname;
  bool fdownloaded;
  bool fstarted;
  int id;
  bool debug;

  QLineEdit *statustext;
  QProgressBar *progressBar;
  TitleHolder *songtext;
  
  explicit FileEntry(string outdir, QTableWidget *parent, string link, int inid);
  ~FileEntry();

  bool doesItExist(const std::string& name);
  void run();

  void checkExistingFiles();
  double getLDist(const char *s, const char *t);
  //int ComputeLevenshteinDistance(string source, string target);
  
  private slots:
    void updateName(const TitleHolder *tname);
    void setName(const char* song);
    void downloadupdate(const char* percent, const int &id);
    void downloadsuccessupdate();
    void downloadingStatus();
 signals:
    void startDownload();
    
 private:
    string foutdir;
    
};


#endif
