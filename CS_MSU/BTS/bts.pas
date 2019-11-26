program bts;
uses crt;
Type 
    NodePtr = ^Node;
    Node = record
        value : Integer;
        left, right : NodePtr;
    end;

Var 
    tree : NodePtr;

procedure addNode(value : Integer; var tree: NodePtr);
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

function search(value : Integer; tree : NodePtr): NodePtr;
begin
    if tree = nil then
    begin
        search := nil;
        exit;
    end;
    
    if tree^.value = value then
    begin 
        search := tree;
        exit; 
    end
    else
    begin
        if tree^.value > value then search(value, tree^.left)
        else search(value, tree^.right);
    end;
end;

function has(value : Integer; tree: NodePtr): Boolean;
begin
    has := False;
    if search(value,tree) <> nil then has:= True;
end;

begin
    addNode(3,tree);
    if has(3,tree) then WriteLn('true')
end.