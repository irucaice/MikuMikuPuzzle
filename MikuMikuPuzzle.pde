import ddf.minim.*;  //minimライブラリのインポート
Minim minim;  //Minim型変数であるminimの宣言

Piece []piece = new Piece[32];  //サウンドデータ格納用の変数
int []pieceOrder = new int [32];
Track []orche = new Track[5];

float time = 0;
float start = 100;
float interval = 44; //4で割り切れる数にしろ！！！！！

void setup() {
  size(900, 700);
  minim = new Minim(this);  //初期化(setupの中じゃないといけないらしい)
  //歌の欠片初期化
  for (int i=0; i<32; i++) {
    piece[i] = new Piece(i);
    pieceOrder[i] = i;
  }
//バラオケの初期化
  for (int i=0; i<5; i++) {
    orche[i] = new Track(i);
  }

  //order　shuffle
  FisherYatesShuffle(pieceOrder);
  println("---------------------");
  println(pieceOrder);

  //シャッフルで決まった順番を歌の欠片に告げる
  for (int i=0; i<32; i++) {
    piece[i].order = pieceOrder[i];
  }
}

void FisherYatesShuffle( int[] array ) {
  for (int i=array.length-1; i>=1; i--) {
    int j = (int)random(0, i+1);
    int temp = array[j];
    array[j] = array[i];
    array[i] = temp;
  }
}

void draw() {
  background(0);
  orchePlay();
  melodyPlay();
}


//スケッチのプロセスが終わったら実行されるらしい。
void stop() {
  for (int i=0; i<32; i++) {
    piece[i].voice.close();  //サウンドデータを終了
    minim.stop();
  }
  super.stop();
}

void mousePressed() {
  //もし、マウスが四角形ボタンの範囲内だったら、
  if (mouseX > 50 && mouseX < 150 && mouseY > 50 && mouseY < 150) {

    fill(255, 0, 0);  //赤で描画
  }
}

void mouseReleased() {
  fill(0, 255, 0);  //マウスを放したら元に戻る
}

