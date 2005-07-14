unit utimebasedinterfacecache;

(*
 * This unit contains a time based interface cache.
 * It stores interface variables and a MRU time.
 * From time to time it will be raided.
 *
 * key to use = UTF8String (you have to get it from somewhere around the interface, sorry)
 *)
 
interface

type
  DInterfaceCache = class
  private
    {[MRU, iface] order by mru}
    Fcleartimer..
  protected
    procedure CleanSome;
    function GetAInterface(key: UTF8String): IInterface;
    procedure SetAInterface(key: UTF8String; iface: IInterface);
  public
    property Items[key: UTF8String]: IInterface read GetAInterface write SetAInterface;
  end;

implementation

initialization
  (* Lock *)
  (* DInterfaceCache.TypeRegister; *)
  (* Unlock *)

end.
