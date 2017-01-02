class ShuffledNumber {
  int posX;
  int posY;
  int n;
  ShuffledNumber(int _n) { //シャッフルナンバーが持つxy
    n = _n;
    //---座標を登録------------------------
    int yoko_aida = 160;
    int tate_aida = 120;
    if (n<5) {
      posX = 50+yoko_aida*n;
      posY = 150;
    }
    if (5<=n && n<10) {
      posX = 50+yoko_aida*(n-5);
      posY = 150+tate_aida;
    }
    if (10<=n && n<15) {
      posX = 50+yoko_aida*(n-10);
      posY = 150+tate_aida*2;
    }
    if (15<=n && n<20) {
      posX = 50+yoko_aida*(n-15);
      posY = 150+tate_aida*3;
    }
  }//-------------------------------
  
}

