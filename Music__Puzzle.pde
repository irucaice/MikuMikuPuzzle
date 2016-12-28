import ddf.minim.*;  //minimライブラリのインポート
 
Minim minim;  //Minim型変数であるminimの宣言
AudioPlayer []player = new AudioPlayer[32];  //サウンドデータ格納用の変数
 
void setup(){
  size(100, 100);
  minim = new Minim(this);  //初期化
  player[0] = minim.loadFile("audio1.wav");  //ロードする
}
 
void draw(){
  background(0);
  rect(50, 50, 100, 100);  //ボタンを描画
}

//スケッチのプロセスが終わったら実行されるらしい。
void stop(){
  player[0].close();  //サウンドデータを終了
  minim.stop();
  super.stop();
}

void mousePressed() {
  //もし、マウスが四角形ボタンの範囲内だったら、
  if (mouseX > 50 && mouseX < 150 && mouseY > 50 && mouseY < 150) {
 
    fill(255, 0, 0);  //赤で描画
 
    player[0].play();  //再生
    player[0].rewind();  //再生が終わったら巻き戻しておく
  }
}
 
void mouseReleased() {
  fill(0, 255, 0);  //マウスを放したら元に戻る
}
