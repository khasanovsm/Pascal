program backup;

function ForwardExtractSeq(var x : darray_of_products) : RDArray;
var i : UInt32;
    j : UInt32;
    seqHeaderIndex : UInt32 = 0;
    cseq_len : UInt32 ;
    hseq_len : UInt32 = 1;
begin
    {$B-}
    for i := 0 to High(x) - 1 do
    begin
        cseq_len := 1;
        if ((x[i] <> nil) and (x[i + 1] <> nil)) and ((x[i]^.cost.int  <= x[i + 1]^.cost.int) or ((x[i]^.cost.int = x[i + 1]^.cost.int) and (x[i]^.cost.dec  <= x[i + 1]^.cost.dec))) then begin
            cseq_len := cseq_len + 1;
            for j := i + 1 to High(x) - 1 do
            begin
                if ((x[j] <> nil) and (x[j + 1] <> nil)) and ((x[j]^.cost.int  <= x[j + 1]^.cost.int) 
                    or ((x[j]^.cost.int = x[j + 1]^.cost.int) and (x[j]^.cost.dec  <= x[j + 1]^.cost.dec))) then cseq_len :=  cseq_len + 1
                else Break;
            end;
        end;
        if cseq_len > hseq_len then begin 
            seqHeaderIndex := i;
            hseq_len := cseq_len;
        end;
    end;
    {$B+}
    
    New(ForwardExtractSeq);
    SetLength(ForwardExtractSeq^,hseq_len);
    for i := seqHeaderIndex to (seqHeaderIndex + hseq_len - 1) do begin
        ForwardExtractSeq^[i - seqHeaderIndex] := x[i];
        x[i] := Nil;
    end;
end;

function ForwardExtractSeq_Boosted(var x : darray_of_products) : RDArray;
var i : UInt32 = 0;
    j : UInt32;
    seqHeaderIndex : UInt32 = 0;
    cseq_len : UInt32 ;
    hseq_len : UInt32 = 1;
begin
    {$B-}
    while  i < High(x) do
    begin
        cseq_len := 1;
        if ((x[i] <> nil) and (x[i + 1] <> nil)) and ((x[i]^.cost.int  <= x[i + 1]^.cost.int) or ((x[i]^.cost.int = x[i + 1]^.cost.int) and (x[i]^.cost.dec  <= x[i + 1]^.cost.dec))) then begin
            cseq_len := cseq_len + 1;
            for j := i + 1 to High(x) - 1 do
            begin
                if ((x[j] <> nil) and (x[j + 1] <> nil)) and ((x[j]^.cost.int  <= x[j + 1]^.cost.int) 
                    or ((x[j]^.cost.int = x[j + 1]^.cost.int) and (x[j]^.cost.dec  <= x[j + 1]^.cost.dec))) then cseq_len :=  cseq_len + 1
                else Break;
            end;
            if cseq_len > hseq_len then begin 
                seqHeaderIndex := i;
                hseq_len := cseq_len;
            end;
            i := j + 1;
            Continue;
        end;
        i := i + 1;
    end;
    {$B+}
    
    New(Result);
    SetLength(Result^,hseq_len);
    for i := seqHeaderIndex to (seqHeaderIndex + hseq_len - 1) do begin
        Result^[i - seqHeaderIndex] := x[i];
        x[i] := Nil;
    end;
end;

function ReverseExtractSeq_Boosted(var x : darray_of_products) : RDArray;
var i : UInt32;
    j : UInt32;
    seqHeaderIndex : UInt32;
    cseq_len : UInt32 ;
    hseq_len : UInt32 = 1;
begin
    seqHeaderIndex := High(x);
    i := High(x);
    {$B-}
    while i > 0 do
    begin
        cseq_len := 1;
        if ((x[i] <> nil) and (x[i - 1] <> nil)) and ((x[i]^.cost.int  <= x[i - 1]^.cost.int) or ((x[i]^.cost.int = x[i - 1]^.cost.int) and (x[i]^.cost.dec  <= x[i - 1]^.cost.dec))) then begin
            cseq_len := cseq_len + 1;
            for j := i - 1 downto 1 do
            begin
                if ((x[j] <> nil) and (x[j - 1] <> nil)) and ((x[j]^.cost.int  <= x[j - 1]^.cost.int) 
                    or ((x[j]^.cost.int = x[j - 1]^.cost.int) and (x[j]^.cost.dec  <= x[j - 1]^.cost.dec))) then cseq_len :=  cseq_len + 1
                else Break;
            end;
            if cseq_len > hseq_len then begin 
                seqHeaderIndex := i;
                hseq_len := cseq_len;
            end;
            i := j - 1;
            Continue;
        end;
        i := i - 1;
    end;
    {$B+}
    
    New(Result);
    SetLength(Result^,hseq_len);
    for i := seqHeaderIndex downto (seqHeaderIndex - hseq_len + 1) do begin
        Result^[i - seqHeaderIndex] := x[i];
        x[i] := Nil;
    end;
end;

procedure EssentialMergeSort(var X : darray_of_products);
var direct, reverse : darray_of_products;
    i : UInt32;
begin
    direct := ForwardExtractSeq_Boosted(X)^;
    WriteLn('direct');
    for i := 0 to High(direct) do WriteLn(direct[i]^.cost.int);
    WriteLn('reverse');
    reverse := ReverseExtractSeq_Boosted(X)^;
    for i := 0 to High(reverse) do WriteLn(reverse[i]^.cost.int);
end;

(*
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
            or ((productsArray[i]^.cost.int = productsArray[i - 1]^.cost.int) and (productsArray[i]^.cost.dec < productsArray[i - 1]^.cost.dec)) then begin
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



procedure CreateInputDataFile(N : UInt32; path : String);
var f : TextFile;
    i : UInt32 = 1;
    price : Double;
    price_even : Double = 268.00;
    price_odd : Double = 268.00;
begin
    AssignFile(f, path);
    Rewrite(f);
    while i <= N do begin
        WriteLn(f,'Milk');
        WriteLn(f,'Lindt');
        if i mod 2 = 0 then begin
          price_even := price_even + i * 0.04;
          price := price_even;
        end
        else begin
          price_odd := price_odd - i * 0.06;
          price := price_odd;
        end; 
        WriteLn(f,price:2:2);
        WriteLn(f,'---');
        i := i + 1;
    end;
    CloseFile(f);
end;
*)

begin
  
end.