import processing.serial.*; // Imports serial library
Serial myPort; // Name of the serial port object
PrintWriter output; // Object used for creating the log file
boolean contact = false;
PImage biogascounter;
PFont font;
int dailyCounter1 = 0;
int dailyCounter2 = 0;
int dailyCounter3 = 0;
int dailyCounter4 = 0;
int dailyCounter5 = 0;
int dailyCounter6 = 0;
int yesterday = 0;

void setup(){
  size(570,400);
  font = createFont ("Calibri", 35, true); // Type and size of font
        textSize(20);
        text("Establishing contact...", 50, 50);

  
  println(Serial.list()); // Shows a list of ports in this computer
  myPort = new Serial (this, Serial.list()[5],9600); // Check which port to use. Not the same one in all computers.
  output = createWriter("biogas_"+day()+"."+month()+"."+year()+"."+hour()+"."+minute()+".txt"); // Name of the file
  output.println("Date (dd/mm/yyyy)" + "\t" + "Time (h:m:s)" + "\t" + "Counter1" + "\t" + "Counter2" + "\t" + "Counter3"+ "\t" + "Counter4" + "\t" + "Counter5" + "\t" + "Counter6"); // Prints a header in the log file
  output.flush();
  myPort.bufferUntil(10);
}

void draw(){
  textFont(font);
  fill(0,0,0);
  if(minute()%15 == 0 && second() == 0){ // Ask Arduino for data every 15min
    myPort.write('A');
    delay(1000);
  }
}

void serialEvent(Serial myPort){
  // For establishing the very first contact
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
    // After first contact is established
      String inByte = myPort.readStringUntil(10);
      if(inByte != null){
        inByte = trim(inByte);
        String[] values = split(inByte, '\t');
        int  counter1 = int(values[0]);
        int  counter2 = int(values[1]);
        int  counter3 = int(values[2]);
        int  counter4 = int(values[3]);
        int  counter5 = int(values[4]);
        int  counter6 = int(values[5]);
        
        int today = day(); // reset cummulative values every day
        dailyCounter1 = dailyCounter1 + counter1;
        dailyCounter2 = dailyCounter2 + counter2;
        dailyCounter3 = dailyCounter3 + counter3;
        dailyCounter4 = dailyCounter4 + counter4;
        dailyCounter5 = dailyCounter5 + counter5;
        dailyCounter6 = dailyCounter6 + counter6;
        if(today != yesterday){
          yesterday = today;
          dailyCounter1 = 0;
          dailyCounter2 = 0;
          dailyCounter3 = 0;
          dailyCounter4 = 0;
          dailyCounter5 = 0;
          dailyCounter6 = 0;
        }
        
        // Prints in console
        println("Date" + "\t" + "Time" + "\t" + "Counter1" + "\t" + "Counter2" + "\t" + "Counter3" + "\t" + "Counter4" + "\t" + "Counter5" + "\t" + "Counter6"); // Prints a header in the log file
        print(day()+ "/"+ month()+ "/"+ year()+ "\t" + hour()+ ":"+ minute()+ ":"+ second() + "\t"); // Prints a header in the log file
        println(counter1 + "\t" + counter2 + "\t" + counter3 + "\t" + counter4 + "\t" + counter5 + "\t" + counter6);
        
        // Prints counters data on display window
        background(255, 255, 255);
        textSize(45);
        text("Biogas counters", 50, 50);
        textSize(25);
        text("Today's cummulative biogas production.", 50, 80);
        textSize(25);
        text("Digester 1: " + dailyCounter1*50 + " ml", 80, 120);
        textSize(25);
        text("Digester 2: " + dailyCounter2*50 + " ml", 80, 150);
        textSize(25);
        text("Digester 3: " + dailyCounter3*50 + " ml", 80, 180);
        textSize(25);
        text("Digester 4: " + dailyCounter4*50 + " ml", 80, 210);
        textSize(25);
        text("Digester 5: " + dailyCounter5*50 + " ml", 80, 240);
        textSize(25);
        text("Digester 6: " + dailyCounter6*50 + " ml", 80, 270);
        textSize(25);
        text("Please find this log file in C > Processing > folder", 50, 320);
        
        // Appends counts to file
        output.print(day()+ "/"+ month()+ "/"+ year()+ "\t" + hour()+ ":"+ minute()+ ":"+ second() + "\t"); // Prints a header in the log file
        output.println(counter1 + "\t" + counter2 + "\t" + counter3 + "\t" + counter4 + "\t" + counter5 + "\t" + counter6);
        output.flush();
      }
    }
  }
