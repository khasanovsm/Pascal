program semester_proj;
uses crt, math;
Type 
    Price = record
        int: UInt32;
        dec: UInt8;
    end;
    
    Chocolate = record
        kind: String;
        producer : String;
        cost : Price;
    end;

    RChocolate = ^Chocolate;

    //dynamic array
    darray_of_products = array of RChocolate;

Var
    products: darray_of_products;
    comparisons, permutations : UInt64;
    i : UInt32;

procedure initializeProducts(var products : darray_of_products; N : UInt32;file_path : String);
var 
    f : TextFile;
    price : Real;
    i : Integer  = 0;
begin
    AssignFile(f, file_path);
    Reset(f);

    SetLength(products, 10);

    while (not EOF(f)) and (i <= N) do
    begin
        if i = High(products) then SetLength(products, Length(products)  + 10);
        New(products[i]);
        ReadLn(f,products[i]^.kind);
        Readln(f,products[i]^.producer);
        ReadLn(f, price);
        ReadLn(f);
        products[i]^.cost.int := trunc(price);
        products[i]^.cost.dec := trunc((price - trunc(price))*100);
        i := i + 1;
    end;
    CloseFile(f);
    for i := 0 to High(products) do if products[i] = nil then Break;
    products := Copy(products,0, i);
end;

procedure CoctailSort(var products: darray_of_products); //tested
var  
    leftIndex, rightIndex, i: UInt32;
    tmpElement : RChocolate;
    swap : Boolean = False;
begin
    leftIndex := 0;
    rightIndex := High(products);
    {$B-}
    while (leftIndex < rightIndex) and (leftIndex <> rightIndex) and (not swap) do 
    begin   
        for i := leftIndex to rightIndex - 1 do
        begin
            comparisons := comparisons  + 1;
            if products[i + 1] =  Nil then Break;
            if (products[i]^.cost.int > products[i + 1]^.cost.int) 
            or ((products[i]^.cost.int = products[i + 1]^.cost.int) and (products[i]^.cost.dec > products[i + 1]^.cost.dec)) then begin
                permutations := permutations + 1;
                tmpElement := products[i + 1];
                products[i + 1] := products[i];
                products[i] := tmpElement;
                swap := True;
            end;
        end;
        if swap then begin
            for i := rightIndex - 1 downto leftIndex + 1 do
            begin
                comparisons := comparisons  + 1;
                if products[i] =  Nil then Continue;
                if (products[i]^.cost.int < products[i - 1]^.cost.int)
                or ((products[i]^.cost.int = products[i - 1]^.cost.int) and (products[i]^.cost.dec < products[i - 1]^.cost.dec)) then begin
                    permutations := permutations + 1;
                    tmpElement := products[i - 1];
                    products[i - 1] := products[i];
                    products[i] := tmpElement;
                    swap := false;
                end;
            end;
        end 
        else swap := True;
        leftIndex := leftIndex + 1;
        rightIndex := rightIndex - 1;
        //for i := 0 to High(products) do WriteLn(products[i].cost.int, ' ', products[i].cost.dec);
    end;
    {$B+}
end;


function FLIS(const products : darray_of_products; var subseq : darray_of_products): UInt32;
var 
    d,p : array of UInt32;
    i, j : UInt32;
begin
    
    SetLength(p, Length(products));
    SetLength(d, Length(products));

   for i := 0 to High(products) do
    begin
        if products[i] = Nil then begin
            d[i] := 0;
            Continue;
        end;
        d[i] := 1;
        p[i] := i;
        j := 0;
        while j < i do
        begin
            if products[j] = nil then begin
                j := j + 1;
                Continue;
            end;
            comparisons := comparisons  + 1;
            permutations := permutations  + 1;
            if (products[i]^.cost.int >= products[j]^.cost.int) or ((products[i]^.cost.int = products[j]^.cost.int) and (products[i]^.cost.dec >= products[j]^.cost.dec)) then begin
                if (1 + d[j] > d[i]) then begin
                    d[i] := 1 + d[j];
                    p[i] := j;
                end;
            end;
            j := j + 1;
        end;
    end;
    j := 0;
    FLIS := d[0];
    for i := 0 to High(products) do begin 
        comparisons := comparisons  + 1;
        if d[i] > FLIS then begin 
            j := i;
            FLIS := d[i];
        end;
    end;
    if FLIS = 0 then exit;
    //Fil subseq
    SetLength(subseq,FLIS);
    i := High(subseq);
    while (p[j] <> j) or (FLIS = 1) do begin
        permutations := permutations + 1;
        subseq[i] := products[j];
        products[j] := Nil;
        if i > 0 then i := i - 1
        else Break;
        j := p[j];
        if p[j] = j then begin
            permutations := permutations + 1;
            subseq[i] := products[p[j]];
            products[p[j]] := Nil;
            Break;
        end; 
    end;
    //WriteLn('---------------FLIS---------------');
    //for i := 0 to High(subseq) do WriteLn(subseq[i]^.cost.int);
end;


function BLIS(const products : darray_of_products; var subseq : darray_of_products): UInt32;
var 
    d,p : array of UInt32;
    i, j : UInt32;
begin
    SetLength(p, Length(products));
    SetLength(d, Length(products));

   for i := High(products) downto 0 do
    begin
        comparisons := comparisons + 1;
        if products[i] = Nil then  begin
            d[i] := 0;
            Continue;
        end; 
        d[i] := 1;
        p[i] := i;
        j := High(products);
        while j > i do
        begin
            comparisons := comparisons + 1;
            permutations := permutations  + 1;
            if products[j] = Nil then begin 
                j := j - 1;
                Continue;
            end;
            if (products[i]^.cost.int >= products[j]^.cost.int) or ((products[i]^.cost.int = products[j]^.cost.int) and (products[i]^.cost.dec >= products[j]^.cost.dec)) then begin
                if (1 + d[j] > d[i]) then begin
                    d[i] := 1 + d[j];
                    p[i] := j;
                end;
            end;
            j := j - 1;
        end;
    end;
    j := 0;
    BLIS := d[0];
    for i := 0 to High(products) do begin 
        comparisons := comparisons  + 1;
        if d[i] > BLIS then begin 
            j := i;
            BLIS := d[i];
        end;
    end;
    if BLIS = 0 then exit;
    //WriteLn(BLIS, ' ', j);
    //Fil subseq
    SetLength(subseq,BLIS);
    i := High(subseq);
    while (p[j] <> j) or (BLIS = 1) do begin
        permutations := permutations + 1;
        subseq[i] := products[j];
        products[j] := Nil;
        if i > 0 then i := i - 1
        else Break;
        j := p[j];
        if p[j] = j then begin
            permutations := permutations + 1;
            subseq[i] := products[p[j]];
            products[p[j]] := Nil;
            Break;
        end; 
    end;
    //WriteLn('---------------BLIS---------------');
    //for i := 0 to High(subseq) do WriteLn(subseq[i]^.cost.int);
end;

function LIS(const products : darray_of_products) : UInt32;
var d : array of UInt32;
    i : UInt32;
begin
    SetLength(d, Length(products));
    d[0] := 0;
    for i := 0 to High(d) do d[i] := 100000;

    for i := 0 to high(d) do
      for j := 1 to high(d) do 
        if (d[j-1] < products[i]^.cost.int) and (products[i]^.cost.int < d[j]) then
            d[j] := products[i]^.cost.int;
end;

procedure Merge(const left, right : darray_of_products; var init : darray_of_products);
var i, j, k: UInt32;
begin
    i := 0;
    j := 0;
    k := 0;
    {$B-}
    while (j < Length(left) ) and (k < Length(right)) do
    begin
        comparisons := comparisons  + 1;
        if (left[j]^.cost.int < right[k]^.cost.int) or ((left[j]^.cost.int = right[k]^.cost.int) and (left[j]^.cost.dec < right[k]^.cost.dec)) then begin
            init[i] := left[j];
            j := j + 1;
            permutations := permutations  + 1;
        end
        else begin
            init[i] := right[k];
            k := k + 1;
            permutations := permutations  + 1;
        end;
        i := i + 1;
    end;
    while (j < Length(left)) do
    begin
        permutations := permutations  + 1;
        init[i] := left[j];
        j := j + 1;
        i := i + 1;  
    end;
    while (k < Length(right)) do
    begin
        permutations := permutations  + 1;
        init[i] := right[k];
        k := k + 1;
        i := i + 1;  
    end;
    {$B+}
end;

procedure EssentialMergeSort(var products : darray_of_products);
var left, right, y : darray_of_products;
    m, n, i, j: UInt32;
begin
    SetLength(y, Length(products));
    m := FLIS(products, left);
    n := BLIS(products, right);
    Merge(left,right, y);
    if (length(left) < Length(products)) and (Length(right) < Length(products)) then begin
        j := 0;
        for i := 0 to high(products) do 
        if (products[i] <> nil) then begin
            permutations := permutations + 1;
            y[m + n + j] := products[i];
            j := j + 1;
        end;
        //WriteLn('---------------Merge---------------');
        //for i := 0 to high(y) do WriteLn(y[i]^.cost.int);
        EssentialMergeSort(y);
    end;
    products := y;
end;

begin
    comparisons := 0;
    permutations := 0;
    initializeProducts(products, 50, '/Users/khasanovsm/OneDrive/Programming/Pascal/CS_MSU/semester_proj/input_data/odd_incr_input_data.txt');
    //CoctailSort(products);
    //for i := 0 to High(products) do WriteLn(products[i]^.cost.int);
    EssentialMergeSort(products);
    //for i := 0 to high(products) do WriteLn(products[i]^.cost.int, ' ', products[i]^.cost.dec);
    WriteLn('comp = ', comparisons, ' permut = ', permutations)
end.
