program semester_proj;
uses crt, dateutils, sysutils;
Type 
    Price = record
        int: UInt8;
        dec: UInt8;
    end;
    
    Chocolate = record
        kind: String;
        producer : String;
        cost : Price;
    end;

    RChocolate = ^Chocolate;

    //Chocolate element as a list object
    RProduct = ^Product; 
    Product = record
        item : RChocolate; 
        next, prev : RProduct;
    end;
    //double-linked array
    DLList = record
        header, tail : RProduct;
        length : UInt32;
    end;

Var
    list_of_products : DLList;
    elem : RProduct;

    comparisons, permutations : UInt64;

procedure initializeProducts(var products : DLList; file_path : String);
var 
    f : TextFile;
    price : Real;
    cur, prev : RProduct; // identical to products.header (./tail)
begin
    //file handling
    AssignFile(f, file_path);
    Reset(f);

    New(products.header); // создается новый объект типа Pruduct
    New(products.tail);  //создается новый объект типа Pruduct
    products.length := 0;

    cur := products.header;
    prev := nil;

    while not EOF(f) do
    begin
        products.length := products.length + 1;
        New(cur^.item);
        ReadLn(f,cur^.item^.kind);
        Readln(f,cur^.item^.producer);
        ReadLn(f, price);
        ReadLn(f);
        cur^.item^.cost.int := trunc(price);
        cur^.item^.cost.dec := trunc((price - trunc(price))*100);
        if prev <> Nil then cur^.prev := prev;
        prev := cur;
        New(cur^.next);
        cur := cur^.next;
    end;
    products.tail := prev;
    Dispose(products.tail^.next);
    products.tail^.next := Nil;
    CloseFile(f);
end;

procedure CoctailSort(var products: DLList);
var 
    left, right, i: RProduct;
    tmpElement : RChocolate;
    swapped : Boolean = True;
begin
    //side effects 
    comparisons := 0;
    permutations := 0;

    left := products.header;
    right := products.tail^.prev;
    {$B-}
    while swapped do 
    begin   
        swapped := False;
        i := left;
        while i <> right^.next do
        begin
            comparisons := comparisons + 1;
            if (i^.item^.cost.int > i^.next^.item^.cost.int) 
                or ((i^.item^.cost.int =  i^.next^.item^.cost.int) and (i^.item^.cost.dec >  i^.next^.item^.cost.dec)) then begin
                tmpElement := i^.next^.item;
                i^.next^.item := i^.item;
                i^.item := tmpElement;
                swapped := True;
                permutations := permutations + 1;
            end;
            i := i^.next;
        end;
        //if nothing moved, then array is sorted
        if not swapped then Break;

        //otherwise, reset the swapped flag so that it can be used in the next stage
        swapped := False;

        i := right;
        while i <> left do
        begin
            comparisons := comparisons + 1;
            if (i^.item^.cost.int < i^.prev^.item^.cost.int)
                or ((i^.item^.cost.int = i^.prev^.item^.cost.int) and (i^.item^.cost.dec < i^.prev^.item^.cost.dec)) then begin
                tmpElement := i^.prev^.item;
                i^.prev^.item := i^.item;
                i^.item := tmpElement;
                swapped := True;
                permutations := permutations + 1;
            end;
            i := i^.prev;
        end;
        left := left^.next;
        right := right^.prev;
        //for i := 0 to High(productsArray) do WriteLn(productsArray[i].cost.int, ' ', productsArray[i].cost.dec);
    end;
    {$B+}
end;

begin
    initializeProducts(list_of_products, '/Users/khasanovsm/OneDrive/Programming/Pascal/CS_MSU/semester_proj/input_data/raw_input_data.txt');
    CoctailSort(list_of_products);
    WriteLn(comparisons,' ', permutations);
    elem := list_of_products.header;
    while True do
    begin
        WriteLn(elem^.item^.cost.int, ' ', elem^.item^.cost.dec);
        if elem^.next <> nil then elem := elem^.next
        else Break;
    end;
    //WriteLn(list_of_products.tail^.item^.cost.int, ' ', list_of_products.tail^.item^.cost.dec);
end.