import ddf.minim.*;  //minimライブラリのインポート
Minim minim;  //Minim型変数であるminimの宣言

//AudioPlayer vocal;
Track []orche = new Track[5];

float startSec = 59;
float nowSec = 0;

final int ON = 1;
final int OFF = 0;
int startSw = OFF;

void setup() {
  size(900, 700);
  minim = new Minim(this);  //初期化(setupの中じゃないといけないらしい)

  //バラオケの初期化
  for (int i=0; i<5; i++) {
    orche[i] = new Track(i);
  }
}


void draw() {
  background(0);
  orchePlay(0);

  nowSec = second();//毎フレーム秒を記録
  //このコード進行をループする
  if ( startSw==ON ) {
    orche[0].sw = ON;//オケを再生
    startSw = OFF;
  } else if ( nowSec-startSec==29 | (nowSec+60)-startSec==29 ) {//巻き戻し
    startSec = second();
    startSw = ON;
  }
}


//スケッチのプロセスが終わったら実行されるらしい。
void stop() {
  for (int i=0; i<5; i++) {
    orche[i].sound.close();  //サウンドデータを終了
    minim.stop();
  }
  super.stop();
}

void mousePressed() {
  //もし、マウスが四角形ボタンの範囲内だったら、
  if (mouseX > 50 && mouseX < 150 && mouseY > 50 && mouseY < 150) {
    fill(255, 0, 0);  //赤で描画
    rect(50, 50, 150, 150);
    startSw = ON;

    //開始時刻を記録
    startSec = second();
    println("start = "+startSec);
  }
}

void mouseReleased() {
  fill(0, 255, 0);  //マウスを放したら元に戻る
}

