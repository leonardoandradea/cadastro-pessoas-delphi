object DM: TDM
  OnCreate = DataModuleCreate
  Height = 240
  Width = 320
  PixelsPerInch = 96
  object FDConnection: TFDConnection
    LoginPrompt = False
    Left = 64
    Top = 32
  end
  object FDPhysSQLiteDriverLink: TFDPhysSQLiteDriverLink
    Left = 64
    Top = 96
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 64
    Top = 160
  end
end
