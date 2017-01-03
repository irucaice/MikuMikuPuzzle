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

//音楽スタートボタンとメーター
Panel startButton, meter;

//歌詞パネル
Panel [] lyric = new Panel [20];
//シャッフル用20個のxy格納
ShuffledNumber [] SN = new ShuffledNumber [20];
//選択しているパネル２つ
int []select = new int [2];

//traktorとのやりとり
MIDI traktor;

PImage mikuImage;

final int ON = 1;
final int OFF = 0;

//ドラムスタートのための変数
int musicSw = OFF;

//完成度
int level = 0;

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
//  midiOut = midiIO.getMidiOut(0, "Traktor Virtual Input"); //ch1

  //------------------------------------------------------

  minim = new Minim(this);  //初期化(setupの中じゃないといけないらしい)
  //バラオケの初期化
  for (int i=0; i<orcheNum; i++) {
    orche[i] = new Track(i);
  }
  finishAudio = new Track(100);//最後のオーディオ
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
  traktor = new MIDI(); //MIDIを扱う
  mikuImage = loadImage("data/miku2.png");//miku
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
  background(0);
  //miku----------------------
  tint(170);
  scale(0.5);
  image(mikuImage, 600, 100);
  tint(255);
  scale(2);//miku------------
  if (finishAudio.playing==false) {//フィニッシュするまでオケ鳴らす
    for (int i=0; i<orcheNum; i++) {
      orchePlay(i);  //オケを鳴らす(ドラム含む全８種類)
    }
  } else {
    finishAudio.sound.play();//finish鳴らす
    for (int i=0; i<orcheNum; i++) {
      orche[i].sound.pause();  //オケをポーズ
    }
  }//--------------------------------
  startButton.startDraw(); //スタートボタン描画
  meter.meterDraw(); //メーター描画
  for (int i=0; i<20; i++) {//歌詞パネルを描画
    lyric[i].lyricDraw();
  }
  levelCheck();//レベル(完成度)管理
}
//-------------------------------------------------------------------------

//スケッチのプロセスが終わったら実行されるらしい。
void stop() {
  for (int i=0; i<orcheNum; i++) {
    orche[i].sound.close();  //サウンドデータを終了
    minim.stop();
  }
  finishAudio.sound.close();
  super.stop();
}

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
  //sendMIDI(1,127);
}

//シャッフルナンバーチェンジ
void snChange( int s0, int s1  ) {
  int a = lyric[s0].shuffledNumber;
  lyric[s0].shuffledNumber = lyric[s1].shuffledNumber;
  lyric[s1].shuffledNumber = a;
  select[0] = -1;
  select[1] = -1;
}

//完成度をチェックする関数
void levelCheck() {
  int Lv = 0;//Lvは計算用の一時的な変数
  for (int i=0; i<20; i++) {
    if (lyric[i].shuffledNumber==i) {
      Lv++;
    }
  }
  level = Lv;
  int pos = orche[0].sound.position();
  println("pos="+pos+", level="+level+", ");
  if (2<level && orche[1].playing==false && 29070<pos ) {//レベルが到達し、オケがまだ鳴ってなかったら
    trackStart(1);
  } else if (4<level && orche[2].playing==false && 29070<pos ) {
    trackStart(2);
  } else if (7<level && orche[3].playing==false && 29070<pos ) {
    trackStart(3);
  } else if (10<level && orche[4].playing==false && 29070<pos ) {
    trackStart(4);
  } else if (13<level && orche[5].playing==false && 29070<pos ) {
    trackStart(5);
  } else if (16<level && orche[6].playing==false && 29070<pos ) {
    trackStart(6);
  } else if (level==20 && finishAudio.playing==false && 29000<pos ) {
    finishStart();
  }
}//position()の最後 → 29090,29071

//-------------------------------------------------------------------------

