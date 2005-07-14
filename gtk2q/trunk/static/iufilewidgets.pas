unit iufilewidgets;

interface
uses iugtk;

type
  IGtkFileChooserOpenWidget = interface(IGtkFileChooserWidget)
    ['{0352BEF4-2D67-41A0-A590-A2BA521A5A9E}']
  end;

  IGtkFileChooserSaveWidget = interface(IGtkFileChooserWidget)
    ['{432B2049-A2CC-471C-9861-24AEDC5F1794}']
  end;

  IGtkFileChooserSelectFolderWidget = interface(IGtkFileChooserWidget)
    ['{2A2EBBBE-6C94-4DCD-BCD6-F8490D55D0E8}']
  end;

  IGtkFileChooserCreateFolderWidget = interface(IGtkFileChooserWidget)
    ['{F51E6501-5BA6-4F50-8B8B-56A2A384E7C3}']
  end;
  
implementation


end.
