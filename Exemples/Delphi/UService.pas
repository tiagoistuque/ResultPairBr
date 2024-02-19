unit UService;

interface

uses
  SysUtils;

type
  TService = class
  public
    function fetchProductsSuccess: String;
    function fetchProductsFailure: String;
    function fetchProductsFuture: String;
  end;

implementation

{ TService }

function TService.fetchProductsFailure: String;
var
  LNumero: Double;
begin
  // Forçando erro só para testar.
  LNumero := 150;
  if ((LNumero < 0) or (LNumero > 100)) then
    raise Exception.Create('');

  Result := 'Result';
end;

function TService.fetchProductsFuture: String;
begin
  Sleep(5000);
  Result := 'Result';
end;

function TService.fetchProductsSuccess: String;
begin
  Result := 'Result';
end;

end.
