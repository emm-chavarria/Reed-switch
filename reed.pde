import processing.serial.*; // Imports serial library
Serial myPort; // Name of the serial port object
PrintWriter output; // Object used for creating the log file
boolean contact = false;

void setup(){
  size(100,100);
  println(Serial.list()); // Shows a list of ports in this computer
  myPort = new Serial (this, Serial.list()[3],9600); // Check which port to use. Not the same one in all computers.
  output = createWriter("biogas_"+day()+"."+month()+"."+year()+"."+hour()+"."+minute()+".txt"); // Name of the file
  output.println("Date (dd/mm/yyyy)" + "\t" + "Time (h:m:s)" + "\t" + "Counter1" + "\t" + "Counter2" + "\t" + "Counter3"); // Prints a header in the log file
  myPort.bufferUntil(10);
}

void draw(){
}

void serialEvent(Serial myPort){
  if(contact == false){
    int incomingData = myPort.read();
    println("Establishing contact...");
    if(incomingData == 'A'){
      myPort.clear();
      contact = true;
      println("Contact");
      myPort.write('A');
    }
  }
  else{
    myPort.write('A');
   // if(second() == 0){
      myPort.write('A');
      String inByte = myPort.readStringUntil(10);
      if(inByte != null){
        inByte = trim(inByte);
        println("Date" + "\t" + "Time" + "\t" + "Counter1" + "\t" + "Counter2" + "\t" + "Counter3"); // Prints a header in the log file
        println(day()+ "/"+ month()+ "/"+ year()+ "\t" + hour()+ ":"+ minute()+ ":"+ second()+ "   "+ inByte);
        output.println(day()+ "/"+ month()+ "/"+ year()+ "\t" + hour()+ ":"+ minute()+ ":"+ second() + "\t" + inByte); // Prints a header in the log file
        output.flush();
        output.close();
        delay(1000);
        }
   //   }
   }
}
