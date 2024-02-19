program PResultPair;

uses
  Vcl.Forms,
  UResultPair in 'UResultPair.pas' {Form1},
  UController in 'UController.pas',
  URepository in 'URepository.pas',
  UService in 'UService.pas',
  result.pair in '..\..\Source\result.pair.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
