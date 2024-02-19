# ResultPairBr Library for Delphi

ResultPairBr é uma library para tratamento de resultados em aplicações Delphi. Ele fornece uma abordagem elegante e segura para lidar com resultados de operações que podem ter sucesso ou falha, ele possui dois campos: um para armazenar o valor do resultado em caso de sucesso, e outro para armazenar o motivo da falha em caso de erro. Com o ResultPairBr, os desenvolvedores podem criar operações que retornam um TResultPair em vez de um valor simples. Isso permite que o código que chama a operação verifique se o resultado foi bem sucedido ou não, e trate cada caso de forma apropriada

<p align="center">
  <a href="https://www.isaquepinheiro.com.br">
    <img src="https://www.isaquepinheiro.com.br/projetos/resultpairbr-framework-for-delphi-opensource-15286.png" width="200" height="200">
  </a>
</p>

## 🏛 Delphi Versions
Embarcadero Delphi XE e superior.

## ⚙️ Instalação
Instalação usando o [`boss install`](https://github.com/HashLoad/boss) comando:
```sh
boss install "https://github.com/HashLoad/resultpairbr"
```

#@ :hammer: Recursos de para caputra o retorno duplo

:heavy_check_mark: `Recurso 1`: ```TResultPairBr<String, Exception>``` para (Definição do retorno duplo)

:heavy_check_mark: `Recurso 2`: ```TResultPairBr<String, Exception>.TryException<String>``` para (Captura do retorno duplo)

:heavy_check_mark: `Recurso 3`: ```TResultPairBr<String, Exception>.Map(MapValue).TryException<String>``` para (Operações antes do retono duplo)

## ⚡️ Como usar
#### Modelo 1 de uso

```Delphi
function TController.Failure: String;
var
  LResult: TResultPair;
  LMessage: String;
begin
  Result := '';

  LResult := FRepository.fetchProductsFailure;
  try
    if LResult.isSuccess() then
      LMessage := LResult.ValueSuccess
    else
    if LResult.isFailure() then
      LMessage := LResult.ValueFailure.Message;

    Result := LMessage;
  finally
    LResult.Free;
  end;
end;
```
#### Modelo 2 de uso

```Delphi
function TController.Success: String;
var
  LResult: TResultPair;
  LMessage: String;
begin
  Result := '';
  LResult := FRepository.fetchProductsSuccess;
  try
    LMessage := LResult.TryException<String>(
      function: String
      begin
        Result := LResult.ValueSuccess;
      end,
      function: String
      begin
        Result := LResult.ValueFailure.Message;
      end
    );
    Result := LMessage;
  finally
    LResult.Free;
  end;
end;
```
#### Modelo 3 de uso com Thread
```Delphi
procedure TController.FutureNoAwait;
var
  LResult: IFuture<TResultPair>;
  LMessage: String;
begin
  LMessage := '';

  TThread.CreateAnonymousThread(
  procedure
  begin
    LResult := TTask.Future<TResultPair>(FRepository.fetchProductsFuture);
    try
      LMessage := LResult.Value.Map(MapValue).TryException<String>(
        function: String
        begin
          Result := LResult.Value.ValueSuccess;
        end,
        function: String
        begin
          Result := LResult.Value.ValueFailure.Message;
        end
      );
      TThread.Queue(nil,
        procedure
        begin
          if Assigned(FThreadObserver) then
            FThreadObserver(LMessage);
        end);
    finally
      // Libera o tipo TResultPair que é criado internamente ao TTask
      LResult.Value.Free;
      // Libera o TTask.Future<>
      LResult := nil;
    end;
  end
  ).Start;
end;
```

## ✍️ License
[![License](https://img.shields.io/badge/Licence-LGPL--3.0-blue.svg)](https://opensource.org/licenses/LGPL-3.0)

## ⛏️ Contribuição

Nossa equipe adoraria receber contribuições para este projeto open source. Se você tiver alguma ideia ou correção de bug, sinta-se à vontade para abrir uma issue ou enviar uma pull request.

[![Issues](https://img.shields.io/badge/Issues-channel-orange)](https://github.com/HashLoad/ormbr/issues)

Para enviar uma pull request, siga estas etapas:

1. Faça um fork do projeto
2. Crie uma nova branch (`git checkout -b minha-nova-funcionalidade`)
3. Faça suas alterações e commit (`git commit -am 'Adicionando nova funcionalidade'`)
4. Faça push da branch (`git push origin minha-nova-funcionalidade`)
5. Abra uma pull request

## 📬 Contato
[![Telegram](https://img.shields.io/badge/Telegram-channel-blue)](https://t.me/hashload)

## 💲 Doação
[![Doação](https://img.shields.io/badge/PagSeguro-contribua-green)](https://pag.ae/bglQrWD)
