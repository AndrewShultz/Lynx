
#include "titleHolder.h"

TitleHolder::TitleHolder(int iid) {
  id = iid;
}

TitleHolder::~TitleHolder() {

}

void TitleHolder::keyPressEvent(QKeyEvent *keyevt) {

  QLineEdit::keyPressEvent(keyevt);

  if(this->hasFocus()) {
    //printf("KEY PRESSSDSEDD!!! \n");
    emit updateNameText(this);
  }

}
