World world = new World();      
Flowchart myFlowchart = new Flowchart();
Flowchart myFlowchartTwo = new Flowchart(); 

void setup()
{
  size(500, 500);
  strokeWeight(2);
  world.load();
  world.loadControl(); 
  //world.test();
  
  myFlowchart.insertCondition("isBlocked()", "move()", "turnLeft()"); // (condition, false, true)
  myFlowchart.insertTrue("move()");
  myFlowchart.insertTrue("move()");
  myFlowchartTwo.insertCondition("isBlocked()", "move()", "turnRight()");
  myFlowchart.insertTrue(myFlowchartTwo);
  myFlowchart.insertTrue("move()"); 
}
void draw()
{ 
  world.doFlowchartCommand(myFlowchart);
  
  
  
  
  
  background(255);
  world.draw_map();
  if(keyPressed){
      if(mouseX > width/2-20 && mouseX < width/2 + 20){
          if(mouseY > height/2 - 20 && mouseY < height/2 + 20){
            mouseClicked();
          }// y-axis condition
       }// x-axis condition
    if(key == 't'){
      rectMode(CENTER);
       rect(width/2 - 20,height/2 - 20, width/2 + 20, height/2 + 20); 
       fill(255,0,0);
       text("SAVE",width/2 - 100,height/2 - 100);
       noLoop();
    }// button t condition
  }//keyPressed
}//draw function
void mouseClicked(){
  world.save(); 
  exit();  
}
class World
{
  int blockSize =50 ;
  int state = 1;
  String[][] barrierPosition;
  String[][] targetPosition;
  String[][] robotPosition;
  int[][] position = new int[500/blockSize][500/blockSize];
  Robot robot = new Robot(blockSize);
  InputProcessor ip = new InputProcessor(robot);   
  char up ;
  char down ;
  char left ;
  char right ;
  boolean makeTurn = false;   ///check isBlocked
  Node recentNode;       
  
  //Flowchart myFlowchart = new Flowchart();
  //Flowchart mySub = new Flowchart(); 
  World()
  {
    
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Programmer: korrawee
//
// Description: Save an object positions as a textfile(.txt) where saperated by ',' and '0' is represent to the path, 
//                                                                  '1' is represent the wall, 
//                                                                  '2' is represent to the objective, 
//                                                                  '3' is represent to the robot   
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
void save(){
    String[] tmpLines = new String[height/blockSize]; 
    for(int i = 0; i < height/blockSize; i++)
    {
     for(int j = 0; j < width/blockSize; j++)
     {
      if(position[i][j] == 3)
      {
        position[i][j] = 0;
      }
     }
    }
    position[robot.get_Row()][robot.get_Column()] = 3;
    for(int i=0; i < height/blockSize; i++){
      tmpLines[i] = "";
      for(int j=0; j < width/blockSize; j++){
        if(j != 0){
          tmpLines[i] += ",";  
        }//condition
        tmpLines[i] += position[i][j];
      }// j loop
    }// i loop
    saveStrings("saved.txt", tmpLines);
  }// save method

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Programmer: korrawee
//
// Description:  Load the saved data from the text file 
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void load(){
    File z = new File(sketchPath("saved.txt"));
    if(z.exists()){
      String[] info = loadStrings("saved.txt");
      String[] tmpLine = {};
      for(int i=0; i < info.length; i++)
      {
        tmpLine = split(info[i], ",");
        for(int j=0; j < info.length; j++)
        {
          position[i][j] = int(tmpLine[j]);  
        }// j loop
      }// i loop
    }else{
       this.generate();
    }// check file exixts condition
  }// load method

  
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Programmer: korrawee
//
// Description:  random all the object positions but fix robot at the top-left position  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void generate(){
    int tmpIndex = int(random(1,position.length));
    int tmpIndex2 = int(random(1,position.length));
    int tmp;
    position[0][0] = 3; //gen. robot
    position[tmpIndex][tmpIndex2] = 2; // gen. target
    for(int i=0; i < position.length; i+=1){
      for(int j=0; j < position.length; j+=2)
      {
        if(position[i][j] != 2 && position[i][j] != 3)
        {
          tmp = int(random(2));
          if(tmp == 1)
          {
            position[i][j] = 1  ;
          }
        }
      }// j loop
    }// i loop
  }// generate method
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Programmer: Pannawat Kingkaew collab by korrawee
//
// Description: draw map follow object position
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void draw_map()
  {
    for(int i = 0; i < position.length; i++){
      line(i* 50, 0, i*50, height);
      for(int j = 0; j < position.length; j++){  
        line(0, j*50,width, j*50);
        if(position[i][j] == 1 ){ // if barrier's position draw target
          this.draw_barrier(i, j); // draw_barrier(row, column)
        }if(position[i][j] == 2 ){ // if target's position draw barrier
          this.draw_target(i, j); // convert index into row, column
        }if(position[i][j] == 3){//  if robot's position draw robot
          robot.display(i,j);
        }
      }// j loop
    }// i loop
    ip.moveControl();
    robot.isOnTarget();
  }//draw_map method
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Programmer: Pannawat Kingkaew collab by korrawee
//
// Description: draw octagon target and make it flashing
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////  
  void draw_target(int tmpRow, int tmpCol)
  {
    if(state == 1 )
    {
      int x = (tmpCol * blockSize); // find axis values from Row and column
      int y = (tmpRow * blockSize) ;
      int dLeftX, dLeftY;
      int dRightX, dRightY;
      int uLeftX, uLeftY;
      int uRightX, uRightY;
      stroke(100, 250, 100);
      strokeWeight(random(0,1) * 5); // change block outline's color
      line(x, y , x + blockSize, y ); // up
      line(x, y + blockSize, x + blockSize, y + blockSize); //down
      line(x, y , x, y + blockSize); //left
      line(x + blockSize , y , x + blockSize, y + blockSize); // right
      for(int i = 0; i < blockSize/4; i+= 2){ // draw each three corner
        dLeftX = x;
        dLeftY = y + blockSize;
        dRightX =dLeftX + blockSize;
        dRightY = y + blockSize;
        uLeftX = x;
        uLeftY = y ;
        uRightX = dLeftX + blockSize;
        uRightY = uLeftY;
        line(dLeftX + i, dLeftY, dLeftX, dLeftY - i);
        line( dRightX - i, dRightY, dRightX, dRightY - i);
        line(uLeftX + i, uLeftY, uLeftX, uLeftY + i);
        line(uRightX - i, uRightY, uRightX, uRightY + i);
      }
      stroke(0);
      strokeWeight(2);
    }// state condition
  }//draw_target method
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Programmer: Pannawat Kingkaew collab by korrawee
//
// Description: draw barrier
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void draw_barrier(int tmpRow, int tmpCol)
  {
    int x = (tmpCol ) * blockSize;
    int y = (tmpRow ) * blockSize;
    fill(#F4A460);
    rect( x, y, blockSize, blockSize);
    stroke(0);
  }//draw_barrier method

  
  void loadControl(){
    File f = new File(sketchPath("control.txt"));
    String[] btn;
    if(f.exists()){
      String[] lines = loadStrings("control.txt");
      btn = lines[0].split(",");
      up = btn[0].charAt(0);
      down = btn[1].charAt(0);
      left = btn[2].charAt(0);
      right = btn[3].charAt(0);
    }else{
      this.createFile();
      this.load();
    }// file exist condition
  }// load method
  void createFile(){
    String[] defaultBtn = {"forward,s,left,Right"};
    saveStrings("control.txt", defaultBtn);  
  }
  Robot getRobot(){           /// getRobot is aritribute of class world
    return this.robot;
  }
  
  void updateNode(Node node) {
    println("in update");
    if (node != null ) {   /// if node isn't empty 
      println("node == null");
      if (node.isCondition == false && makeTurn == true ) {  /// if makeTurn is true then 
        recentNode = recentNode.left;  /// go to left node 
        println("isCondition == false && makeTurn == true ");
      } 
      
      else if (node.isCondition == false && !makeTurn  ) {  /// if makeTurn is false then 
        println("(node.isCondition == false && !makeTurn");
        recentNode = recentNode.right;  /// go to right node
      } 
      
      else if (recentNode.isCondition == true && recentNode.command.equals("isBlocked() condition" )   ) {
        println("in isCondition == true && recentNode.command.equals(");
        makeTurn = robot.isBlocked();  /// maketurn assinged by true if there is a wall in front of robot
        if (makeTurn == false) {    /// if makeTurn is false then
          println("in mketurn false");
          recentNode = recentNode.right;  /// go to right node 
        } 
        
        else if (makeTurn) {      /// if makeTurn is true then 
          println("in maketurn");
          recentNode = recentNode.left;  /// go to left node
        }
      }
    }
  } ///updateNode method
  
  void doFlowchartCommand(Flowchart myFlowchart) {
   if (frameCount >50) { //delay time before start 
     println(recentNode != null);
      updateNode(recentNode);  //find next node to do 
      if (recentNode != null) {  //if have command to do 
        println("in recenNode != null " +recentNode.command);
        doCommand(recentNode.command); //then do that belong to command 
      }
      else 
      {
        if(myFlowchart.recentCondition.recentTrue.left == null){   //is node is empty  myFlowchart.recentCondition.recentTrue.left == null
        println("IN condition");
        recentNode = myFlowchart.node;    //restart node to do again 
        makeTurn = true;          //reset turn of flowchart
        }
        else
        {
          recentNode = myFlowchart.recentCondition.recentTrue;  //if have something to do affter then then do next is endTrueNode
        }
      }
    }
  } ///doFlowchartCommand
  
  void doCommand(String command) {
    println("In docommand method");
    if (command.equals("turnLeft()") || command.equals("turnLeft")) {   //if it's  turnLeft then do it  and redraw
      robot.turnLeft();
      this.draw_map();
      println("DOing turnLeft()");
    } 
    else if (command.equals("turnRight()") || command.equals("turnRight")) { //if it is turnRight() then do it  and redraw
      robot.turnRight();
      this.draw_map();
      println("DOing turnRight()");

    } 
    else if (command.equals("move()") || command.equals("move"))  //if it is turnLeft() then do it and re draw
    {
      if (robot.isBlocked()==false) {   
        robot.move();
        this.draw_map();
        println("DOing move()");
      }
    }
    delay(800);  //delay to do next
  }
  
}
class Robot
{
  int blockSize;
  int row = 0 ;
  int column = 0 ;
  int i ;
  int j ;
  String side = "DOWN" ;

  
  Robot(int tmpBlockSize){
    blockSize = tmpBlockSize; 
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Programmer: Pannawat Kingkaew 
//
// Description: make the robot move along the robot side shown on the map.
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////
//
// Programmer: (Tunlaya)
//
// Description: (void move)
// Method tells the property that the Robot can walk.
/////////////////////////////////////////////////////  
  void move()
  {
       if(side == "UP")
       {
        row -= blockSize; 
       }
       if(side == "DOWN")
       {
        row +=  blockSize; 
       }
       if(side == "LEFT")
       {
        column -= blockSize; 
       }
       if(side == "RIGHT")
       {
        column +=  blockSize; 
       }
  }// move method

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Programmer: Pannawat Kingkaew 
//
// Description: draw each side of robot (up,right,left,down)
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////


   
  void display(int tmpx , int tmpy)
  {
   if(side == "UP")
   {
     line(tmpy*50 + column ,(tmpx*50)+50 + row ,(tmpy*50)+25 + column ,tmpx*50 + row);
     line((tmpy*50)+50 + column ,(tmpx*50)+50 + row ,(tmpy*50)+25 + column ,tmpx*50 + row);
   }
   if(side == "DOWN")
   {
    line(tmpy*50 + column ,tmpx*50 + row ,(tmpy*50)+25 + column ,(tmpx*50)+50 + row);
    line((tmpy*50)+50 + column ,tmpx*50 + row ,(tmpy*50)+25 + column ,(tmpx*50)+50 + row);
   }
   if(side == "LEFT")
   {
    line((tmpy*50)+50 + column ,tmpx*50 + row ,tmpy*50 + column ,(tmpx*50)+25 + row);
    line((tmpy*50)+50 + column ,(tmpx*50)+50 + row ,tmpy*50 + column ,(tmpx*50)+25 + row);
   }
   if(side == "RIGHT")
   {
    line(tmpy*50 + column ,tmpx*50 + row ,(tmpy*50)+50 + column ,(tmpx*50)+25 + row);
    line(tmpy*50 + column ,(tmpx*50)+50 + row ,(tmpy*50)+50 + column ,(tmpx*50)+25 + row);
   }
    i = (tmpx*50 + row) ;
    j = (tmpy*50 + column) ;
  }// display method

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Programmer: Pannawat Kingkaew 
//
// Description: change the side of the robot to the left.
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////
//
// Programmer: (Tunlaya)
//
// Description: (void turnLeft)
// change method tells the properties of the robot. Can turn left
/////////////////////////////////////////////////////    
  void turnLeft()
  {
     if(side == "UP")
     {
      side = "LEFT"  ;
     }
     else if(side == "LEFT")
     {
      side = "DOWN"  ;
     }
     else if(side == "DOWN")
     {
      side = "RIGHT"  ;
     }
     else if(side == "RIGHT")
     {
      side = "UP"  ;
     }
  }// turnLeft method
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Programmer: Pannawat Kingkaew 
//
// Description: change the side of the robot to the right.
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////  
/////////////////////////////////////////////////////
//
// Programmer: (Tunlaya)
//
// Description: (void turnRight)
// change method tells the properties of the robot. Can turn right
/////////////////////////////////////////////////////  

  
  void turnRight()
  {
     if(side == "UP")
     {
      side = "RIGHT"  ;
     }
     else if(side == "RIGHT")
     {
      side = "DOWN"  ;
     }
     else if(side == "DOWN")
     {
      side = "LEFT"  ;
     }
     else if(side == "LEFT")
     {
      side = "UP" ;
     }
  }// turnRight method
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Programmer: Pannawat Kingkaew 
//
// Description: check forward the robot is block
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////  
  boolean isBlocked()
  {
   //if (keyPressed == true )
   //{
       if(side == "UP")
       {
         if(this.i <= 0)
         {
           keyPressed = false ;
           return true;
         }
         else if(world.position[ ((this.i - world.blockSize)/world.blockSize)  ][this.j/world.blockSize] == 1)
         {
           keyPressed = false ;
           return true;
         }
       }
       if(side == "DOWN")
       {
         if(this.i + world.blockSize >= height)
         {
           keyPressed = false ;
           return true;
         }
         else if(world.position[ ((this.i + world.blockSize)/world.blockSize)  ][this.j/world.blockSize] == 1)
         {
           keyPressed = false ;
           return true;
         }
       }
       if(side == "LEFT")
       {
         if(this.j <= 0)
         {
           keyPressed = false ;
           return true;
         }
         else if(world.position[  (this.i/world.blockSize)   ][( this.j - world.blockSize)/world.blockSize] == 1)
         {
           keyPressed = false ;
           return true;
         }
       }
       if(side == "RIGHT")
       {
         if(this.j + world.blockSize >= width)
         {
           keyPressed = false ;
           return true;
         }
         else if(world.position[ (this.i/world.blockSize)  ][( this.j + world.blockSize)/world.blockSize] == 1)
         {
           keyPressed = false ;
           return true;
         }
       }
     //}// button condition
  // }// keyPressed condition
    return false;
  }// isBlocked method
  
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Programmer: Pannawat Kingkaew 
//
// Description: check robot is on target
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////    
  void isOnTarget()   
  {
   if(world.position[this.i/world.blockSize][this.j/world.blockSize] == 2)
   {
    world.state = 0 ;
    background(#FFFFFF);  
    textSize(40);
    text("You Win", 160, 250);
   }
  }
     // button condition
   // keyPressed condition
  // isOnTarget method  
  int get_Row(){
    return i/blockSize;  
  }
  int get_Column(){
    return j/blockSize;  
  }
}
class InputProcessor{ 
  char up ;
  char down ;
  char left ;
  char right ;
  Robot robot;

  
  InputProcessor(Robot tmpRobot){ 
    robot = tmpRobot;
    up = 'w';              
    left = 'a';
    right = 'd';
    }
/////////////////////////////////////////////////////
//
// Programmer: (Tunlaya)
//
// Description: (void moveControl)
// method to use the motion properties of the Class Robot.
/////////////////////////////////////////////////////
  void moveControl(){        ///////condition  when KeyPressed = true
    if (keyPressed == true )
   {
     if(key == up )
      {
        robot.isBlocked();        /////call method name isBlocked of class name Robot 
        if(keyPressed == true){
          robot.move();
          keyPressed = false;
        }
      }
       if(key == left ) //turn left 
      {
        robot.turnLeft();
        keyPressed = false;
      }
      if(key == right){  ///turnRigh
        robot.turnRight();
        keyPressed = false;
      }
    }
  }// button condition
    ///turnRight method
   void forword(char w){
     up = w ;
     }
   void moveleft(char a){
     left = a ;
   }
   void moveright(char d){
     right = d;
   }
}   //// class InputProcessor

class Flowchart{ /// implemented by binary tree
  
  Node node = null;
  Node recentCondition = new Node();
  
  Flowchart(){
   node = new Node(); 
  }
  
  void insert(String tmpCommand){  ///insert the command to binary tree
     if(node.command == null){  ///if the first node does not contain any command then
        node.command = tmpCommand;  /// add tmpCommand to first node's command
     }else{
        node.addLeft(node, tmpCommand); ///add tmpCommand to the most [ left node's command ]
     } 
  }
  
  void insert(Flowchart tmpFlowchart){  ///insert the condition command to last binary tree
     if(node.command == null){  ///if the first node does not contain any command then
        node = tmpFlowchart.node;  /// assign tmpFlowchart's node to first node
     }else{
        node.addLeft(node, tmpFlowchart.node); ///add tmpFlowchart's node to the most [ left node ]
     } 
     recentCondition = tmpFlowchart.recentCondition;  /// Redirect last condition node to the tmpFlowchart's recentCondition
  }
   
   void insertFalse(String tmpCommand){  ///insert command that executes when the condition is false into the most recent condition
     recentCondition.addRight(recentCondition, tmpCommand); /// add command to the most [ right node ]
   }
   
   void insertFalse(Flowchart tmpFlowchart){  ///insert command that executes when the condition is false into the most recent condition
     recentCondition.addRight(recentCondition, tmpFlowchart.node); /// add tmpFlowchart's node to the most [ right node ]
   }
   
   void insertTrue(String tmpCommand){ ///insert command that executes when the condition is true into the most recent condition
     
     Node tmp = recentCondition.addLeft(recentCondition, tmpCommand);   
     recentCondition.recentTrue = tmp;  /// add command to the most [ left node ] 
   }
   
   void insertTrue(Flowchart tmpFlowchart){  ///insert command that executes when the condition is false into the most recent condition
     recentCondition.addLeft(recentCondition, tmpFlowchart.node); /// add tmpFlowchart's node to the most [ left node ] 
   }
   
   void insertCondition(String tmpCommand, String tmpFalseCommand, String tmpTrueCommand) {  /// insert condition command from purely command
    Node tmp = new Node(tmpCommand, tmpFalseCommand, tmpTrueCommand);  /// create temporary node tmp
    recentCondition = tmp;         /// assign tmp node into recentCondition
    if (node.command != null ) {  /// if there is a command then
      node.addLeft(node, tmp);    //add tmp node to most left node 
    } 
    else 
    {
      node = tmp;  /// assign tmp node into the empty node
    }
  }
  
   void insertCondition(String tmpCommand, Flowchart tmpFalseFlowchart, Flowchart tmpTrueFlowchart){  ///insert condition command from another flowchart
     Flowchart tmp = new Flowchart();  ///create temporary Flowchart
     
     tmp.insert(tmpCommand);  ///insert the command to tmp
     tmp.node.left = tmpTrueFlowchart.node;  ///assign tmpTrueFlowchart's node into left parent node of tmp's node
     tmp.node.right = tmpFalseFlowchart.node;  ///assign tmpTrueFlowchart's node into right parent node of tmp's node
     node.addLeft(node, tmp.node);  ///add tmp's node to the most left node
   }
}
