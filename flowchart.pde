class Node {
  
 Node right = null;
 Node left = null;
 String command = null;
 boolean isCondition = false;
 
  Node(){
    
  }
  
  Node(String tmpCommand){  /// create the normal command
    this.command = tmpCommand; 
  }
  
  Node(String tmpCondition, String falseConditionCommand, String trueConditionCommand){ /// create the condition command Node which has parent nodes left and right
    this.command = tmpCondition + "condition";
    this.left = new Node(trueConditionCommand);  /// left node contains command that execute when condition command is true
    this.right = new Node(falseConditionCommand);  /// right node contains command that execute when condition command is false
  }
  
  void addLeft(Node recentNode, String tmpCommand){  ///add new node to the left most node
    if(recentNode.left == null){      /// if left node of recentNode is empty then 
       recentNode.left = new Node(tmpCommand); /// create new Node of tmpCommand
    }else{
       recentNode.addLeft(recentNode, tmpCommand); /// do recurion until found the left most node
    }
  }
  
  void addLeft(Node recentNode, Node tmpNode){  ///add new node to the left most node
    if(recentNode.left == null){      /// if left node of recentNode is empty then 
       recentNode.left = tmpNode; /// create new Node of tmpNode
    }else{
       recentNode.addLeft(recentNode, tmpNode); /// do recurion until found the left most node
    }
  }
  
  void addRight(Node recentNode, String tmpCommand){  ///add new node to the left most node
    if(recentNode.right == null){      /// if right node of recentNode is empty then 
       recentNode.right = new Node(tmpCommand); /// create new Node of tmpCommand
    }else{
       recentNode.addRight(recentNode, tmpCommand); /// do recurion until found the right most node
    }
  }
  
  void addRight(Node recentNode, Node tmpNode){  ///add new node to the left most node
    if(recentNode.right == null){      /// if left node of recentNode is empty then 
       recentNode.right = tmpNode; /// create new Node of tmpCommand
    }else{
       recentNode.addRight(recentNode, tmpNode); /// do recurion until found the left most node
    }
  }
}
