(*$IFDEF define_types*)

// -*- Module: Plan:Diverses

  { Exceptions }
  EHashAccessError = class(Exception);

  { Hash record }
  P_ACHASH_RECORD_ = ^_ACHASH_RECORD_;
  _ACHASH_RECORD_ = record
    Left: P_ACHASH_RECORD_;
    Right: P_ACHASH_RECORD_;
    LWeight: integer;
    RWeight: integer;
    Key: _ACHASH_KEY_;
    Value: _ACHASH_VALUE_;
  end;

  THashCompareFunc = function(const a,b): Integer;

  { TAcHash Component }
  _ACHASH_ = class(TComponent)
  private
    { Private declarations }
    FTop: P_ACHASH_RECORD_;
    FCount: integer;
    FTrvWin: array of integer;
    FTrvIndx: integer;
    FProfile: boolean;
    FCompare: THashCompareFunc;

    procedure Prune(Rec: P_ACHASH_RECORD_);
    function Rebalance(Rec: P_ACHASH_RECORD_): P_ACHASH_RECORD_;
    function ShiftRight(Rec: P_ACHASH_RECORD_): P_ACHASH_RECORD_;
    function ShiftLeft(Rec: P_ACHASH_RECORD_): P_ACHASH_RECORD_;
    function GetAvgTrv: integer;
{    procedure GetKeys(Rec: P_ACHASH_RECORD_; StrLst: TStringList);}
//    procedure GetKeysSorted(Rec: P_ACHASH_RECORD_; StrLst: TStringList);

    procedure CopyKeys(Rec: P_ACHASH_RECORD_);

  protected
    { Protected declarations }
    procedure ListKeys(Rec: P_ACHASH_RECORD_; out a: _ACHASH_KEY_ARRAY_);


  public
    { Public declarations }
    constructor Create(AOwner: TComponent; ACallback: THashCompareFunc); reintroduce;
    destructor Destroy; override;

    property Count: integer read FCount;
    property AverageTraversals: integer read GetAvgTrv;
    property HashStructure: P_ACHASH_RECORD_ read FTop;
    property Profile: boolean read FProfile write FProfile;
    procedure Clear; virtual;
    procedure AssignValue(const Key: _ACHASH_KEY_; const Value: _ACHASH_VALUE_); virtual;
    procedure AssignValues(Hash: _ACHASH_);
    procedure Delete(const Key: _ACHASH_KEY_); virtual;
    function Retrieve(const Key: _ACHASH_KEY_): _ACHASH_VALUE_; virtual;
    function Exists(const Key: _ACHASH_KEY_): boolean; virtual;
{    procedure Keys(KeyList: TStringList; const Sort: boolean = False);}
    function XRetrieve(Key: _ACHASH_KEY_): _ACHASH_VALUE_;
    procedure XAssignValue(Key: _ACHASH_KEY_; Value: _ACHASH_VALUE_);
    property Values[k: _ACHASH_KEY_] : _ACHASH_VALUE_ read XRetrieve write XAssignValue; default;
    function GetKeysArray: _ACHASH_KEY_ARRAY_;

  published
    { Published declarations }

  end;

(*$ENDIF define_types*)
(*$IFDEF define_implementation*)

// -*- Module: Plan:Diverses

//******************* Register *************************
// Modify the first argument to the name of the palette you
// want the component to appear on.
//procedure Register;
//begin
//  RegisterComponents('AC DB', [_ACHASH_]);
//end;

{ _ACHASH_ }

//type
//  P_ACHASH_RECORD_ = ^_ACHASH_RECORD_;

function ConvertH(const v:Integer): Variant; overload;
begin
  Result := IntToStr(v);
end;

function ConvertH(const v:string): Variant; overload;
begin
  Result := v;
end;

{
function CompareH(const a,b:Integer): Integer; overload;
begin
  if a < b then Result := -1
  else if a > b then Result := 1
  else Result := 0;
end;

function CompareH(const a,b:string): Integer; overload;
begin
  if a < b then Result := -1
  else if a > b then Result := 1
  else Result := 0;
end;

function CompareH(const a,b:Double): Integer; overload;
begin
  if a < b then Result := -1
  else if a > b then Result := 1
  else Result := 0;
end;

function CompareH(const a,b:Pointer): Integer; overload;
begin
  if Integer(a) < Integer(b) then Result := -1
  else if Integer(a) > Integer(b) then Result := 1
  else Result := 0;
end;
}

{function MyVarToStr(v: Variant): string;
var s: string;
begin
  if VarIsNull(v) then begin
    Result := 'null';
    Exit;
  end;

  s := VarToStr(v);
  if ((VarType(v) and varTypeMask) in [varSmallint, varInteger, varSingle, varDouble, varCurrency, varByte, varDate]) then begin
    // isNumeric
    s := Format('%*s', [NUMBER_PAD_TO_TOTAL_LEN, s]);
  end;

  Result := s;
end;}

//******************* _ACHASH_.AssignValue *************************
// The public method that will either add or update a value as needed.
procedure _ACHASH_.AssignValue(const Key: _ACHASH_KEY_; const Value: _ACHASH_VALUE_);
var
  IncNodes: array of P_ACHASH_RECORD_;
  Parent, Child, RB, PRB, NewNode: P_ACHASH_RECORD_;
  DeadEnd: boolean;
  Wdiff, I: integer;

begin

  // Walk the tree to where the node should be
  DeadEnd := False;
  Parent := nil;
  RB := nil;
  PRB := nil;
  Child := FTop;

  while Not DeadEnd do begin
    if Not Assigned(Child) then
      DeadEnd := True
    else begin
      if FCompare(Child^.Key, Key) = 0 then
        Break
      else begin
        Parent := Child;
        SetLength(IncNodes, High(IncNodes) + 2);
        IncNodes[High(IncNodes)] := Parent;
        if FCompare(Key, Parent^.Key) > 0 then
          Child := Parent^.Right
        else
          Child := Parent^.Left;
        if Not Assigned(Child) then
          DeadEnd := True;
      end;
    end;
  end;

  // Add a node if this is a dead end
  if DeadEnd then begin

    // Create the record
    New(NewNode);
    NewNode^.Key := Key; //StrNew(PChar(Key));
    NewNode^.Value := Value; //StrNew(PChar(Value));
    NewNode^.Right := nil;
    NewNode^.Left := nil;
    NewNode^.RWeight := 0;
    NewNode^.LWeight := 0;

    // Assign it where appropriate
    if Not Assigned(FTop) then
      FTop := NewNode
    else if FCompare(Key, Parent^.Key) > 0 then
      Parent^.Right := NewNode
    else
      Parent^.Left := NewNode;

    // Increment the branch weights of the nodes we've stored
    for I := 0 to High(IncNodes) do begin
      if FCompare(Key, IncNodes[I]^.Key) > 0 then
        Inc(IncNodes[I]^.RWeight)
      else
        Inc(IncNodes[I]^.LWeight);
      Wdiff := Abs(IncNodes[I]^.RWeight - IncNodes[I]^.LWeight);
      if (Not Assigned(RB)) And (Wdiff > 1) then
        RB := IncNodes[I];
      if Not Assigned(RB) then
        PRB := IncNodes[I];
    end;

    // Increment the key count
    Inc(FCount);

    // Rebalance the tree if necessary
    if Assigned(RB) then begin
      if Not Assigned(PRB) then
        FTop := Rebalance(RB)
      else if RB = PRB^.Left then
        PRB^.Left := Rebalance(RB)
      else
        PRB^.Right := Rebalance(RB);
    end;

  // Update the node value
  end else begin
    //StrDispose(Child^.Value);
    Child^.Value := Value; //StrNew(PChar(Value));
  end;

end;

//******************* _ACHASH_.AssignValues *************************
// Copies all of the values from the passed hash into itself
procedure _ACHASH_.AssignValues(Hash: _ACHASH_);
begin

  if Assigned(Hash.HashStructure) then
    CopyKeys(Hash.HashStructure);

end;

//******************* _ACHASH_.Clear *************************
// Empties the b-tree and resets the node counter.
procedure _ACHASH_.Clear;
begin

  if Assigned(FTop) then begin
    Prune(FTop);
    FTop := nil;
    FCount := 0;
  end;

end;

procedure _ACHASH_.CopyKeys(Rec: P_ACHASH_RECORD_);
begin

  AssignValue(Rec^.Key, Rec^.Value);
  if Assigned(Rec^.Left) then
    CopyKeys(Rec^.Left);
  if Assigned(Rec^.Right) then
    CopyKeys(Rec^.Right);

end;

//******************* _ACHASH_.Create *************************
// Initialises some internal state defaults.
constructor _ACHASH_.Create(AOwner: TComponent; ACallback: THashCompareFunc);
begin
  inherited Create(AOwner);

  // Set some default values
  FTop := nil;
  FCount := 0;
  FTrvIndx := 0;
  SetLength(FTrvWin, 1);
  FTrvWin[0] := 0;
  FProfile := False;
  FCompare := ACallback;

end;

//******************* _ACHASH_.Delete *************************
// Deletes the specified key/value pair and rebalances the tree
procedure _ACHASH_.Delete(const Key: _ACHASH_KEY_);
var
  DecNodes: array of P_ACHASH_RECORD_;
  Parent, Child, DelNode, RB, PRB, Branch1, Branch2: P_ACHASH_RECORD_;
  Found: boolean;
  Wdiff, NWeight, I: integer;

begin

  // Make sure there's something to delete
  if Assigned(FTop) then begin

    // Set our starting positions, etc.
    Parent := nil;
    Child := FTop;
    RB := nil;
    PRB := nil;
    Found := False;
    SetLength(DecNodes, 0);

    // Start walking the tree
    while Not Found do
      if FCompare(Child^.Key, Key) = 0 then
        Found := True
      else begin
        Parent := Child;
        SetLength(DecNodes, High(DecNodes) + 2);
        DecNodes[High(DecNodes)] := Parent;
        if FCompare(Key, Parent^.Key) > 0 then
          Child := Parent^.Right
        else
          Child := Parent^.Left;
        if Not Assigned(Child) then
          Break;
      end;

    // Only continue if we found the node to delete
    if Found then begin
      DelNode := Child;

      // Decrement the branch weights of the nodes we've stored
      for I := 0 to High(DecNodes) do begin
        if FCompare(Key, DecNodes[I]^.Key) > 0 then
          Dec(DecNodes[I]^.RWeight)
        else
          Dec(DecNodes[I]^.LWeight);
        Wdiff := Abs(DecNodes[I]^.RWeight - DecNodes[I]^.LWeight);
        if (Not Assigned(RB)) And (Wdiff > 1) then
          RB := DecNodes[I];
        if Not Assigned(RB) then
          PRB := DecNodes[I];
      end;

      // Figure out what branches we have to deal with
      if Assigned(DelNode^.Left) then begin
        Branch1 := DelNode^.Left;
        Branch2 := DelNode^.Right;
      end else begin
        Branch1 := DelNode^.Right;
        Branch2 := nil;
      end;

      // Attach Branch1 where appropriate
      if Assigned(Branch1) then begin
        if DelNode = FTop then
          FTop := Branch1
        else if DelNode = Parent^.Left then
          Parent^.Left := Branch1
        else
          Parent^.Right := Branch1;

      // Set pointers to nil since there's nothing to reattach
      end else begin
        if DelNode = FTop then
          FTop := nil
        else if DelNode = Parent^.Left then
          Parent^.Left := nil
        else
          Parent^.Right := nil;
      end;

      // Attach Branch2 where appropriate
      if Assigned(Branch2) then begin
        NWeight := Branch2^.LWeight + Branch2^.RWeight + 1;
        Child := Branch1;
        Found := False;

        while Not Found do begin
          Parent := Child;
          Parent^.RWeight := Parent^.RWeight + NWeight;
          Wdiff := Abs(Parent^.RWeight - Parent^.LWeight);
          if (Not Assigned(RB)) And (Wdiff > 1) then
            RB := Parent;
          if Not Assigned(RB) then
            PRB := Parent;
          if Assigned(Parent^.Right) then
            Child := Parent^.Right
          else begin
            Parent^.Right := Branch2;
            Parent^.RWeight := NWeight;
            Found := True;
          end;
        end;
      end;

      // Delete the node
      //StrDispose(DelNode^.Key);
      //StrDispose(DelNode^.Value);
      Dispose(DelNode); // problems with "string" datatype?

      // Decrement the key count
      Dec(FCount);

      // Rebalance RB from PRB's pointer
      if Assigned(RB) then begin
        if Not Assigned(PRB) then
          FTop := Rebalance(RB)
        else if RB = PRB^.Left then
          PRB^.Left := Rebalance(RB)
        else
          PRB^.Right := Rebalance(RB);
      end;
    end;
  end;

end;

//******************* _ACHASH_.Destroy *************************
// Deallocates all records via the public Clear method.
destructor _ACHASH_.Destroy;
begin

  Clear;
  inherited Destroy;

end;

//******************* _ACHASH_.Exists *************************
// Attempts to retrieve a value, catching its own exception if
// the key does not exist in the hash.
function _ACHASH_.Exists(const Key: _ACHASH_KEY_): boolean;
begin

  try
    Retrieve(Key);
    Result := True;
  except
    on EHashAccessError do
      Result := False;
  end;

end;

//******************* _ACHASH_.GetAvgTrv *************************
// Calculates the average number of node traversals necessary to
// find a key in the hash (this only works if the Profile property
// is set to True).  This is a moving window average, using the
// last ten traversal counts.
function _ACHASH_.GetAvgTrv: integer;
var
  Avg, I: integer;

begin

  // Return the single element if that's all there is
  if High(FTrvWin) = 0 then
    Avg := FTrvWin[0]

  // Otherwise, calculate the average of all elements
  else begin
    Avg := 0;
    for I := 0 to High(FTrvWin) do
      Avg := Avg + FTrvWin[I];
    Avg := Avg div (High(FTrvWin) + 1);
  end;

  // Return final value
  Result := Avg;

end;

{
//******************* _ACHASH_.GetKeys *************************
// This recursively walks the entire tree and populates the
// string list with all of the keys in the hash.
procedure _ACHASH_.GetKeys(Rec: P_ACHASH_RECORD_; StrLst: TStringList);
var k: Variant;
begin

  // Push the key of the current record onto the string list
  k := ConvertH(Rec^.Key);
  StrLst.Add(MyVarToStr(k));

  // Recursively descend down the tree
  if Assigned(Rec^.Right) then
    GetKeys(Rec^.Right, StrLst);
  if Assigned(Rec^.Left) then
    GetKeys(Rec^.Left, StrLst);

end;
}

{
function _ACHASH_.GetKeysA(Rec: P_ACHASH_RECORD_; StrLst: TStringList): _ACHASH_KEY_ARRAY;
var k: Variant;
begin

  // Push the key of the current record onto the string list
  k := ConvertH(Rec^.Key);
  StrLst.Add(MyVarToStr(k));

  // Recursively descend down the tree
  if Assigned(Rec^.Right) then
    GetKeys(Rec^.Right, StrLst);
  if Assigned(Rec^.Left) then
    GetKeys(Rec^.Left, StrLst);

end;
}

function _ACHASH_.GetKeysArray: _ACHASH_KEY_ARRAY_;
var
  a: _ACHASH_KEY_ARRAY_;
  Rec: P_ACHASH_RECORD_;
begin
  SetLength(a, 0);

  if Assigned(FTop) then begin
    Rec := FTop;
    ListKeys(Rec, a);
  end;

  Result := a;
end;

procedure _ACHASH_.ListKeys(Rec: P_ACHASH_RECORD_; out a: _ACHASH_KEY_ARRAY_);
var
  i: Integer;
begin
  if Assigned(Rec^.Left) then
    ListKeys(Rec^.Left, a);

  i := Length(a);
  SetLength(a, i + 1);
  a[i] := Rec^.Key;

  if Assigned(Rec^.Right) then
    ListKeys(Rec^.Right, a);
end;



//******************* _ACHASH_.GetKeysSorted *************************
// This calls itself recursively and populates a string list with
// all of the keys in the hash, but in sorted order
{procedure _ACHASH_.GetKeysSorted(Rec: P_ACHASH_RECORD_; StrLst: TStringList);
var k: Variant;
begin

  if Assigned(Rec^.Left) then
    GetKeysSorted(Rec^.Left, StrLst);

  k := ConvertH(Rec^.Key);
  StrLst.Add(MyVarToStr(k));

  if Assigned(Rec^.Right) then
    GetKeysSorted(Rec^.Right, StrLst);

end;}

{
//******************* _ACHASH_.Keys *************************
// This is the public method for retrieving the keys.
procedure _ACHASH_.Keys(KeyList: TStringList; const Sort: boolean = False);
begin

  // Clear the key list
  KeyList.Clear;

  // Begin populating the list by crawling the tree
  if Assigned(FTop) then begin
    if Sort then
      GetKeysSorted(FTop, KeyList)
    else
      GetKeys(FTop, KeyList);
  end;

end;
}

//******************* _ACHASH_.Prune *************************
// This recursively walks the tree to the bottom of each branch
// and deallocates all the memory associated with each record.
procedure _ACHASH_.Prune(Rec: P_ACHASH_RECORD_);
begin

  // Recursively descend and delete each child record
  if Assigned(Rec^.Right) then
    Prune(Rec^.Right);
  if Assigned(Rec^.Left) then
    Prune(Rec^.Left);

  // Dispose of the current record
  //StrDispose(Rec^.Key);
  //StrDispose(Rec^.Value);
  Dispose(Rec);

end;

//******************* _ACHASH_.Rebalance *************************
// This recursively rebalances all the branches below the node passed.
function _ACHASH_.Rebalance(Rec: P_ACHASH_RECORD_): P_ACHASH_RECORD_;
begin

  // Return the current node by default
  Result := Rec;

  // If it's out of balance
  if Abs(Rec^.RWeight - Rec^.LWeight) > 1 then begin

    // Keep shifting until the balance is restored
    while Abs(Result^.RWeight - Result^.LWeight) > 1 do begin

      // Shift in the right direction
      if Result^.RWeight > Result^.LWeight then
        Result := ShiftRight(Result)
      else
        Result := ShiftLeft(Result);
    end;
  end;

  // Call recursively for further rebalancing
  if Assigned(Result^.Right) then
    Result^.Right := Rebalance(Result^.Right);
  if Assigned(Result^.Left) then
    Result^.Left := Rebalance(Result^.Left);

end;

//******************* _ACHASH_.Retrieve *************************
// This walks the tree until the key is found, returning the
// associated value (or generating an exception if it wasn't
// found).
function _ACHASH_.Retrieve(const Key: _ACHASH_KEY_): _ACHASH_VALUE_;
var
  CRec: P_ACHASH_RECORD_;
  Found, DeadEnd: boolean;
  Trv: integer;

begin
//Result := '';

  if Assigned(FTop) then begin

    // Set some default tracking values
    Trv := 0;
    CRec := FTop;
    Found := False;
    DeadEnd := False;

    // Begin crawling the tree
    while (Not Found) And (Not DeadEnd) do begin

      // Count the number of node traversals
      Inc(Trv);

      // If the key equals the node key, we've found it
      if FCompare(Key,CRec^.Key) = 0 then
        Found := True

      // Take a right if the value is greater than the node key,
      // and if there's another node to crawl
      else if (FCompare(Key,CRec^.Key)>0) And (Assigned(CRec^.Right)) then
        CRec := CRec^.Right

      // Take a left if the value is less
      else if (FCompare(Key,CRec^.Key)<0) And (Assigned(CRec^.Left)) then
        CRec := CRec^.Left

      // Otherwise, we've hit a dead end
      else
        DeadEnd := True;

    end;

    // Report the associated value if we found a matching node
    if Found then begin
      Result := CRec^.Value;

      // Update FTrvWin, which we use as a moving average
      // of traversals to track performance, if profiling is enabled
      if FProfile then begin
        if FTrvIndx > High(FTrvWin) then
          SetLength(FTrvWin, FTrvIndx + 1);
        FTrvWin[FTrvIndx] := Trv;
        Inc(FTrvIndx);
        if FTrvIndx > 9 then
          FTrvIndx := 0;
      end;

    // Otherwise, raise an exception to report that the key wasn't found
    end else
      raise EHashAccessError.Create('That key does not exist');
      { (' + Key +
        ')');\}
  end else
    raise EHashAccessError.Create('That key does not exist');
    //' (' + Key + ')');

end;

//******************* _ACHASH_.ShiftLeft *************************
// The rebalancing procedure uses this to shift a branch structure
// left (meaning the left node from the top becomes the new top).
function _ACHASH_.ShiftLeft(Rec: P_ACHASH_RECORD_): P_ACHASH_RECORD_;
var
  OTop, OParent, NTop, CRec: P_ACHASH_RECORD_;
  DecRight: array of P_ACHASH_RECORD_;
  DeadEnd: Boolean;
  I, n: integer;

begin

  // Store pointer to old top node
  OTop := Rec;

  // Go left one node
  CRec := OTop^.Left;

  // Go right if possible
  if Assigned(CRec^.Right) then begin

    // Start walking right
    DeadEnd := False;
    OParent := CRec;
    while Not DeadEnd do
      if Assigned(CRec^.Right) then begin
        SetLength(DecRight, High(DecRight) + 2);
        DecRight[High(DecRight)] := CRec;
        OParent := CRec;
        CRec := CRec^.Right;
      end else
        DeadEnd := True;

    // CRec is now the new top node
    NTop := CRec;

    // Decrement all the branch weights above the old parent node
    for I := 0 to High(DecRight) do
      DecRight[I]^.RWeight := DecRight[I]^.RWeight - OParent^.RWeight;

    // Calculate the pruned branch size
    n := OTop^.LWeight - (NTop^.LWeight + 1);

    // Re-attach the broken branch from the left-hand side of the
    // old top node

    // Start walking left after updating NTop branch weight
    NTop^.LWeight := NTop^.LWeight + n;
    if Assigned(NTop^.Left) then begin
      CRec := NTop^.Left;
      DeadEnd := False;
      while Not DeadEnd do
        if Assigned(CRec^.Left) then begin
          CRec^.LWeight := CRec^.LWeight + n;
          CRec := CRec^.Left;
        end else
          DeadEnd := True;
    end else
      CRec := NTop;

    // Attach the branch
    CRec^.Left := OTop^.Left;
    CRec^.LWeight := n;

    // Update old parent
    OParent^.Right := nil;
    OParent^.RWeight := 0;

  // Can't go left, so CRec is our new top node
  end else
    NTop := CRec;

  // Final updates
  OTop^.Left := nil;
  OTop^.LWeight := 0;
  NTop^.Right := OTop;
  NTop^.RWeight := OTop^.RWeight + 1;

  Result := NTop;

end;

//******************* _ACHASH_.ShiftRight *************************
// The rebalancing procedure uses this to shift a branch structure
// right (meaning the right node from the top becomes the new top).
function _ACHASH_.ShiftRight(Rec: P_ACHASH_RECORD_): P_ACHASH_RECORD_;
var
  OTop, OParent, NTop, CRec: P_ACHASH_RECORD_;
  DecLeft: array of P_ACHASH_RECORD_;
  DeadEnd: Boolean;
  I, n: integer;

begin

  // Store pointer to old top node
  OTop := Rec;

  // Go right one node
  CRec := OTop^.Right;

  // Go left if possible
  if Assigned(CRec^.Left) then begin

    // Start walking left
    DeadEnd := False;
    OParent := CRec;
    while Not DeadEnd do
      if Assigned(CRec^.Left) then begin
        SetLength(DecLeft, High(DecLeft) + 2);
        DecLeft[High(DecLeft)] := CRec;
        OParent := CRec;
        CRec := CRec^.Left;
      end else
        DeadEnd := True;

    // CRec is now the new top node
    NTop := CRec;

    // Decrement all the branch weights above the old parent node
    for I := 0 to High(DecLeft) do
      DecLeft[I]^.LWeight := DecLeft[I]^.LWeight - OParent^.LWeight;

    // Calculate the pruned branch size
    n := OTop^.RWeight - (NTop^.RWeight + 1);

    // Re-attach the broken branch from the right-hand side of the
    // old top node

    // Start walking right after updating NTop branch weight
    NTop^.RWeight := NTop^.RWeight + n;
    if Assigned(NTop^.Right) then begin
      CRec := NTop^.Right;
      DeadEnd := False;
      while Not DeadEnd do
        if Assigned(CRec^.Right) then begin
          CRec^.RWeight := CRec^.RWeight + n;
          CRec := CRec^.Right;
        end else
          DeadEnd := True;
    end else
      CRec := NTop;

    // Attach the branch
    CRec^.Right := OTop^.Right;
    CRec^.RWeight := n;

    // Update old parent
    OParent^.Left := nil;
    OParent^.LWeight := 0;

  // Can't go left, so CRec is our new top node
  end else
    NTop := CRec;

  // Final updates
  OTop^.Right := nil;
  OTop^.RWeight := 0;
  NTop^.Left := OTop;
  NTop^.LWeight := OTop^.LWeight + 1;

  Result := NTop;

end;

function _ACHASH_.XRetrieve(Key: _ACHASH_KEY_): _ACHASH_VALUE_;
begin
  result := Retrieve(Key);
end;

procedure _ACHASH_.XAssignValue(Key: _ACHASH_KEY_; Value: _ACHASH_VALUE_);
begin
  AssignValue(Key, Value);
end;



(*$ENDIF define_implementation*)
