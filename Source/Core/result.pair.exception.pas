unit result.pair.exception;

interface

uses
  Rtti,
  SysUtils;

type
  EFailureException<F> = class(Exception)
  public
    constructor Create(const Value: F);
  end;

  ESuccessException<S> = class(Exception)
  public
    constructor Create(const Value: S);
  end;

  ETypeIncompatibility = class(Exception)
  public
    constructor Create(const AMessage: string = '');
  end;

implementation

{ EFailureException<S> }

constructor EFailureException<F>.Create(const Value: F);
begin
  inherited CreateFmt('A generic exception occurred with value %s', [TValue.From<F>(Value).AsString]);
end;

{ ESuccessException<S> }

constructor ESuccessException<S>.Create(const Value: S);
begin
  inherited CreateFmt('A generic exception occurred with value %s', [TValue.From<S>(Value).AsString]);
end;

{ ETypeIncompatibility }

constructor ETypeIncompatibility.Create(const AMessage: string);
begin
  inherited CreateFmt('Type incompatibility: %s', [AMessage]);
end;

end.
