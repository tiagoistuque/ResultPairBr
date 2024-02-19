unit UController;

interface

uses
  Classes,
  SysUtils,
  Threading,

  URepository,
  result.pair;

type
  TThreadObserver = procedure(AValue: String) of object;

  TController = class
  private
    FRepository: TRepository;
    FThreadObserver: TThreadObserver;
    function MapValue(AValue: String): String;
  public
    constructor Create;
    destructor Destroy; override;
    function Success: String;
    function Failure: String;
    function FutureAwait: String;
    procedure FutureNoAwait;

    property OnThreadObserver: TThreadObserver read FThreadObserver
                                               write FThreadObserver;
  end;

implementation

{ TController }

constructor TController.Create;
begin
  FRepository := TRepository.Create;
end;

destructor TController.Destroy;
begin
  FRepository.Free;
  inherited;
end;

function TController.Failure: String;
var
  LResult: ResultPair;
  LMessage: String;
begin
  Result := '';

  LResult := FRepository.fetchProductsFailure;
  if LResult.isSuccess() then
    LMessage := LResult.ValueSuccess
  else
  if LResult.isFailure() then
  begin
    LMessage := LResult.ValueFailure;
    LResult.DestroyFailure;
    raise Exception.Create(LMessage);
  end;
  Result := LMessage;
end;

function TController.FutureAwait: String;
var
  LResult: IFuture<ResultPair>;
  LMessage: String;
begin
  Result := '';
  LMessage := '';

  LResult := TTask.Future<ResultPair>(FRepository.fetchProductsFuture);
  try
    LResult.Value.TryException(
      procedure
      begin
        LMessage := LResult.Value.ValueSuccess;
      end,
      procedure
      begin
        LMessage := LResult.Value.ValueFailure;
      end
    );
  finally
    // Libera o TTask.Future<>
    LResult := nil;
  end;
  Result := LMessage;
end;

procedure TController.FutureNoAwait;
var
  LResult: IFuture<ResultPair>;
  LMessage: String;
begin
  LMessage := '';

  TThread.CreateAnonymousThread(
  procedure
  begin
    LResult := TTask.Future<ResultPair>(FRepository.fetchProductsFuture);
    try
      LMessage := LResult.Value.Map(MapValue, nil).TryException<String>(
        function(const Value: ResultPair): String
        begin
          Result := Value.ValueSuccess;
        end,
        function(const Value: ResultPair): String
        begin
          Result := Value.ValueFailure;
        end
      );
      TThread.Queue(nil,
        procedure
        begin
          if Assigned(FThreadObserver) then
            FThreadObserver(LMessage);
        end);
    finally
      // Libera o TTask.Future<>
      LResult := nil;
    end;
  end
  ).Start;
end;

function TController.MapValue(AValue: String): String;
begin
  Result := Format('Map() - %s', [AValue]);
end;

function TController.Success: String;
var
  LResult: ResultPair;
  LMessage: String;
begin
  Result := '';
  LResult := FRepository.fetchProductsSuccess;
  LMessage := LResult.TryException<String>(
    function(const Value: ResultPair): String
    begin
      Result := Value.ValueSuccess;
    end,
    function(const Value: ResultPair): String
    begin
      Result := Value.ValueFailure;
    end
  );
  Result := LMessage;
end;

end.
