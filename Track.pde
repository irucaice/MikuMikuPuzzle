class Track {
  AudioPlayer sound;  //サウンドデータ格納用の変数
  int start;//オケを鳴らし始める合図
  boolean playing;//鳴っているかどうかの状態

  //コンストラクタ
  Track(int n) {
    //----歌の欠片を登録-----------------------
    //ファイル読み込み
    sound = minim.loadFile("data/track/track"+n+".wav");
    start = OFF;
    playing = false;
  }
}

//------------------------------------------------------------
//wav単体を鳴らす
void trackPlay(int n) {
  orche[n].sound.loop();  //再生
  orche[n].start = OFF;
  orche[n].sound.rewind();  //再生が終わったら巻き戻しておく
}

void orchePlay(int n) { //startONの状態は最初の一回だけ
  if (orche[n].start==ON) trackPlay( n );
}

//----------各トラックスタート
void trackStart(int n) {//ミュージックスタート  //----------------kokokoko
  orche[n].start = ON;//オケを再生
  orche[n].playing = true;  //鳴っている状態はtrue
}

