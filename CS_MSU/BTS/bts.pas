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
    i : Integer;

procedure Enqueue(tNode : TNodePtr; var queue : QNodePtr);
begin
    if queue = Nil then
    begin
        New(queue);
        queue^.node := tNode;
        queue^.next := Nil;
    end
    else
    begin
        if (queue^.next = Nil) then
        begin
            New(queue^.next);
            queue^.next^.node := tNode;
            queue^.next^.next := Nil;
        end
        else Enqueue(tNode, queue^.next);
    end;
end;

function Dequeue(var queue : QNodePtr) : TNodePtr;
var tmp : QNodePtr;
begin
    if (queue = Nil) then Dequeue := Nil
    else 
    begin
        Dequeue := queue^.node;
        tmp := queue;
        queue := queue^.next;
        Dispose(tmp);
    end;
end;

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

procedure TraverseWidthFirst(root : TNodePtr);
var queue : QNodePtr = Nil;
    obj : TNodePtr = Nil;
begin
    Enqueue(root,queue);
    while queue <> Nil do
    begin
        obj := Dequeue(queue);
        WriteLn(obj^.value);
        if (obj^.left <> Nil) then Enqueue(obj^.left, queue);
        if(obj^.right <> Nil) then Enqueue(obj^.right, queue);
    end;
end;

begin
    for i := 1 to 200 do
        addTNode(i * Random(Random(100)),root);
    TraverseDepthFirst(root);
end.