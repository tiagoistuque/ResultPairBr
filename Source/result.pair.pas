{
           ResultPair - Result Multiple for Delphi

                   Copyright (c) 2023, Isaque Pinheiro
                          All rights reserved.
                    GNU Lesser General Public License
                      Versão 3, 29 de junho de 2007
       Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
       A todos é permitido copiar e distribuir cópias deste documento de
       licença, mas mudá-lo não é permitido.
       Esta versão da GNU Lesser General Public License incorpora
       os termos e condições da versão 3 da GNU General Public License
       Licença, complementado pelas permissões adicionais listadas no
       arquivo LICENSE na pasta principal.
}
{
  @abstract(ResultPair)
  @created(28 Mar 2023)
  @author(Isaque Pinheiro <isaquesp@gmail.com>)
  @author(Site : https://www.isaquepinheiro.com.br)
}
unit result.pair;

interface

uses
  Rtti,
  TypInfo,
  Classes,
  SysUtils,
  result.pair.value;

type
  TResultType = (rtSuccess, rtFailure);

  TResultPair<F, S> = record
  private
    FResultType: TResultType;
    FSuccess: TValueBr<S>;
    FFailure: TValueBr<F>;
    type
      TMapFunc<Return> = reference to function(const ASelf: TResultPair<F, S>): Return;
  public
    procedure DestroySuccess;
    procedure DestroyFailure;
    //
    function Success(const ASuccess: S): TResultPair<F, S>;
    function Failure(const AFailure: F): TResultPair<F, S>;
    function TryException(const AFailureProc: TProc<F>;
      const ASuccessProc: TProc<S>): TResultPair<F, S>;
    //
    function Fold<R>(const AFailureFunc: TFunc<F, R>;
      const ASuccessFunc: TFunc<S, R>): R;
    function When<R>(const ASuccessFunc: TFunc<S, R>;
      const AFailureFunc: TFunc<F, R>): R;
    //
    function Map<R>(const ASuccessFunc: TFunc<S, R>): TResultPair<F, R>;
    function MapFailure<R>(const AFailureFunc: TFunc<F, R>): TResultPair<R, S>;
    //
    function flatMap<R>(const ASuccessFunc: TFunc<S, R>): TResultPair<F, R>;
    function flatMapFailure<R>(const AFailureFunc: TFunc<F, R>): TResultPair<R, S>;
    //
    function Pure(const ASuccess: S): TResultPair<F, S>;
    function PureFailure(const AFailure: F): TResultPair<F, S>;
    //
    function Swap: TResultPair<F, S>;
    function Recover<N>(const AFailureFunc: TFunc<F, N>): TResultPair<N, S>;
    //
    function GetSuccessOrElse(const ASuccessFunc: TFunc<S, S>): S;
    function GetSuccessOrException: S;
    function GetSuccessOrDefault: S; overload;
    function GetSuccessOrDefault(const ADefault: S): S; overload;
    //
    function GetFailureOrElse(const AFailureFunc: TFunc<F, F>): F;
    function GetFailureOrException: F;
    function GetFailureOrDefault: F; overload;
    function GetFailureOrDefault(const ADefault: F): F; overload;
    //
    function isSuccess: boolean;
    function isFailure: boolean;
    //
    function ValueSuccess: S;
    function ValueFailure: F;
    //
    class operator Equal(const Left, Right: TResultPair<F, S>): Boolean;
    class operator NotEqual(const Left, Right: TResultPair<F, S>): Boolean;
  end;

implementation

uses
  result.pair.exception;

{ TResultPairBr<F, S> }

procedure TResultPair<F, S>.DestroySuccess;
var
  LTypeInfo: PTypeInfo;
  LObject: TValue;
begin
  LTypeInfo := TypeInfo(S);
  if LTypeInfo.Kind = tkClass then
  begin
    LObject := TValue.From<S>(FSuccess.GetValue);
    LObject.AsObject.Free;
  end;
end;

procedure TResultPair<F, S>.DestroyFailure;
var
  LTypeInfo: PTypeInfo;
  LObject: TValue;
begin
  LTypeInfo := TypeInfo(F);
  if LTypeInfo.Kind = tkClass then
  begin
    LObject := TValue.From<F>(FFailure.GetValue);
    LObject.AsObject.Free;
  end;
end;

function TResultPair<F, S>.Failure(const AFailure: F): TResultPair<F, S>;
begin
  FFailure := TValueBr<F>.Create(AFailure);
  FResultType := TResultType.rtFailure;
  Result := Self;
end;

function TResultPair<F, S>.Success(const ASuccess: S): TResultPair<F, S>;
begin
  FSuccess := TValueBr<S>.Create(ASuccess);
  FResultType := TResultType.rtSuccess;
  Result := Self;
end;

function TResultPair<F, S>.Fold<R>(const AFailureFunc: TFunc<F, R>;
  const ASuccessFunc: TFunc<S, R>): R;
begin
  case FResultType of
    TResultType.rtSuccess:
    begin
      if not Assigned(ASuccessFunc) then
        raise Exception.Create('Success function not assigned');
      Result := ASuccessFunc(FSuccess.GetValue);
    end;
    TResultType.rtFailure:
    begin
      if not Assigned(AFailureFunc) then
        raise Exception.Create('Failure function not assigned');
      Result := AFailureFunc(FFailure.GetValue)
    end;
  end;
end;

function TResultPair<F, S>.isFailure: boolean;
begin
  result := FResultType = TResultType.rtFailure;
end;

function TResultPair<F, S>.isSuccess: boolean;
begin
  result := FResultType = TResultType.rtSuccess;
end;

function TResultPair<F, S>.Map<R>(
  const ASuccessFunc: TFunc<S, R>): TResultPair<F, R>;
begin
  case FResultType of
    TResultType.rtSuccess:
    begin
      if not Assigned(ASuccessFunc) then
        raise Exception.Create('Success map function not assigned');
      Result.Success(ASuccessFunc(FSuccess.GetValue))
    end;
    TResultType.rtFailure: Result.Failure(FFailure.GetValue);
  end;
end;

function TResultPair<F, S>.TryException(const AFailureProc: TProc<F>;
  const ASuccessProc: TProc<S>): TResultPair<F, S>;
begin
  case FResultType of
    TResultType.rtSuccess:
      begin
        if not Assigned(ASuccessProc) then
          raise Exception.Create('Success map procedure not assigned');
        ASuccessProc(FSuccess.GetValue);
      end;
    TResultType.rtFailure:
      begin
        if not Assigned(AFailureProc) then
          raise Exception.Create('Failure map procedure not assigned');
        AFailureProc(FFailure.GetValue);
      end;
  end;
  Result := Self;
end;

function TResultPair<F, S>.GetSuccessOrException: S;
begin
  if FResultType = TResultType.rtFailure then
    raise EFailureException<F>.Create(FFailure.GetValue);
  Result := FSuccess.GetValue;
end;

function TResultPair<F, S>.ValueFailure: F;
begin
  result := FFailure.GetValue;
end;

function TResultPair<F, S>.ValueSuccess: S;
begin
  result := FSuccess.GetValue;
end;

function TResultPair<F, S>.When<R>(const ASuccessFunc: TFunc<S, R>;
  const AFailureFunc: TFunc<F, R>): R;
begin
  case FResultType of
    TResultType.rtSuccess: Result := ASuccessFunc(FSuccess.GetValue);
    TResultType.rtFailure: Result := AFailureFunc(FFailure.GetValue);
  end;
end;

function TResultPair<F, S>.MapFailure<R>(
  const AFailureFunc: TFunc<F, R>): TResultPair<R, S>;
begin
  case FResultType of
    TResultType.rtSuccess: Result.Success(FSuccess.GetValue);
    TResultType.rtFailure:
    begin
      if not Assigned(AFailureFunc) then
        raise Exception.Create('Failure map function not assigned');
      Result.Failure(AFailureFunc(FFailure.GetValue))
    end;
  end;
end;

class operator TResultPair<F, S>.NotEqual(const Left,
  Right: TResultPair<F, S>): Boolean;
begin
  Result := not (Left = Right);
end;

function TResultPair<F, S>.flatMap<R>(
  const ASuccessFunc: TFunc<S, R>): TResultPair<F, R>;
var
  LResult: TResultPair<F, R>;
begin
  case FResultType of
    TResultType.rtSuccess: LResult.Success(ASuccessFunc(FSuccess.GetValue));
    TResultType.rtFailure: LResult.Failure(FFailure.GetValue);
  end;
  Result := LResult;
end;

function TResultPair<F, S>.flatMapFailure<R>(
  const AFailureFunc: TFunc<F, R>): TResultPair<R, S>;
var
  LResult: TResultPair<R, S>;
begin
  case FResultType of
    TResultType.rtSuccess: LResult.Success(FSuccess.GetValue);
    TResultType.rtFailure: LResult.Failure(AFailureFunc(FFailure.GetValue));
  end;
  Result := LResult;
end;

function TResultPair<F, S>.Pure(const ASuccess: S): TResultPair<F, S>;
begin
  Result.Success(ASuccess);
end;

function TResultPair<F, S>.PureFailure(const AFailure: F): TResultPair<F, S>;
begin
  Result.Failure(AFailure);
end;

function TResultPair<F, S>.GetSuccessOrElse(const ASuccessFunc: TFunc<S, S>): S;
begin
  case FResultType of
    TResultType.rtSuccess: Result := FSuccess.GetValue;
    TResultType.rtFailure: Result := ASuccessFunc(FSuccess.GetValue);
  end;
end;

function TResultPair<F, S>.GetSuccessOrDefault(const ADefault: S): S;
begin
  case FResultType of
    TResultType.rtSuccess: Result := FSuccess.GetValue;
    TResultType.rtFailure: Result := ADefault;
  end;
end;

function TResultPair<F, S>.GetSuccessOrDefault: S;
begin
  case FResultType of
    TResultType.rtSuccess: Result := FSuccess.GetValue;
    TResultType.rtFailure: Result := Default(S);
  end;
end;

class operator TResultPair<F, S>.Equal(const Left,
  Right: TResultPair<F, S>): Boolean;
begin
  Result := (Left = Right);
end;

function TResultPair<F, S>.GetFailureOrDefault: F;
begin
  case FResultType of
    TResultType.rtSuccess: Result := Default(F);
    TResultType.rtFailure: Result := FFailure.GetValue;
  end;
end;

function TResultPair<F, S>.GetFailureOrDefault(const ADefault: F): F;
begin
  case FResultType of
    TResultType.rtSuccess: Result := ADefault;
    TResultType.rtFailure: Result := FFailure.GetValue;
  end;
end;

function TResultPair<F, S>.GetFailureOrElse(const AFailureFunc: TFunc<F, F>): F;
begin
  case FResultType of
    TResultType.rtSuccess: Result := AFailureFunc(FFailure.GetValue);
    TResultType.rtFailure: Result := FFailure.GetValue;
  end;
end;

function TResultPair<F, S>.GetFailureOrException: F;
begin
  if FResultType = TResultType.rtSuccess then
    raise ESuccessException<F>.Create(FFailure.GetValue);
  Result := FFailure.GetValue;
end;

function TResultPair<F, S>.Swap: TResultPair<F, S>;
var
  LResult: TResultPair<F, S>;
begin
  try
    case FResultType of
      TResultType.rtSuccess: LResult.FSuccess := TValueBr<S>(TValueBr<F>.Create(FFailure.GetValue));
      TResultType.rtFailure: LResult.FFailure := TValueBr<F>(TValueBr<S>.Create(FSuccess.GetValue));
    end;
    Result := LResult;
  except
    on E: Exception do
      raise ETypeIncompatibility.Create('[Failure/Success]');
  end;
end;

function TResultPair<F, S>.Recover<N>(const AFailureFunc: TFunc<F, N>): TResultPair<N, S>;
var
  LResult: TResultPair<N, S>;
begin
  case FResultType of
    TResultType.rtSuccess: LResult.Success(FSuccess.GetValue);
    TResultType.rtFailure: LResult.Failure(AFailureFunc(FFailure.GetValue));
  end;
  Result := LResult;
end;

end.
