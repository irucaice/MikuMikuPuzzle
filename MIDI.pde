class MIDI {
  int [] sw = new int [3];

  MIDI() {
    sw[0] = 0;
    sw[1] = 0;
    sw[2] = 0;
  }
}

//ここでMIDIを送信！！！！！(FXとか用)
void sendMIDI(int num) {
  int CCnum = num+1;
  promidi.Controller c = new promidi.Controller(CCnum, 0<traktorFX.sw[num] ? 0 : 127);//000~, 127(スイッチON)
  //↑トラクタ側でも001とかにマッピングしておくこと！！！
  midiOut.sendController(c);
}

void noteOn(Note note, int device, int channel) {
  int vel = note.getVelocity();
  int pit = note.getPitch();
  int len = note.getLength();
  //println("pit = "+pit+", vel = "+vel+", len = "+len);

  //hotcue押したらInteraction
  if (pit==0) {
    if (vel==15) {//HotCue 1---------------
      for (int i=0; i<figure.length; i++) {
        if (figure[i].sw==OFF) {
          figure[i].interactStart( 200, 200 );
          break;
        }
      }
    } else if (vel==31) {//HotCue 2--------
      for (int i=0; i<figure.length; i++) {
        if (figure[i].sw==OFF) {
          figure[i].interactStart( 400, 400 );
          break;
        }
      }
    } else if (vel==47) {//HotCue 3--------
      for (int i=0; i<figure.length; i++) {
        if (figure[i].sw==OFF) {
          figure[i].interactStart( 600, 200 );
          break;
        }
      }
    } else if (vel==63) {//HotCue 4--------
      for (int i=0; i<figure.length; i++) {
        if (figure[i].sw==OFF) {
          figure[i].interactStart( 300, 150 );
          break;
        }
      }
    } else if (vel==79) {//HotCue 5--------
      for (int i=0; i<figure.length; i++) {
        if (figure[i].sw==OFF) {
          figure[i].interactStart( 650, 300 );
          break;
        }
      }
    } else if (vel==95) {//HotCue 6--------
      for (int i=0; i<figure.length; i++) {
        if (figure[i].sw==OFF) {
          figure[i].interactStart( 200, 400 );
          break;
        }
      }
    } else if (vel==111) {//HotCue 7--------
      for (int i=0; i<figure.length; i++) {
        if (figure[i].sw==OFF) {
          figure[i].interactStart( 500, 400 );
          break;
        }
      }
    } else if (vel==127) {//HotCue 8--------
      for (int i=0; i<figure.length; i++) {
        if (figure[i].sw==OFF) {
          figure[i].interactStart( 250, 300 );
          break;
        }
      }
    }
  }
}


//HotCue操作MIDI送る
void hotCue() {
  if ((keyPressed == true) && (key == '1')) {
    promidi.Controller c = new promidi.Controller(10, 127);//000~, 127(スイッチON)
    midiOut.sendController(c);
  } else {
    promidi.Controller c = new promidi.Controller(10, 0);//000~, 127(スイッチON)
    midiOut.sendController(c);
  }
}

