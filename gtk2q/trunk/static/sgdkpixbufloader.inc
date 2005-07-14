(*$IFDEF define_consts*)
(*$ENDIF define_consts*)
(*$IFDEF define_types*)
   THandlerTGdkPixbufLoaderTAreaPrepared = procedure(Sender: DGObject) of object;
   TGdkPixbufLoaderTAreaPreparedSignal = class(DCustomSignal)
   public
     function Add(cb: THandlerTGdkPixbufLoaderTAreaPrepared): TSignalHandlerID;
     procedure Remove(cb: THandlerTGdkPixbufLoaderTAreaPrepared);
     procedure Block(cb: THandlerTGdkPixbufLoaderTAreaPrepared);
     procedure Unblock(cb: THandlerTGdkPixbufLoaderTAreaPrepared);
     function IsConnected(cb: THandlerTGdkPixbufLoaderTAreaPrepared): Boolean;
   end;
   //TLowTHandlerTGdkPixbufLoaderTAreaPrepared = procedure(xx); cdecl;

   THandlerTGdkPixbufLoaderTAreaUpdated = procedure(Sender: DGObject; x,y,width,height: Integer) of object;
   TGdkPixbufLoaderTAreaUpdatedSignal = class(DCustomSignal)
   public
     function Add(cb: THandlerTGdkPixbufLoaderTAreaUpdated): TSignalHandlerID;
     procedure Remove(cb: THandlerTGdkPixbufLoaderTAreaUpdated);
     procedure Block(cb: THandlerTGdkPixbufLoaderTAreaUpdated);
     procedure Unblock(cb: THandlerTGdkPixbufLoaderTAreaUpdated);
     function IsConnected(cb: THandlerTGdkPixbufLoaderTAreaUpdated): Boolean;
   end;
   //TLowTHandlerTGdkPixbufLoaderTAreaUpdated = procedure(xx); cdecl;

   THandlerTGdkPixbufLoaderTClosed = procedure(Sender: DGObject) of object;
   TGdkPixbufLoaderTClosedSignal = class(DCustomSignal)
   public
     function Add(cb: THandlerTGdkPixbufLoaderTClosed): TSignalHandlerID;
     procedure Remove(cb: THandlerTGdkPixbufLoaderTClosed);
     procedure Block(cb: THandlerTGdkPixbufLoaderTClosed);
     procedure Unblock(cb: THandlerTGdkPixbufLoaderTClosed);
     function IsConnected(cb: THandlerTGdkPixbufLoaderTClosed): Boolean;
   end;
   //TLowTHandlerTGdkPixbufLoaderTClosed = procedure(xx); cdecl;

   THandlerTGdkPixbufLoaderTSizePrepared = procedure(Sender: DGObject; width, height: Integer) of object;
   TGdkPixbufLoaderTSizePreparedSignal = class(DCustomSignal)
   public
     function Add(cb: THandlerTGdkPixbufLoaderTSizePrepared): TSignalHandlerID;
     procedure Remove(cb: THandlerTGdkPixbufLoaderTSizePrepared);
     procedure Block(cb: THandlerTGdkPixbufLoaderTSizePrepared);
     procedure Unblock(cb: THandlerTGdkPixbufLoaderTSizePrepared);
     function IsConnected(cb: THandlerTGdkPixbufLoaderTSizePrepared): Boolean;
   end;
   //TLowTHandlerTGdkPixbufLoaderTSizePrepared = procedure(xx); cdecl;

(*$ENDIF define_types*)
(*$IFDEF define_implementation*)

{ TGdkPixbufLoaderTAreaPreparedSignal }

function TGdkPixbufLoaderTAreaPreparedSignal.Add(cb: THandlerTGdkPixbufLoaderTAreaPrepared): TSignalHandlerID;
begin
(*$IFDEF FPC*)
  Result := inherited Add(THighCallback(@cb));
(*$ELSE*)
  Result := inherited Add(THighCallback(cb));
(*$ENDIF FPC*)
end;

procedure TGdkPixbufLoaderTAreaPreparedSignal.Remove(cb: THandlerTGdkPixbufLoaderTAreaPrepared);
begin
(*$IFDEF FPC*)
  inherited Remove(THighCallback(@cb));
(*$ELSE*)
  inherited Remove(THighCallback(cb));
(*$ENDIF FPC*)
end;

procedure TGdkPixbufLoaderTAreaPreparedSignal.Block(cb: THandlerTGdkPixbufLoaderTAreaPrepared);
begin
(*$IFDEF FPC*)
  inherited Block(THighCallback(@cb));
(*$ELSE*)
  inherited Block(THighCallback(cb));
(*$ENDIF FPC*)
end;

procedure TGdkPixbufLoaderTAreaPreparedSignal.Unblock(cb: THandlerTGdkPixbufLoaderTAreaPrepared);
begin
(*$IFDEF FPC*)
  inherited Unblock(THighCallback(@cb));
(*$ELSE*)
  inherited Unblock(THighCallback(cb));
(*$ENDIF FPC*)
end;

function TGdkPixbufLoaderTAreaPreparedSignal.IsConnected(cb: THandlerTGdkPixbufLoaderTAreaPrepared): Boolean;
begin
(*$IFDEF FPC*)
  Result := inherited IsConnected(THighCallback(@cb));
(*$ELSE*)
  Result := inherited IsConnected(THighCallback(cb));
(*$ENDIF FPC*)
end;


{ TGdkPixbufLoaderTAreaUpdatedSignal }

function TGdkPixbufLoaderTAreaUpdatedSignal.Add(cb: THandlerTGdkPixbufLoaderTAreaUpdated): TSignalHandlerID;
begin
(*$IFDEF FPC*)
  Result := inherited Add(THighCallback(@cb));
(*$ELSE*)
  Result := inherited Add(THighCallback(cb));
(*$ENDIF FPC*)
end;

procedure TGdkPixbufLoaderTAreaUpdatedSignal.Remove(cb: THandlerTGdkPixbufLoaderTAreaUpdated);
begin
(*$IFDEF FPC*)
  inherited Remove(THighCallback(@cb));
(*$ELSE*)
  inherited Remove(THighCallback(cb));
(*$ENDIF FPC*)
end;

procedure TGdkPixbufLoaderTAreaUpdatedSignal.Block(cb: THandlerTGdkPixbufLoaderTAreaUpdated);
begin
(*$IFDEF FPC*)
  inherited Block(THighCallback(@cb));
(*$ELSE*)
  inherited Block(THighCallback(cb));
(*$ENDIF FPC*)
end;

procedure TGdkPixbufLoaderTAreaUpdatedSignal.Unblock(cb: THandlerTGdkPixbufLoaderTAreaUpdated);
begin
(*$IFDEF FPC*)
  inherited Unblock(THighCallback(@cb));
(*$ELSE*)
  inherited Unblock(THighCallback(cb));
(*$ENDIF FPC*)
end;

function TGdkPixbufLoaderTAreaUpdatedSignal.IsConnected(cb: THandlerTGdkPixbufLoaderTAreaUpdated): Boolean;
begin
(*$IFDEF FPC*)
  Result := inherited IsConnected(THighCallback(@cb));
(*$ELSE*)
  Result := inherited IsConnected(THighCallback(cb));
(*$ENDIF FPC*)
end;

{ TGdkPixbufLoaderTClosedSignal }

function TGdkPixbufLoaderTClosedSignal.Add(cb: THandlerTGdkPixbufLoaderTClosed): TSignalHandlerID;
begin
(*$IFDEF FPC*)
  Result := inherited Add(THighCallback(@cb));
(*$ELSE*)
  Result := inherited Add(THighCallback(cb));
(*$ENDIF FPC*)
end;

procedure TGdkPixbufLoaderTClosedSignal.Remove(cb: THandlerTGdkPixbufLoaderTClosed);
begin
(*$IFDEF FPC*)
  inherited Remove(THighCallback(@cb));
(*$ELSE*)
  inherited Remove(THighCallback(cb));
(*$ENDIF FPC*)
end;

procedure TGdkPixbufLoaderTClosedSignal.Block(cb: THandlerTGdkPixbufLoaderTClosed);
begin
(*$IFDEF FPC*)
  inherited Block(THighCallback(@cb));
(*$ELSE*)
  inherited Block(THighCallback(cb));
(*$ENDIF FPC*)
end;

procedure TGdkPixbufLoaderTClosedSignal.Unblock(cb: THandlerTGdkPixbufLoaderTClosed);
begin
(*$IFDEF FPC*)
  inherited Unblock(THighCallback(@cb));
(*$ELSE*)
  inherited Unblock(THighCallback(cb));
(*$ENDIF FPC*)
end;

function TGdkPixbufLoaderTClosedSignal.IsConnected(cb: THandlerTGdkPixbufLoaderTClosed): Boolean;
begin
(*$IFDEF FPC*)
  Result := inherited IsConnected(THighCallback(@cb));
(*$ELSE*)
  Result := inherited IsConnected(THighCallback(cb));
(*$ENDIF FPC*)
end;


{ TGdkPixbufLoaderTSizePreparedSignal }

function TGdkPixbufLoaderTSizePreparedSignal.Add(cb: THandlerTGdkPixbufLoaderTSizePrepared): TSignalHandlerID;
begin
(*$IFDEF FPC*)
  Result := inherited Add(THighCallback(@cb));
(*$ELSE*)
  Result := inherited Add(THighCallback(cb));
(*$ENDIF FPC*)
end;

procedure TGdkPixbufLoaderTSizePreparedSignal.Remove(cb: THandlerTGdkPixbufLoaderTSizePrepared);
begin
(*$IFDEF FPC*)
  inherited Remove(THighCallback(@cb));
(*$ELSE*)
  inherited Remove(THighCallback(cb));
(*$ENDIF FPC*)
end;

procedure TGdkPixbufLoaderTSizePreparedSignal.Block(cb: THandlerTGdkPixbufLoaderTSizePrepared);
begin
(*$IFDEF FPC*)
  inherited Block(THighCallback(@cb));
(*$ELSE*)
  inherited Block(THighCallback(cb));
(*$ENDIF FPC*)
end;

procedure TGdkPixbufLoaderTSizePreparedSignal.Unblock(cb: THandlerTGdkPixbufLoaderTSizePrepared);
begin
(*$IFDEF FPC*)
  inherited Unblock(THighCallback(@cb));
(*$ELSE*)
  inherited Unblock(THighCallback(cb));
(*$ENDIF FPC*)
end;

function TGdkPixbufLoaderTSizePreparedSignal.IsConnected(cb: THandlerTGdkPixbufLoaderTSizePrepared): Boolean;
begin
(*$IFDEF FPC*)
  Result := inherited IsConnected(THighCallback(@cb));
(*$ELSE*)
  Result := inherited IsConnected(THighCallback(cb));
(*$ENDIF FPC*)
end;




(*$ENDIF define_implementation*)
