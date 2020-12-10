class Node {
  
 Node right = null;
 Node left = null;
 Node recentTrue = null; 
 String command;
 boolean isCondition = false;
 
  Node(){
    
  }
  
  Node(String tmpCommand){  /// create the normal command
    this.command = tmpCommand; 
  }
  
  Node(String tmpCondition, String falseConditionCommand, String trueConditionCommand){ /// create the condition command Node which has parent nodes left and right
    this.command = tmpCondition + " condition";
    this.isCondition = true;
    this.left = new Node(trueConditionCommand);  ///[ left node ] contains command that execute when condition command is true
    this.right = new Node(falseConditionCommand);  /// right node contains command that execute when condition command is false
  }
  
  Node addLeft(Node recentNode, String tmpCommand){  ///add new node to the most [ left node ]
  Node tmp;
    if(recentNode.left == null){      /// if left node of recentNode is empty then 
       recentNode.left = new Node(tmpCommand); /// create new Node of tmpCommand
       return recentNode.left;
    }
    else
    {
       tmp = recentNode.addLeft(recentNode.left, tmpCommand); /// do recursion until found the most [ left node ]
    }
    return tmp;
  }
  
  Node addLeft(Node recentNode, Node tmpNode){  ///add new node to the most [ left node ]
    Node tmp;
    if(recentNode.left == null){      /// if left node of recentNode is empty then 
       recentNode.left = tmpNode; /// create new Node of tmpNode
       return recentNode.left;
    }
    else
    {
       tmp = recentNode.addLeft(recentNode.left, tmpNode); /// do recursion until found the most [ left node ]
    }
    return tmp;
  }
  
  Node addRight(Node recentNode, String tmpCommand){  ///add new node to the most [ right node ]
    Node tmp;
    if(recentNode.right == null){      /// if right node of recentNode is empty then 
       recentNode.right = new Node(tmpCommand); /// create new Node of tmpCommand
       return recentNode.right;
  }
  else
  {
       tmp = recentNode.addRight(recentNode.right, tmpCommand); /// do recursion until found the most [ right node ]
    }
    return tmp;
  }
  
  Node addRight(Node recentNode, Node tmpNode){  ///add new node to the most [ left node ]
    Node tmp;
    if(recentNode.right == null){      /// if left node of recentNode is empty then 
       recentNode.right = tmpNode; /// create new Node of tmpCommand
      return recentNode.right;
  }else{
       tmp = recentNode.addRight(recentNode.right, tmpNode); /// do recursion until found the most [ left node ]
    }
    return tmp;
  }  /// addRight
}  ///class Node
