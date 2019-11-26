program bts;

Type 
    NodePtr = ^Node;
    Node = record
        value : Integer;
        next : NodePtr;
    end;

Var 
    tree : NodePtr;

function addNode(value : Integer; tree: NodePtr): NodePtr;
begin
    if tree = nil then
    begin
        new(tree);
        tree^.value := value;
        tree^.left := nil;
        tree^.right := nil;
    end
    else
    begin
        if (value > tree^.value) then addNode(value, tree^.right)
        else if (value < tree^.value) then addNode(value,tree^.left);
    end;
end;

begin
  
end.