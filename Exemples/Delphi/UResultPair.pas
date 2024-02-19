unit UResultPair;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Threading,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,

  UController;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
    FController: TController;
    procedure ThreadObserver(AValue: String);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  Memo1.Lines.Add('Example Success');
  Memo1.Lines.Add(FController.Success);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Memo1.Lines.Add('Example Failure');
  Memo1.Lines.Add(FController.Failure);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Memo1.Lines.Add('Example Future (await)');
  Memo1.Lines.Add(FController.FutureAwait);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  Memo1.Lines.Add('Example Future (no await)');
  FController.FutureNoAwait;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  Memo1.Clear;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  FController.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Memo1.Clear;
  FController := TController.Create;
  FController.OnThreadObserver := ThreadObserver;
end;

procedure TForm1.ThreadObserver(AValue: String);
begin
  Memo1.Lines.Add(AValue);
end;

initialization
  ReportMemoryLeaksOnShutdown := True;

end.
