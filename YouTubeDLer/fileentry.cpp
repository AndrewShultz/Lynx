
#include "fileentry.h"

FileEntry::FileEntry(string outdir, QTableWidget *parent, string link, int inid) {

  debug = false;

  foutdir = outdir;
  flink = link;
  fdownloaded = false;
  fstarted = false;
  id = inid;//parent->rowCount()-1;
  //printf("ID: %i \n",id);

  translator = new Translator();
  translator->setURL(link);
  translator->setID(id);
  connect(translator, &Translator::resultReady, this, &FileEntry::setName);

  downloader = new Downloader();
  //connect(this, &FileEntry::startDownload, this, &FileEntry::downloadingStatus);
  connect(downloader, &Downloader::startingDownload, this, &FileEntry::downloadingStatus);
  connect(this, &FileEntry::startDownload, downloader, &Downloader::run);
  connect(downloader, &Downloader::supdate, this, &FileEntry::downloadupdate);
  connect(downloader, &Downloader::successDownload, this, &FileEntry::downloadsuccessupdate);

  statustext = new QLineEdit();
  statustext->setReadOnly(true);
  statustext->setText("Loading...");
  statustext->setStyleSheet("QWidget {background-color: #333333;color: #fffff8;} ");

  progressBar = new QProgressBar();
  progressBar->setRange(0, 100);
  progressBar->setValue(0);
  progressBar->setAlignment(Qt::AlignCenter);
  progressBar->setStyleSheet("QWidget {background-color: #333333;color: #fffff8; selection-background-color: green;} ");

  //QPlainTextEdit *songtext = new QPlainTextEdit();
  songtext = new TitleHolder(id);
  //songtext->setReadOnly(true);
  //songtext->document()->setPlainText(fentries[row]->fname.c_str());
  songtext->setText("");
  songtext->setStyleSheet("QWidget {background-color: #333333;color: #fffff8;} ");
  connect(songtext,&TitleHolder::updateNameText,this,&FileEntry::updateName);

  //parent->setRowCount(id+1);
  if((id+1)>parent->rowCount()) parent->insertRow(id);
  parent->setCellWidget(id,0,songtext);
  parent->setCellWidget(id,1,statustext);
  parent->setCellWidget(id,2,progressBar);

  translator->start();

  //checkExistingFiles();

}

FileEntry::~FileEntry() {

}

void FileEntry::setName(const char* song) {
  fname = song;
  songtext->setText(song);
  statustext->setText("Loaded (waiting)");
  checkExistingFiles();
}


void FileEntry::updateName(const TitleHolder *tname) {
  if(debug) printf("FileEntry::updateName()\n");
  string oldstr = foutdir + fname;
  fname = tname->text().toStdString();
  if(fdownloaded) {
    oldstr += (string)".mp3";
    string newstr = foutdir + fname + (string)".mp3";
    rename(oldstr.c_str(),newstr.c_str());
  }

}

void FileEntry::downloadingStatus() {
  //if(!fdownloaded) {
    statustext->setText("Dowloading");
    //this->update();
    //}
}

void FileEntry::run() {
  fstarted = true;
  if(!fdownloaded) {
    //statustext->setText("Dowloading");
    //downloader = new Downloader(flink,outstr,id);
    string outstr = foutdir + fname;
    downloader->setURL(flink);
    downloader->setID(id);
    downloader->setOUT(outstr);
    statustext->setText("Dowloading");
    emit startDownload();
    //downloader->start();
  }
}

void FileEntry::downloadupdate(const char* percent, const int &id) {
  //printf("ID: %i \t PERCENT: %.3f \n",id,atof(percent));
  progressBar->setValue(atof(percent));
}

void FileEntry::downloadsuccessupdate() {
  string fulltitle = foutdir + fname + (string)".mp3";
  if(!doesItExist(fulltitle)) {
    statustext->setText("Failed");
    statustext->setStyleSheet("QWidget {background-color: #ff0000;color: #000000;} ");
    songtext->setStyleSheet("QWidget {background-color: #ff0000;color: #000000;} ");
    progressBar->setStyleSheet("QWidget {background-color: #ff0000;color: #000000; selection-background-color: red;} ");
    fdownloaded = false;
  }
  else {
    songtext->setStyleSheet("QWidget {background-color: #00ff00;color: #000000;} ");
    statustext->setStyleSheet("QWidget {background-color: #00ff00;color: #000000;} ");
    statustext->setText("Downloaded");
    fdownloaded = true;
  }
  fstarted = false;
}

bool FileEntry::doesItExist(const std::string& name) {
  struct stat buffer;
  return (stat (name.c_str(), &buffer) == 0);
}

void FileEntry::checkExistingFiles() {
  struct dirent *entry;
  DIR *dir = opendir(foutdir.c_str());
  if (dir == NULL) {
    return;
  }

  while ((entry = readdir(dir)) != NULL) {
    string temp = entry->d_name;
    //printf("%s \t %s \t %.3f \n",entry->d_name,fname.c_str(),getLDist(fname.c_str(),temp.c_str()));
    double sim = getLDist(fname.c_str(),temp.c_str());
    if(sim>0.70) {
      songtext->setStyleSheet("QWidget {background-color: #00ff00;color: #000000;} ");
      statustext->setText("Downloaded");
      progressBar->setValue(100);
      string tempname = temp.substr(0,temp.find_last_of("."));
      songtext->setText(tempname.c_str());
      fname = tempname;
      fdownloaded = true;
    }
    //printf("%s \t %s \t %i \n",entry->d_name,fname.c_str(),ComputeLevenshteinDistance(fname,temp));
  }

  closedir(dir);
}


double FileEntry::getLDist(const char *s, const char *t) {

  int d[100][100];
  int i,j,m,n,temp,tracker;
  m = strlen(s);
  n = strlen(t);

  for(i=0;i<=m;i++)
    d[0][i] = i;
  for(j=0;j<=n;j++)
    d[j][0] = j;

  for (j=1;j<=m;j++)
    {
      for(i=1;i<=n;i++)
	{
	  if(s[i-1] == t[j-1])
	    {
	      tracker = 0;
	    }
	  else
	    {
	      tracker = 1;
	    }
	  temp = MIN((d[i-1][j]+1),(d[i][j-1]+1));
	  d[i][j] = MIN(temp,(d[i-1][j-1]+tracker));
	}
    }
  //printf("the Levinstein distance is %d\n",d[n][m]);
  //return d[n][m];

  if(m>n) return (1.0-double(d[n][m])/double(m));
  else return (1.0-double(d[n][m])/double(n));

}
