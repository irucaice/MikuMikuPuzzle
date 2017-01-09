class Figure {
  int box_width;
  int box_height;
  int posX;
  int posY;
  int sw = OFF;
  int angle = 0;
  int count = 0;
  int colorSw = 0;
  //コンストラクタ
  Figure() {
    posX = -50;
    posY = -50;
    box_width = 0;
    box_height = 0;
  }

  //interaction------------------------------------------------------------
  void interactDraw() {
    if (sw==ON) {
      count++;
      box_width = 30+(count)*46;//正方形なので実質widthしかいらないｗ
      angle = count*6;
      noFill();
      if (colorSw==0) {//交互に色を変える
        stroke(169, 61, 140);
      } else if(colorSw==1){
        stroke(173, 174, 86);
      }else if(colorSw==2){
        stroke(81, 155, 173);
      }
      pushMatrix();
       rectMode(CENTER);
       translate(posX, posY);
       rotate(radians(angle));
       rect( 0, 0, box_width, box_width );
       rectMode(CORNER);
      popMatrix();
      if (1100<box_width) {//枠外に出たらリセット
        count = 0;
        sw = OFF;
      }
    }
  }

  void interactStart( int x, int y ) {//クリックした瞬間一度だけ処理
    posX = x;
    posY = y;
    sw = ON;
    colorSw = (int)random(3);
  }
}

