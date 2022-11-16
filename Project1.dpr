program Project1;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {Form1},
  EditUnit in 'EditUnit.pas' {Form3},
  GlobalUnit in 'GlobalUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
