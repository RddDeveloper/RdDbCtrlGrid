unit untPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  RTTICtrls, untRdCtrlGrid, untDmPrincipal, TypInfo;

type

  { TfrmPrincipal }

  TfrmPrincipal = class(TForm)
    Button1: TButton;
    fpItens: TFlowPanel;
    fpFundo: TFlowPanel;
    ImageList1: TImageList;
    Panel1: TPanel;
    sbGrupo: TScrollBox;
    sbItens: TScrollBox;
    procedure Button1Click(Sender: TObject);
  private
    pGrid 		: TRdGrid;
    pGridProd : TRdGrid;
    procedure CliqueGrupo(pCodigo : Integer; pDescricao, pStatus : String; pValor : Real);
    procedure CliqueProdutos(pCodigo : Integer; pDescricao, pStatus : String; pValor : Real);

  public

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.lfm}

{ TfrmPrincipal }

procedure TfrmPrincipal.Button1Click(Sender: TObject);
begin
  frmDmPrincipal.qryGrupo.Close;
  frmDmPrincipal.qryGrupo.Open;

  pGrid := TRdGrid.Create(frmDmPrincipal.qryGrupo);
  pGrid.configuraPainel(150,200,clGreen);
  pGrid.configuraLabel(tlbCodigo,10,10,'Código: ', 9, True, clRed);
  pGrid.configuraLabel(tlbDescricao,30,10,'', 10, True, clBlue);
  //pGrid.configuraLabel(tlbValor,50,10,'R$ ',12, True, clGreen);
  pGrid.configurarStatus(8,165,30,ImageList1,'A=1|B=2|C=0');
  pGrid.configurarImagem(60,110,80);
  pGrid.montargrid(fpFundo);

  pGrid.FDados:=@CliqueGrupo;
end;

procedure TfrmPrincipal.CliqueGrupo(pCodigo: Integer; pDescricao, pStatus: String; pValor: Real);
begin
  fpItens.Visible:=False;

  frmDmPrincipal.qryProduto.Close;
  frmDmPrincipal.qryProduto.ParamByName('idgrupo').AsInteger:= pCodigo;
  frmDmPrincipal.qryProduto.Open;

  if not frmDmPrincipal.qryProduto.IsEmpty then
  begin
  	pGridProd := TRdGrid.Create(frmDmPrincipal.qryProduto);
    pGridProd.configuraPainel(80,180,clGray);
    pGridProd.configuraLabel(tlbCodigo,10,10,'Código: ', 9, False, clCream);
    pGridProd.configuraLabel(tlbDescricao,30,10,'', 10, True, clBlack);
    pGridProd.configuraLabel(tlbValor,50,10,'R$ ',12, False, clCream);
    //pGridProd.configurarStatus(8,165,30,ImageList1,'A=1|B=2|C=0');
    //pGridProd.configurarImagem(60,110,80);
    pGridProd.montargrid(fpItens);
    fpItens.Visible := True;

    pGridProd.FDados:=@CliqueProdutos;
	end;
end;

procedure TfrmPrincipal.CliqueProdutos(pCodigo: Integer; pDescricao, pStatus: String; pValor: Real);
begin
  if MessageDlg('Confirma a exclusão do produto?','Confirma',mtConfirmation, mbYesNo, 0) = mrYes then
  begin
  	frmDmPrincipal.zDelete.Close;
    frmDmPrincipal.zDelete.ParamByName('codigo').AsInteger:=pCodigo;
    frmDmPrincipal.zDelete.ExecSQL;

    frmDmPrincipal.qryProduto.RevertRecord;
  end;

  //ShowMessage(
  //	'CLIQUE LISTA DE PRODUTOS '+sLineBreak+
  //	'Código: '+pCodigo.ToString+sLineBreak+
  // 	'Descrição: '+pDescricao+sLineBreak+
  // 	//'Status: '+pStatus+sLineBreak+
  // 	'Valor: '+FormatCurr(',0.00',pValor)+sLineBreak+
  // 	''
  //);
end;

end.

