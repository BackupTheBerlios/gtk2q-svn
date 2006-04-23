unit ugsttypes;

interface
uses ugtypes;

type
  TGstIndexEntryType = (ietId, ietAssociation, ietObject, ietFormat);
  TGstFormat = (
    fmtUndefined = 0, (* must be first in list *)
    fmtDefault = 1, (* samples for audio, frames/fields for video *)
    fmtBytes = 2,
    fmtTime = 3,
    fmtBuffers = 4,
    fmtPercent = 5
  );
  
  TGstPadDirection = (
    pdUnknown,
    pdSrc,
    pdSink
  );
  
  TGstQueueLeaky = (
    qlNoLeak,
    qlLeakUpstream,
    qlLeakDownstream
  );

  TGstFlowReturn = (
     frResend = 1,
     frOk = 0,
     (* expected failures *)
     frNotLinked = -1,
     frWrongState = -2,
     (* error cases *)
     frFlowUnexpected = -3,
     frFlowNotNegotiated = -4,
     frFlowError = -5,
     frFlowNotSupported = -6
  );

  EGstFlowError = class(Exception)
  private
    fCode: TGstFlowReturn;
  public
    constructor Create(code: TGstFlowReturn);
  published
    property Code: TGstFlowReturn read fCode write fCode;
  end;
  
implementation

constructor EGstFlowError.Create(ACode: TGstFlowReturn);
var
  AMessage: string;
begin
  case ACode of
    frResend: AMessage := 'Resend buffer, possibly with new caps.';
    //frOk: AMessage := 'Data passing was ok.';
    frNotLinked: AMessage := 'Pad is not linked.';
    frWrongState: AMessage := 'Pad is in wrong state.';
    frUnexpected: AMessage := 'Did not expect anything, like after EOS.';
    frNotNegotiated: AMessage := 'Pad is not negotiated.';
    frError: AMessage := 'Some (fatal) error occured.';
    frNotSupported: AMessage := 'This operation is not supported.';
    else AMessage := Format('Unknown error %d', [Integer(ACode)]);
  end;
  inherited Create(AMessage);
  fCode := code;
end;

end.
