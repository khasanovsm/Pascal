program bts;
//uses crt;
Type 
    NodePtr = ^Node;
    Node = record
        value : Integer;
        left, right : NodePtr;
    end;
    DQueue = array of NodePtr;
Var 
    root : NodePtr;
    queue : DQueue;
    i, a : Integer;
procedure addNode(value : Integer; var root: NodePtr);
begin
    if root = nil then
    begin
        new(root);
        root^.value := value;
        root^.left := nil;
        root^.right := nil;
    end
    else
    begin
        if (value > root^.value) then addNode(value, root^.right)
        else if (value < root^.value) then addNode(value,root^.left);
    end; 
end;

function search(value : Integer; root : NodePtr): NodePtr;
begin
    if root = nil then
    begin
        search := nil;
        exit;
    end;
    
    if root^.value = value then
    begin 
        search := root;
        exit; 
    end
    else
    begin
        if root^.value > value then search(value, root^.left)
        else search(value, root^.right);
    end;
end;

function has(value : Integer; root: NodePtr): Boolean;
begin
    has := False;
    if search(value,root) <> nil then has:= True;
end;

procedure TraversePreorder(root : NodePtr);
begin
    WriteLn(root^.value);
    if root^.left <> Nil then TraversePreorder(root^.left);
    if root^.right <> Nil then TraversePreorder(root^.right);
end;

procedure TraverseInorder(root : NodePtr);
begin
    if root^.left <> Nil then TraversePreorder(root^.left);
    WriteLn(root^.value);
    if root^.right <> Nil then TraversePreorder(root^.right);
end;

procedure TraversePostorder(root : NodePtr);
begin
    if root^.left <> Nil then TraversePreorder(root^.left);
    if root^.right <> Nil then TraversePreorder(root^.right);
    WriteLn(root^.value);
end;

procedure TraverseDepthFirst(root : NodePtr);
begin

end;

procedure Enqueue(node : NodePtr; var queue : DQueue);
begin
    SetLength(High(queue) + 1);
    queue[Low(queue)] := node;
end;

function Dequeue(var queue : DQueue) : NodePtr;
begin
    Dequeue := queue[High(queue)];
    SetLength(High(queue));
end;

begin
    for i := 1 to 10 do
    begin
        a := Random(9) - Random(6);
        WriteLn(a);
        addNode(a, root);
        Enqueue(root,queue);
    end;
    WriteLn('-----------------------------------------------------');
    WriteLn(High(queue));
end.