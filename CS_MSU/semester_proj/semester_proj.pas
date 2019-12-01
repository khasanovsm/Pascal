program semester_proj;

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

    darray_of_products = array of Chocolate;
Var
    productsList : darray_of_products;
    i : UInt32;

procedure initializeProductsList(var products : darray_of_products; length : UInt32);
var 
    i : UInt32;
begin
    SetLength(productsList,Length);
    for i := 0 to High(productsList) do 
    begin
        products[i].cost.int := Random(200)  + 36;
        products[i].cost.dec := Random(100);
    end;
end;

procedure CoctailSort(var products: darray_of_products);
var 
    i, j : UInt32;
    tmpElement : Chocolate;
begin
    j := 0;
    while j < (High(products) / 2 + 1) do 
    begin   
        for i := j to (High(products) - 1 - j) do
        begin
            if products[i].cost.int > products[i + 1].cost.int then begin
                tmpElement := products[i + 1];
                products[i + 1] := products[i];
                products[i] := tmpElement;
            end;
        end;
        for i := (High(products) - 1 - j) downto j + 1 do
        begin
            //Writeln(productsList[i].cost.int, ' ', productsList[i].cost.dec,
            //                        ' i + 1  ',productsList[i + 1].cost.int, ' ', productsList[i + 1].cost.dec) ;
            if products[i].cost.int < products[i - 1].cost.int then begin
                tmpElement := products[i - 1];
                products[i - 1] := products[i];
                products[i] := tmpElement;
            end;
        end;
        j := j + 1;
    end;
end;

begin
    initializeProductsList(productsList, 200);
    CoctailSort(productsList);
    for i := 0 to High(productsList) do
        Writeln(productsList[i].cost.int, ' ', productsList[i].cost.dec);
end.