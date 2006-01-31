unit uexotypes;

interface
uses upangotypes;

const
  // enumish, but string and extensible...
  CategoryTerminalEmulator = 'TerminalEmulator';
  CategoryWebBrowser = 'WebBrowser';
  CategoryMailClient = 'MailClient'

  // /usr/local/libexec/exo-helper-0.3 --launch <category>

type
  TExoIconViewDropPosition = (ivNoDrop, ivDropInto, ivDropLeft, ivDropRight, ivDropAbove, ivDropBelow);
  // TExoPangoEllipsizeMode = (peNone, peStart, peMiddle, peEnd); == TPangoEllipsizeMode
  TExoToolbarsModelFlag = (tmNotRemovable, tmAcceptItemsOnly, tmOverrideStyle);
  TExoToolbarsModelFlags = set of TExoToolbarsModelFlag;

implementation

end.
