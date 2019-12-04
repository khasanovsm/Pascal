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
    darray_of_products = array of RChocolate;

    performance_parameters = array [1..2] of UInt64;

Var
    productsArray : darray_of_products;

    i : UInt32;
    pp : performance_parameters;

    FromTime, ToTime: TDateTime;
    DiffMinutes: Integer;

procedure initializeProductsArray(var productsArray : darray_of_products; length : UInt32);
var 
    i : UInt32;
begin
    SetLength(productsArray,Length);
    for i := 0 to High(productsArray) do 
    begin
        New(productsArray[i]);
        productsArray[i]^.cost.int := Random(200)  + 36;
        productsArray[i]^.cost.dec := Random(100);
    end;
end;


function CoctailSort(var productsArray: darray_of_products): performance_parameters;
var 
    leftIndex, rightIndex, i: UInt32;
    tmpElement : RChocolate;
begin
    CoctailSort[1] := 0;
    CoctailSort[2] := 0;
    leftIndex := 0;
    rightIndex := High(productsArray);
    {$B-}
    while (leftIndex < rightIndex) and (leftIndex <> rightIndex) do 
    begin   
        for i := leftIndex to rightIndex - 1 do
        begin
            CoctailSort[1] := CoctailSort[1] + 1;
            if (productsArray[i]^.cost.int > productsArray[i + 1]^.cost.int) 
            or ((productsArray[i]^.cost.int = productsArray[i + 1]^.cost.int) and (productsArray[i]^.cost.dec > productsArray[i + 1]^.cost.dec)) then begin
                CoctailSort[2] := CoctailSort[2] + 1;
                tmpElement := productsArray[i + 1];
                productsArray[i + 1] := productsArray[i];
                productsArray[i] := tmpElement;
            end;
        end;

        for i := rightIndex - 1 downto leftIndex + 1 do
        begin
            CoctailSort[1] := CoctailSort[1] + 1;
            if (productsArray[i]^.cost.int < productsArray[i - 1]^.cost.int)
            or ((productsArray[i]^.cost.int = productsArray[i + 1]^.cost.int) and (productsArray[i]^.cost.dec < productsArray[i + 1]^.cost.dec)) then begin
                CoctailSort[2] := CoctailSort[2] + 1;
                tmpElement := productsArray[i - 1];
                productsArray[i - 1] := productsArray[i];
                productsArray[i] := tmpElement;
            end;
        end;
        leftIndex := leftIndex + 1;
        rightIndex := rightIndex - 1;
        //for i := 0 to High(productsArray) do WriteLn(productsArray[i].cost.int, ' ', productsArray[i].cost.dec);
    end;
    {$B+}
end;

function Merge(var left : darray_of_products; var right : darray_of_products; var init : darray_of_products) : performance_parameters;
var i, j, k: UInt32;
begin
    i := 0;
    j := 0;
    k := 0;
    {$B-}
    while (j < Length(left) ) and (k < Length(right)) do
    begin
        if (left[j]^.cost.int < right[k]^.cost.int) or ((left[j]^.cost.int = right[k]^.cost.int) and (left[j]^.cost.dec < right[k]^.cost.dec)) then begin
            init[i] := left[j];
            j := j + 1;
        end
        else begin
            init[i] := right[k];
            k := k + 1;
        end;
        i := i + 1;
        Merge[1] := Merge[1] + 1;
        Merge[2] := Merge[2] + 1;
    end;
    while (j < Length(left)) do
    begin
        init[i] := left[j];
        j := j + 1;
        i := i + 1;  

        Merge[2] := Merge[2] + 1;
    end;
    while (k < Length(right)) do
    begin
        init[i] := right[k];
        k := k + 1;
        i := i + 1;  

        Merge[2] := Merge[2] + 1;
    end;
    {$B+}
end;

procedure MergeSort(var productsArray : darray_of_products);
var left, right : darray_of_products;
    i,j : UInt32;
begin
    if Length(productsArray) < 2 then exit;
    
    SetLength(left, trunc((Length(productsArray)) / 2));
    SetLength(right, Length(productsArray) - Length(left));
    for i := 0 to High(left) do left[i] := productsArray[i];
    for j := 0 to High(right) do right[j] := productsArray[i + j + 1];
    //for i := 0 to High(left) do WriteLn('left[',i,'] = ', left[i]^.cost.int);
    //for i := 0 to High(right) do WriteLn('right[',i,'] = ', right[i]^.cost.int);
    MergeSort(left);
    MergeSort(right);
    //for i := 0 to High(left) do WriteLn('left[',i,'] = ', left[i]^.cost.int);
    //for i := 0 to High(right) do WriteLn('right[',i,'] = ', right[i]^.cost.int);
    Merge(left, right, productsArray);
    //WriteLn('Merged');
    //for i := 0 to High(left) do WriteLn('left[',i,'] = ', left[i]^.cost.int);
    //for i := 0 to High(right) do WriteLn('right[',i,'] = ', right[i]^.cost.int);
    //for i := 0 to High(productsArray) do WriteLn('products[',i,'] = ', productsArray[i]^.cost.int);
end;

procedure CreateInputDataFile(const products : darray_of_products; path : String);
var f : TextFile;
    i : UInt32 = 0;
    price : Double;
begin
    AssignFile(f, path);
    Rewrite(f);
    while i < High(productsArray) do begin
        WriteLn(f,'Milk');
        WriteLn(f,'Lindt');
        price := products[i]^.cost.int + products[i]^.cost.dec / 100;
        WriteLn(f,price:2:2);
        WriteLn(f,'---');
        i := i + 1;
    end;
    CloseFile(f);
end;

begin
    initializeProductsArray(productsArray, 100);
    //for i := 0 to High(productsArray) do WriteLn(productsArray[i]^.cost.int, ' ', productsArray[i]^.cost.dec);
    //pp := CoctailSort(productsArray);
    //Writeln(pp[1], ' ', pp[2]);
    //for i := 0 to High(productsArray) do WriteLn(productsArray[i].cost.int, ' ', productsArray[i].cost.dec);
    //(*
    FromTime := Now;
    //MergeSort(productsArray);
    //CoctailSort(productsArray);
    ToTime := Now;
    DiffMinutes := MilliSecondsBetween(ToTime,FromTime);
    WriteLn(DiffMinutes);
    //*)
    CreateInputDataFile(productsArray,'/Users/khasanovsm/OneDrive/Programming/Pascal/CS_MSU/semester_proj/raw_input_data.txt');
    //WriteLn('Sorted');
    //for i := 0 to High(productsArray) do WriteLn(productsArray[i]^.cost.int, ' ', productsArray[i]^.cost.dec);
    //EssentialMergeSort(productsArray);
end.