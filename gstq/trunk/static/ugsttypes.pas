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
  
implementation

end.
