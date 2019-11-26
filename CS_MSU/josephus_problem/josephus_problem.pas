program josephus_problem;
uses crt;
Type 
    TRef = ^Node;
    Node = record
        value : UInt32;
        next  : TRef;
    end;

    HeadObj = record
        header : TRef;
        tail : TRef;
        listLength : UInt32;
    end;

Var 
    list: HeadObj;

procedure InitializeCircularList(num_of_nodes : UInt32;var list : HeadObj);
var i : UInt32;
    current_node : TRef;
begin
    if num_of_nodes <= 0 then exit;
    New(list.header);
    list.listLength := num_of_nodes;
    list.header^.value := 1;
    list.header^.next := list.header;

    current_node := list.header;

    for i := 2 to num_of_nodes - 1 do
    begin
        New(current_node^.next);
        current_node := current_node^.next;
        current_node^.value := i;
    end; 
    new(current_node^.next);
    current_node := current_node^.next;
    list.tail := current_node;
    list.tail^.value := num_of_nodes;
    list.tail^.next := list.header;
end;

//  deletes every mth element
procedure DeleteElements(m : UInt32; var list: HeadObj);
var current_node, tmp : TRef;
    previous_node : TRef;
    i : UInt32 = 1;
begin
        if list.header = nil then exit;
        current_node := list.header;
        previous_node := list.tail;
        while (list.listLength > m - 1) do
        begin
            if (i = m) and (current_node = list.header) then 
            begin
                WriteLn(current_node^.value);
                tmp := list.header;
                list.header := list.header^.next;
                current_node := list.header;
                list.tail^.next := list.header;
                Dispose(tmp);

                i := 1;
                list.listLength := list.listLength - 1;
                Continue;
            end
            else if (i = m) and (current_node = list.tail) then
            begin
                WriteLn(current_node^.value);
                tmp := list.tail;
                list.tail := previous_node;
                list.tail^.next := list.header;
                Dispose(tmp);

                current_node := list.header;
                previous_node := list.tail;
                
                i := 1;
                list.listLength := list.listLength - 1;
                Continue;  
            end
            else if (i = m) then
            begin
                WriteLn(current_node^.value);
                tmp := current_node;
                previous_node^.next := current_node^.next;
                current_node := current_node^.next;
                Dispose(tmp);

                i := 1;
                list.listLength := list.listLength - 1;
                Continue;
            end;
            previous_node := current_node;
            current_node := current_node^.next;
            i := i + 1;
            //WriteLn(list.listLength);
        end;
end;




begin
    InitializeCircularList(10, list);
    DeleteElements(3,list);
    //WriteLn(list.header^.i, ' ', list.tail^.i);
end.