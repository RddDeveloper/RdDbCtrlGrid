unit untDmPrincipal;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset;

type

  { TfrmDmPrincipal }

  TfrmDmPrincipal = class(TDataModule)
    zConexao: TZConnection;
    qryGrupo: TZQuery;
    qryProduto: TZQuery;
    zDelete: TZQuery;
    procedure DataModuleCreate(Sender: TObject);
  private

  public

  end;

var
  frmDmPrincipal: TfrmDmPrincipal;

implementation

{$R *.lfm}

{ TfrmDmPrincipal }

procedure TfrmDmPrincipal.DataModuleCreate(Sender: TObject);
begin
  zConexao.Connected := False;
end;

end.

