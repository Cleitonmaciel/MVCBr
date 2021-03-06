unit eMVC.ViewModelCreator;

{ ********************************************************************** }
{ Copyright 2005 Reserved by Eazisoft.com }
{ File Name: ModelCreator.pas }
{ Author: Larry Le }
{ Description:  Model Creator }
{ }
{ History: }
{ - 1.0, 19 May 2006 }
{ First version }
{ }
{ Email: linfengle@gmail.com }
{ }
{ The contents of this file are subject to the Mozilla Public License }
{ Version 1.1 (the "License"); you may not use this file except in }
{ compliance with the License. You may obtain a copy of the License at }
{ http://www.mozilla.org/MPL/ }
{ }
{ Software distributed under the License is distributed on an "AS IS" }
{ basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See }
{ the License for the specific language governing rights and }
{ limitations under the License. }
{ }
{ The Original Code is written in Delphi. }
{ }
{ The Initial Developer of the Original Code is Larry Le. }
{ Copyright (C) eazisoft.com. All Rights Reserved. }
{ }
{ ********************************************************************** }

interface

uses
  Windows, SysUtils,
  eMVC.ViewCreator,
  eMVC.FileCreator,
  ToolsApi,
  eMVC.OTAUtilities,
  eMVC.BaseCreator;

type

  TViewModelCreator = class(TBaseCreator)
  private
    FisInterf: boolean;
    FUnitIdent: string;
    procedure SetisInterf(const Value: boolean);
  public
    constructor Create(const APath: string = ''; ABaseName: string = '';
      AUnNamed: boolean = true); override;
    function GetImplFileName: string; override;
    function NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string)
      : IOTAFile; override;
    property isInterf: boolean read FisInterf write SetisInterf;
  end;

implementation

{ TModelCreator }

constructor TViewModelCreator.Create(const APath: string = '';
  ABaseName: string = ''; AUnNamed: boolean = true);
begin
  inherited Create(APath, ABaseName, AUnNamed);
  self.SetAncestorName('viewmodel');
end;

function TViewModelCreator.GetImplFileName: string;
begin
  FUnitIdent := getBaseName + '.ViewModel';
  if isInterf then
    FUnitIdent := getBaseName + '.ViewModel.Interf';
  result := self.GetPath + FUnitIdent + '.pas';
  debug('TViewModelCreator.GetImplFileName: ' + result);
end;

function TViewModelCreator.NewImplSource(const ModuleIdent, FormIdent,
  AncestorIdent: string): IOTAFile;
var
  fc: TFileCreator;
begin

  if isInterf then
    fc := TFileCreator.Create(ModuleIdent, FormIdent, AncestorIdent,
      cModelInterf)
  else
    fc := TFileCreator.Create(ModuleIdent, FormIdent, AncestorIdent,
      cVIEWMODEL);
  fc.isFMX := self.isFMX;
  fc.Templates.Assign(self.Templates);
  fc.Templates.Add('%MdlInterf=' + getBaseName + '.ViewModel.Interf');
  fc.Templates.Add('%UnitIdent=' + FUnitIdent);
  debug('TViewModelCreator.NewImplSource: ' + fc.Templates.Values
    ['%MdlInterf']);
  result := fc;
end;

procedure TViewModelCreator.SetisInterf(const Value: boolean);
begin
  FisInterf := Value;
end;

end.
