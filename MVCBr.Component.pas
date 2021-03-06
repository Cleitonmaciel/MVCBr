{ //************************************************************// }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //                                                            // }
{ //************************************************************// }
{ // Data: 15/02/2017 23:07:44                                  // }
{ //************************************************************// }

/// Implementa interface IModel para TComponent a ser herdado em
/// Componentes que possom ser registrado para o Delphi
unit MVCBr.Component;

interface

uses MVCBr.Interf, MVCBr.Model, MVCBr.ApplicationController, System.Classes, System.SysUtils;

type

  /// <summary>
  /// TComponentFactory Implementa IModel
  /// </Summary>
  TComponentFactory = class(TComponent, IModel)
  private
    FAdapter: IModel;
  protected
    procedure AfterConstruction; override;
  public
    function This: TObject;virtual;
    function GetID: string;virtual;
    function ID(const AID: String): IModel;
    function Update: IModel;virtual;
    function Controller(const AController: IController): IModel;virtual;
    function GetModelTypes: TModelTypes;virtual;
    function GetController: IController;virtual;
    function ResolveController(const AGuidController: TGuid): IController;virtual;
    procedure SetModelTypes(const AModelType: TModelTypes);virtual;
    property ModelTypes: TModelTypes read GetModelTypes write SetModelTypes;
    procedure AfterInit;virtual;

  end;

implementation

{ TComponentFactory }

procedure TComponentFactory.AfterConstruction;
begin
  inherited;
  FAdapter := TModelFactory.create;
  FAdapter.ID(Self.ClassName + '.' + Self.name);
end;

procedure TComponentFactory.AfterInit;
begin
  FAdapter.AfterInit;
end;

function TComponentFactory.Controller(const AController: IController): IModel;
begin
  result := FAdapter.Controller(AController);
end;

function TComponentFactory.GetController: IController;
var vw:IView;
begin
  result := FAdapter.GetController;
  if not assigned(result) then
     if assigned(Owner) then
       if supports(owner,IView,vw) then
          result := vw.GetController;

end;

function TComponentFactory.GetID: string;
begin
  result := FAdapter.GetID;
end;

function TComponentFactory.GetModelTypes: TModelTypes;
begin
  result := FAdapter.ModelTypes;
end;

function TComponentFactory.ID(const AID: String): IModel;
begin
  result := FAdapter.ID(AID);
end;

function TComponentFactory.ResolveController(
  const AGuidController: TGuid): IController;
begin
   result := GetController.ResolveController(AGuidController);
end;

procedure TComponentFactory.SetModelTypes(const AModelType: TModelTypes);
begin
  FAdapter.ModelTypes := AModelType;
end;

function TComponentFactory.This: TObject;
begin
  result := Self;
end;

function TComponentFactory.Update: IModel;
begin
  result := FAdapter.Update;
end;

end.
