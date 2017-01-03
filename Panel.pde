class Panel {
  int box_width;
  int box_height;
  int posX;
  int posY;
  int sw;//エディタオンオフスイッチ用
  int number;//歌詞用ナンバー
  int shuffledNumber;//歌詞shuffle用ナンバー
  PImage img;

  //色
  color lightBlue = color(190, 226, 255 );
  color blue = color(150, 190, 255, 180);  //半透明
  color darkBlue = color(110, 150, 255);
  color blackBlue = color(20, 40, 170);

  //スタートボタン・メータ用コンストラクタ
  Panel( int _posX, int _posY, int _box_width, int _box_height ) {
    posX = _posX;
    posY = _posY;
    box_width = _box_width;
    box_height = _box_height;
  }
  //歌詞パネル用コンストラクタ
  Panel( int _posX, int _posY, int _number, int _shuffledNumber, PImage _img ) {
    box_width = 160;
    box_height = 120;
    number = _number;
    shuffledNumber = _shuffledNumber;
    posX = SN[shuffledNumber].posX;
    posY = SN[shuffledNumber].posY;

    //----画像を登録-----------------------
    img = loadImage("data/lyrics/lyric"+number+".png");
  }

  //ボタン描画  ---------------------------------------------------------
  void startDraw() {
    stroke(80);//灰色
    strokeWeight(1);
    fill(0);
    rect(posX, posY, box_width, box_height);
    //カーソルが触れたら
    if (posX<mouseX && mouseX<posX+box_width && posY<mouseY && mouseY<posY+box_height) {
      noFill();
      strokeWeight(2);
      stroke(255);
      rect(posX+2, posY+2, box_width-4, box_height-4);
    }
    //三角形マーク--------------------------------------
    fill(255);
    noStroke();
    triangle( posX+13, posY+11, posX+41, posY+24, posX+13, posY+39);
  }

  //メーター描画  ---------------------------------------------------------
  void meterDraw() {
    //メーターの色をレベルごとに変える
    if (2<level && level<=4) {
      fill(167, 212, 241, 180);
    } else
      if (4<level && level<=7) {
      fill(162, 248, 221, 180);
    } else
      if (7<level && level<=10) {
      fill(179, 252, 134, 180);
    } else
      if (10<level && level<=13) {
      fill(253, 254, 130, 180);
    } else
      if (13<level && level<=16) {
      fill(254, 200, 85, 180);
    } else
      if (16<level) {
      fill(255, 125, 115, 180);
    } else {
      fill(183, 173, 255, 180);
    }
    rect(posX, posY, 37*level, box_height);
    //枠
    stroke(80);//灰色
    strokeWeight(1);
    noFill();
    rect(posX, posY, box_width, box_height);
  }

  //歌詞パネル描画  --------------------------------------------------------
  void lyricDraw() {
    stroke(70);//灰色
    strokeWeight(1);
    noFill();
    rect(posX, posY, box_width, box_height);
    //選択されたら着色--------------------------------------
    if ( select[0]==number | select[1]==number ) {
      fill(blue);
      rect(posX, posY, box_width, box_height);
    }
    //カーソルが触れたら枠----------------------------------
    if (posX<mouseX && mouseX<posX+box_width && posY<mouseY && mouseY<posY+box_height) {
      noFill();
      strokeWeight(2);
      stroke(144, 194, 251);
      rect(posX+1, posY+1, box_width-2, box_height-2);
    }
    //歌詞-----------------------------------------------
    fill(200);//灰色
    text( number, posX, posY+10 );
    image( img, posX+1, posY+-2 );
    //つねに変更がないか見張っておく-------------------------
    posX = SN[shuffledNumber].posX;
    posY = SN[shuffledNumber].posY;
  }
}
