program EasyZip;

{$R *.dres}

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {FormEasyZip};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormEasyZip, FormEasyZip);
  Application.Run;
end.
