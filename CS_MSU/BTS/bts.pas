program bts;
//uses crt;
Type 
    TNodePtr = ^TNode;
    TNode = record
        value : Integer;
        left, right : TNodePtr;
    end;
    
    QNodePtr = ^QNode;
    QNode = record
        node : TNodePtr;
        next : QNodePtr;
    end;

Var 
    root : TNodePtr;
    queue : QNodePtr;
    i, a : Integer;
procedure addTNode(value : Integer; var root: TNodePtr);
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
        if (value > root^.value) then addTNode(value, root^.right)
        else if (value < root^.value) then addTNode(value,root^.left);
    end; 
end;

function search(value : Integer; root : TNodePtr): TNodePtr;
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

function has(value : Integer; root: TNodePtr): Boolean;
begin
    has := False;
    if search(value,root) <> nil then has:= True;
end;

procedure TraversePreorder(root : TNodePtr);
begin
    WriteLn(root^.value);
    if root^.left <> Nil then TraversePreorder(root^.left);
    if root^.right <> Nil then TraversePreorder(root^.right);
end;

procedure TraverseInorder(root : TNodePtr);
begin
    if root^.left <> Nil then TraversePreorder(root^.left);
    WriteLn(root^.value);
    if root^.right <> Nil then TraversePreorder(root^.right);
end;

procedure TraversePostorder(root : TNodePtr);
begin
    if root^.left <> Nil then TraversePreorder(root^.left);
    if root^.right <> Nil then TraversePreorder(root^.right);
    WriteLn(root^.value);
end;

procedure TraverseDepthFirst(root : TNodePtr);
begin

end;

procedure Enqueue(tNode : TNodePtr; var queue : QNodePtr);
begin
    if queue = Nil then
    begin
        New(queue);
        queue^.node := tNode;
        queue^.next := Nil;
    end;
end;

function Dequeue(var queue : DQueue) : TNodePtr;
begin

end;

begin
    for i := 1 to 10 do
    begin
        a := Random(9) - Random(6);
        WriteLn(a);
        addTNode(a, root);
        Enqueue(root,queue);
    end;
    WriteLn('-----------------------------------------------------');
    WriteLn(High(queue));
end.