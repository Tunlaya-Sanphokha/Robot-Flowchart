class Node {
  
 Node right = null;
 Node left = null;
 String command = null;
 boolean isCondition = false;
 
  Node(){
    
  }
  
  Node(String tmpCommand){  /// create the normal command
   
  }
  
  Node(String tmpCondition, String falseConditionCommand, String trueConditionCommand){ /// create the condition command Node which has parent nodes left and right
    
  }
  
  void addLeft(Node recentNode, String tmpCommand){  ///add new node to the left most node
    
  }
  
  void addLeft(Node recentNode, Node tmpNode){  ///add new node to the left most node
    
  }
  
  void addRight(Node recentNode, String tmpCommand){  ///add new node to the left most node
    
  }
  
  void addRight(Node recentNode, Node tmpNode){  ///add new node to the left most node
    
  }
}
