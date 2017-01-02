class MIDI{
  int playSw; //pit==12にマッピング
  int FX1; //pit==36にマッピング
  
  MIDI(){
    playSw = OFF;
  } 
}

void noteOn(Note note, int device, int channel) {
  int vel = note.getVelocity();
  int pit = note.getPitch();
  println("pit = "+pit+"vel = "+vel);
  if(pit==12){//A deck play
  traktor.playSw = ON;
  }
}
/*メモ
 traktorのノブにpit変化はない。つまみをいじるとvelが変化。
*/
