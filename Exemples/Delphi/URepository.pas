unit URepository;

interface

uses
  SysUtils,
  UService,
  result.pair;

type
  Success = String;
  Error = String;
  ResultPair = TResultPair<Success, Error>;

  TRepository = class
  private
    FService: TService;
  public
    constructor Create;
    destructor Destroy; override;

    function fetchProductsSuccess: ResultPair;
    function fetchProductsFailure: ResultPair;
    function fetchProductsFuture: ResultPair;
  end;

implementation

{ TRepository }

constructor TRepository.Create;
begin
  FService := TService.Create;
end;

destructor TRepository.Destroy;
begin
  FService.Free;
  inherited;
end;

function TRepository.fetchProductsFailure: ResultPair;
var
  LResult: String;
begin
  try
    LResult := FService.fetchProductsFailure;
    Result.Success('Success!');
  except
    Result.Failure('Failure!');
  end;
end;

function TRepository.fetchProductsFuture: ResultPair;
var
  LResult: String;
begin
  try
    LResult := FService.fetchProductsFuture;
    Result.Success('Success Future!');
  except
    Result.Failure('Failure Future!');
  end;
end;

function TRepository.fetchProductsSuccess: ResultPair;
var
  LResult: String;
begin
  try
    LResult := FService.fetchProductsSuccess;
  except
    Result.Failure('Failure!');
  end;
end;

end.
