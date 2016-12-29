class Piece {
  AudioPlayer voice;  //サウンドデータ格納用の変数
  int no;
  int order;
  int posX;
  int posY;


  //[32]用のコンストラクタ
  Piece(int n) {
    no = n+1;//audio 番号
    order = n;
    //----歌の欠片を登録-----------------------
    voice = minim.loadFile("data/audio/audio"+(no)+".wav");
    //---座標を登録------------------------
    if (n<10) {
      posX = 20+350*n;
      posY = 150;
    }
    if (10<=n && n<20) {
      posX = 50+350*(n-10);
      posY = 180;
    }
    if (20<=n && n<30) {
      posX = 50+350*(n-20);
      posY = 210;
    }
    if (30<=n && n<40) {
      posX = 50+350*(n-30);
      posY = 240;
    }
  }

}
//------------------------------------------------------------


//wav単体を鳴らす
void wavPlay(int n) {
  piece[n].voice.play();  //再生
  piece[n].voice.rewind();  //再生が終わったら巻き戻しておく
}


//バラバラのメロディを演奏する
void melodyPlay() {
  if (time==start) wavPlay( pieceOrder[0] );
  if (time==start+interval) wavPlay( pieceOrder[1] );
  if (time==start+interval*2) wavPlay( pieceOrder[2] );
  if (time==start+interval*3) wavPlay( pieceOrder[3] );
  if (time==start+interval*4) wavPlay( pieceOrder[4] );
  if (time==start+interval*5) wavPlay( pieceOrder[5] );
  if (time==start+interval*6) wavPlay( pieceOrder[6] );
  if (time==start+interval*7) wavPlay( pieceOrder[7] );
  if (time==start+interval*8) wavPlay( pieceOrder[8] );
  if (time==start+interval*9) wavPlay( pieceOrder[9] );
  if (time==start+interval*10) wavPlay( pieceOrder[10] );
  if (time==start+interval*11) wavPlay( pieceOrder[11] );
  if (time==start+interval*12) wavPlay( pieceOrder[12] );
  if (time==start+interval*13) wavPlay( pieceOrder[13] );
  if (time==start+interval*14) wavPlay( pieceOrder[14] ); 
  if (time==start+interval*15) wavPlay( pieceOrder[15] );
  if (time==start+interval*16) wavPlay( pieceOrder[16] );
  if (time==start+interval*17) wavPlay( pieceOrder[17] );
  if (time==start+interval*18) wavPlay( pieceOrder[18] );
  if (time==start+interval*19) wavPlay( pieceOrder[19] );
  if (time==start+interval*20) wavPlay( pieceOrder[20] );
  if (time==start+interval*21) wavPlay( pieceOrder[21] );
  if (time==start+interval*22) wavPlay( pieceOrder[22] );
  if (time==start+interval*23) wavPlay( pieceOrder[23] );
  if (time==start+interval*24) wavPlay( pieceOrder[24] );
  if (time==start+interval*25) wavPlay( pieceOrder[25] );
  if (time==start+interval*26) wavPlay( pieceOrder[26] );
  if (time==start+interval*27) wavPlay( pieceOrder[27] );
  if (time==start+interval*28) wavPlay( pieceOrder[28] );
  if (time==start+interval*29) wavPlay( pieceOrder[29] );
  if (time==start+interval*30) wavPlay( pieceOrder[30] );
  if (time==start+interval*31) wavPlay( pieceOrder[31] );

  //このコード進行をループする
  if (time==start+interval*32) {
    time = start;
  } else {
    time++;
  }
}
