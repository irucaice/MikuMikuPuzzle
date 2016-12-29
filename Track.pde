class Track {
  AudioPlayer sound;  //サウンドデータ格納用の変数
  int order;

  //コンストラクタ
  Track(int n) {
    order = n;
    //----歌の欠片を登録-----------------------
    //ファイルが配列分揃ったら sound = minim.loadFile("data/orche/cm"+n+".wav");
    sound = minim.loadFile("data/track/track00.wav");
  }
}

//------------------------------------------------------------
//wav単体を鳴らす
void trackPlay(int n) {
  orche[n].sound.play();  //再生
  orche[n].sound.rewind();  //再生が終わったら巻き戻しておく
}

void orchePlay() {
  if (time==start) trackPlay( 0 );
}
