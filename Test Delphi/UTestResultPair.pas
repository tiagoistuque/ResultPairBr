unit UTestResultPair;

interface
uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TTestResultPair = class(TObject) 
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  end;

implementation

procedure TTestResultPair.Setup;
begin
end;

procedure TTestResultPair.TearDown;
begin
end;


initialization
  TDUnitX.RegisterTestFixture(TTestResultPair);
end.
