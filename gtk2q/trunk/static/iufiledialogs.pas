unit iufiledialogs;

interface
uses iugtk;

type
  IGtkFileChooserOpenDialog = interface(IGtkFileChooserDialog)
    ['{E66A20E2-C9E6-42D8-8409-95223557D779}']
  end;

  IGtkFileChooserSaveDialog = interface(IGtkFileChooserDialog)
    ['{4D9629FE-6A0C-40CC-926F-FDBCDF14C7F3}']
  end;

  IGtkFileChooserSelectFolderDialog = interface(IGtkFileChooserDialog)
    ['{39ADF908-019A-4D57-9BC2-DFF44D9A396C}']
  end;
  
  IGtkFileChooserCreateFolderDialog = interface(IGtkFileChooserDialog)
    ['{912F61AD-DE11-42DA-B4E8-812AFC32DB5F}']
  end;

implementation


end.
