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

begin
  
end.