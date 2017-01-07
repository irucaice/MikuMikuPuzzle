class MIDI {
  int [] sw = new int [3];

  MIDI() {
    sw[0] = 0;
    sw[1] = 0;
    sw[2] = 0;
  }
}

//ここでMIDIを送信！！！！！
void sendMIDI(int num) {
  int CCnum = num+1;
  promidi.Controller c = new promidi.Controller(CCnum, 0<traktorFX.sw[num] ? 0 : 127);//000~, 127(スイッチON)
  //↑トラクタ側でも001とかにマッピングしておくこと！！！
  midiOut.sendController(c);
}

