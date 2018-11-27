#ifndef TITLEHOLDER_H
#define TITLEHOLDER_H

#include "stdio.h"
#include <fstream>
#include <iostream>
#include <string>
#include <vector>
#include <unistd.h>

#include <QLineEdit>
#include <QKeyEvent>

class TitleHolder : public QLineEdit {

  Q_OBJECT
  
 public:

  int id;
  TitleHolder(int iid);
  ~TitleHolder();

 public slots:
  
  void keyPressEvent(QKeyEvent *keyevt);

 signals:

  void updateNameText(const TitleHolder *tname);
  
};

#endif
