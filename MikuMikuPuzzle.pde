//やりたかったことがloop();で解決しましたお疲れ様です！！！
import promidi.*;//MIDIを扱う
import ddf.minim.*;  //minimライブラリのインポート
MidiIO midiIO;
MidiOut midiOut;//MIDIを送信する
Minim minim;  //Minim型変数であるminimの宣言

int orcheNum = 7;
//AudioPlayer;
Track []orche = new Track[orcheNum];
Track finishAudio;
Track spaanAudio;

//音楽スタートボタンとメーター
Panel startButton, meter;

//歌詞パネル
Panel [] lyric = new Panel [20];
//シャッフル用20個のxy格納
ShuffledNumber [] SN = new ShuffledNumber [20];
//選択しているパネル２つ
int []select = new int [2];

//traktorとのやりとり
MIDI traktorFX;

PImage mikuImage;
PImage endImage;

final int ON = 1;
final int OFF = 0;

//ドラムスタートのための変数
int musicSw = OFF;

//完成度
int level = 0;

//scene
final int FINISH = 1;
int scene = 0;
boolean fin = false;//エンド

void setup() {
  size(900, 700);
  //MIDI IOのあれこれ--------------------------------------
  //get an instance of MidiIO
  midiIO = MidiIO.getInstance(this);
  println("printPorts of midiIO");  
  //print a list of all available devices
  midiIO.printDevices();  
  //open the first midi channel of the first device
  midiIO.openInput(2, 0);
  //getMidiOut(midiChannel, outDeviceNumber);
  midiOut = midiIO.getMidiOut(0, "Traktor Virtual Input"); //ch1
  //------------------------------------------------------

  minim = new Minim(this);  //初期化(setupの中じゃないといけないらしい)
  //バラオケの初期化
  for (int i=0; i<orcheNum; i++) {
    orche[i] = new Track(i);
  }
  finishAudio = new Track(100);//最後のオーディオ
  spaanAudio = new Track();//スパーン
  startButton = new Panel( 50, 50, 50, 50 );//スタートボタンの初期化
  meter = new Panel( 110, 50, 740, 50 ); //メータの初期化

  //シャッフルナンバオブジェクト生成---------------------
  for (int i=0; i<20; i++) {
    SN[i] = new ShuffledNumber( i );
  }
  //shuffledNumberを決める---------------------
  int[] data = {
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19
  };
  FisherYatesShuffle(data);
  for (int i=0; i<20; i++) {
    lyric[i] = new Panel( 0, 0, i, data[i], null );//歌詞用パネルの初期化
  }
  //------------------------------------------
  select[0] = -1;
  select[1] = -1;
  //------------------------------------------
  traktorFX = new MIDI(); //MIDIを扱う
  mikuImage = loadImage("data/miku2.png");//miku
  endImage = loadImage("data/end.png");
}

void FisherYatesShuffle( int[] array ) {//-----------
  for (int i=array.length-1; i>=1; i--) {
    int j = (int)random(0, i+1);
    int temp = array[j];
    array[j] = array[i];
    array[i] = temp;
  }
}
//-------------------------------------------------------------------------
void draw() {
  background( scene==FINISH ? 255 : 0);//FINISHしたら白背景
  //--------------------------------
  if (finishAudio.playing==false) {//フィニッシュするまでオケ鳴らす
    for (int i=0; i<orcheNum; i++) {
      orchePlay(i);  //オケを鳴らす(ドラム含む全８種類)
    }
  } else {
    finish();
    int pos = finishAudio.sound.position();
    if (36000<pos) fin=true;//FINISHおわたらエンドロールへ
  }
  if (scene!=FINISH) waveDraw();//音声波形描画
  //miku----------------------
  tint( scene==FINISH ? 240 : 170);//FINISHしたら明るく
  scale(0.5);
  image(mikuImage, 600, 100);
  tint(255);
  scale(2);//miku------------
  startButton.startDraw(); //スタートボタン描画
  meter.meterDraw(); //メーター描画
  for (int i=0; i<20; i++) {//歌詞パネルを描画
    lyric[i].lyricDraw();
  }
  levelCheck();//レベル(完成度)管理
  if (fin) {//エンドロール
    fin();
  }
  printMemo();//デバック用
}
//-------------------------------------------------------------------------

//スケッチのプロセスが終わったら実行されるらしい。
void stop() {
  for (int i=0; i<orcheNum; i++) {
    orche[i].sound.close();  //サウンドデータを終了
    minim.stop();
  }
  finishAudio.sound.close();
  spaanAudio.sound.close();
  super.stop();
}
//-------------------------------------------------------------------------mousePressed()
void mousePressed() {
  //マウスがスタートボタンの範囲内だったら------------
  if (mouseX > startButton.posX && mouseX < startButton.posX+startButton.box_width && mouseY > startButton.posY && mouseY < startButton.posY+startButton.box_height) {
    trackStart(0);//ドラムならす
  }
  //歌詞パネルクリック判定--------------------------
  for (int i=0; i<20; i++) {
    if (lyric[i].posX<mouseX && mouseX<lyric[i].posX+lyric[0].box_width && lyric[i].posY<mouseY && mouseY<lyric[i].posY+lyric[0].box_height) {
      if ( 0<=select[0] ) {
        select[1] = i;
        snChange( select[0], i );
      } else {//何も選択されていない場合は「select[0] = -1」である
        select[0] = i;
      }
    }
  }
  //--------------------------
  //x座標300刻みにFX3つを割り当て
  if ( mouseX<=300 ) {
    traktorFX.sw[0] = 1-traktorFX.sw[0];
    sendMIDI(0);
  } else if ( 300<mouseX && mouseX<=600 ) {
    traktorFX.sw[1] = 1-traktorFX.sw[1];
    sendMIDI(1);
  } else if ( 600<mouseX ) {
    traktorFX.sw[2] = 1-traktorFX.sw[2];
    sendMIDI(2);
  }
}

//-------------------------------------------------------------------シャッフルナンバーチェンジ
void snChange( int s0, int s1  ) {
  int a = lyric[s0].shuffledNumber;
  lyric[s0].shuffledNumber = lyric[s1].shuffledNumber;
  lyric[s1].shuffledNumber = a;
  select[0] = -1;
  select[1] = -1;
}
//-------------------------------------------------------------------levelCheck()
//int pos = orche[0].sound.position();
int oldPos = 0;
int nowPos = 0;
//完成度をチェックする関数
void levelCheck() {
  int Lv = 0;//Lvは計算用の一時的な変数
  for (int i=0; i<20; i++) {
    if (lyric[i].shuffledNumber==i) {
      Lv++;
    }
  }
  level = Lv;
  //----------------------------------------
  oldPos = nowPos;
  nowPos = orche[0].sound.position();//前フレームと今フレームでのsound.position()を比較
  boolean GO = false;
  if (nowPos-oldPos<0) GO=true;//差がマイナスならGO!!!(旧：29070<pos)
  if (2<level && orche[1].playing==false && GO ) {//レベルが到達し、オケがまだ鳴ってなかったら
    trackStart(1);
  } else if (4<level && orche[2].playing==false && GO ) {
    trackStart(2);
  } else if (7<level && orche[3].playing==false && GO ) {
    trackStart(3);
  } else if (10<level && orche[4].playing==false && GO ) {
    trackStart(4);
  } else if (13<level && orche[5].playing==false && GO ) {
    trackStart(5);
  } else if (16<level && orche[6].playing==false && GO ) {
    trackStart(6);
  } else if (level==20 && finishAudio.playing==false ) {
    if (27570<nowPos && spaanAudio.playing==false) {
      spaanStart();//スパーン再生
    }
    if (GO && spaanAudio.playing) {
      finishStart();//フィニッシュ
    }
  }
  GO = false;
}//position()の最後 → 29090,29071

//-------------------------------------------------------------------------

void finish() {
  //ループする必要ないんだけど一回の指示でちゃんとポーズしてくれるか不安だから常にポーズしろって命令しとく
  for (int i=0; i<orcheNum; i++) {
    orche[i].sound.pause();  //オケをポーズ
  }

  //traktorも全部切る FX
  for (int i=1; i<=traktorFX.sw.length; i++) {
    promidi.Controller c = new promidi.Controller(i, 0);//000~, 0(スイッチOFF)
    midiOut.sendController(c);
  }
  //Voもオフにする
  promidi.Controller c = new promidi.Controller(0, 0);//000~, 0(スイッチOFF)
  midiOut.sendController(c);

  //finish rect---------------
  fill(0, 150);
  rect(50, 150, 800, 480);
}

//エンドロール
int endCount = 0;
void fin() {
  endCount++;
  noStroke();
  fill(255);
  rectMode(CENTER);
  rect( width/2, height/2, 900, 30+(endCount)*40 );
  rectMode(CORNER);
  image(endImage, 140, 300);
}

//音声波形描画------------------------------------------------------------
void waveDraw() {
  // ステレオ入力の内容を描画
  if (traktorFX.sw[0]==0) {  //GATER
    stroke(53, 119, 93);
    for (int i = 0; i < orche[1].sound.mix.size ()-1; i++) {
      line( 150 + orche[1].sound.mix.get(i)*100, i, 150 + orche[1].sound.mix.get(i+1)*100, i + 1 );
    }
  }
  if (traktorFX.sw[1]==0) {    //Bass-o-Matic
    stroke(131, 72, 133);
    for (int i = 0; i < orche[1].sound.mix.size ()-1; i++) {
      line( 450 + orche[1].sound.mix.get(i)*100, i, 450 + orche[1].sound.mix.get(i+1)*100, i + 1 );
    }
  }
  if (traktorFX.sw[2]==0) {    //Filter LFO
    stroke(53, 119, 93);
    for (int i = 0; i < orche[1].sound.mix.size ()-1; i++) {
      line( 750 + orche[1].sound.mix.get(i)*100, i, 750 + orche[1].sound.mix.get(i+1)*100, i + 1 );
    }
  }
}

//デバック用
void printMemo() {
  if (scene==0) {
    int now = 0;
    if (orche[1].playing) {
      now = 1;
    }
    if (orche[2].playing) {
      now = 2;
    }
    if (orche[3].playing) {
      now = 3;
    }
    if (orche[4].playing) {
      now = 4;
    }
    if (orche[5].playing) {
      now = 5;
    }
    if (orche[6].playing) {
      now = 6;
    }
    int pos = orche[0].sound.position();
    println("pos="+pos+", level="+level+", nowPlaying=orche[" + now +"]");
  } else if (scene==FINISH) {
    int pos = finishAudio.sound.position();
    println("finishPos="+pos+"");
  }
}

