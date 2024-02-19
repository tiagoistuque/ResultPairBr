unit result.pair.value;

interface

uses
  SysUtils;

type
  TValueBr<T> = record
  private
    FValue: T;
    FHasValue: Boolean;
  public
    constructor Create(AValue: T);
    class function CreateNil: TValueBr<T>; static;
    function GetValue: T;
    function HasValue: Boolean;
  end;

implementation

constructor TValueBr<T>.Create(AValue: T);
begin
  FValue := AValue;
  FHasValue := True;
end;

class function TValueBr<T>.CreateNil: TValueBr<T>;
begin
  Result.FHasValue := False;
end;

function TValueBr<T>.GetValue: T;
begin
  if not FHasValue then
    raise Exception.Create('Value is nil.');
  Result := FValue;
end;

function TValueBr<T>.HasValue: Boolean;
begin
  Result := FHasValue;
end;

end.
