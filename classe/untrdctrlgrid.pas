{
	DESENVOLVIDO POR RD DEVELOPER - developer.rafaeldias@gmail.com - 21/07/2024
  Pode ser utilizada para uso comercial sem requerer diretiros autorais.
    ###MODELO DE USO DA CHAMADA DA CLASSE - PRECISA SER MELHORADO###
  	pGrid := TRdGrid.Create(frmDmPrincipal.qryGrupo);
   	pGrid.configuraPainel(150,200,clYellow);
   	pGrid.configuraLabel(tlbCodigo,10,10,'Código: ', 8, True, clRed);
   	pGrid.configuraLabel(tlbDescricao,30,10,'', 10, True, clBlue);
   	pGrid.configuraLabel(tlbValor,50,10,'R$ ',12, True, clGreen);
   	pGrid.configurarStatus(8,165,30,ImageList1,'A=1|B=2|C=0');
   	pGrid.configurarImagem(60,110,80);
   	pGrid.montargrid(fpFundo);

   	pGrid.FDados:=@ExibirDadosClique;

    ###CAMPOS PADRAO NO SQL###
   	Codigo		: integer
    descricao	: string
    valor			: float
    status		: string //OPCIONAL ('A=1|B=2|C=0') Exemplo para fazer o depara do status
    imagem		: blob //opcional
}

unit untRdCtrlGrid;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, ExtCtrls, Forms, Controls, Graphics, StdCtrls, Dialogs,
  TypInfo, RTTICtrls, StrUtils;

type

  { TRdGrid }
  TTipoLabel = (tlbCodigo, tlbDescricao, tlbValor);

  TEvento = procedure(pCodigo : Integer; pDescricao, pStatus : String; pValor : Real) of object;

  TRdGrid = class
    private
      FFDataset    			: TDataSet;
      FlbCodigo    			: TLabel;
      FlbDescricao 			: TLabel;
      FPainel      			: TPanel;
      FlbValor     			: TLabel;
      FlbImgList   			: TImageList;
      FImg         			: TTIImage;
      FImagem			 			: TImage;
      //painel
      FAltura   				: Integer;
      FLargura  				: Integer;
      FColor    				: TColor;
      //codigo
      FTemCodigo				: Boolean;
      FTopCodigo 				: Integer;
      FLeftCodigo				: integer;
      FTextoCodigo			: string;
      FColorCodigo			: TColor;
      FNegritoCodigo		: Boolean;
      FTamFonteCodigo 	: Integer;
      //descricao
      FTemDescricao			: Boolean;
      FTopDescricao 		: Integer;
      FLeftDescricao		: integer;
      FTextoDescricao		: string;
      FColorDescricao		: TColor;
      FNegritoDescricao	: Boolean;
      FTamFonteDescricao: Integer;
      //valor
      FTemValor					: Boolean;
      FTopValor 				: Integer;
      FLeftValor				: integer;
      FTextoValor				: string;
      FColorValor				: TColor;
      FNegritoValor			: Boolean;
      FTamFonteValor		: Integer;
      //status
      FTopStatus 				: integer;
      FLeftStatus 			: integer;
      FTamanhoStatus 		: Integer;
      FStatus 					: string;
      FTemStatus				: Boolean;
      //configura imagem
      FTemImagem				: Boolean;
      FTopImagem 				: integer;
      FLeftImagem 			: integer;
      FTamanhoImagem 		: Integer;
      //configura label;
      FFTpLabel    			: TTipoLabel;
      //eventos
      procedure RefreshImage(Field : TField; Img : TImage);
      procedure clicarnopainel(Sender : TObject);
    public
      property FDataset : TDataSet read FFDataset write FFDataset;
      property FTpLabel : TTipoLabel read FFTpLabel write FFTpLabel;
      //property FlbImgList  : TImageList read FFlbImgList write FFlbImgList;
      var sSelCodigo 		: Integer;
  		var sSelDescricao : String;
      var sSelValor 		: Real;
      var sSelStatus 		: String;
      var FDados 				: TEvento;

      Constructor Create(pDataSet : TDataSet);
      destructor destroy; override;
      procedure configuraPainel(pAltura, pLargura : Integer; pColor : TColor);
      procedure configuraLabel(pLabel : TTipoLabel; pTop, pLeft : integer; pTexto : string; pTamFonte : Integer; pNegrito : Boolean; pColor : TColor);
      procedure configurarStatus(pTop, pLeft, pTamanho: Integer; pImage: TImageList; pStatus: string);
      procedure configurarImagem(pTop, pLeft, pTamanho: Integer);
      procedure montargrid(pSelf : TCustomPanel);
  end;

implementation

{ TRdGrid }

procedure TRdGrid.RefreshImage(Field : TField; Img : TImage);
var
  vJpeg   : TJPEGImage;
  vStream : TMemoryStream;
begin
  { Verifica se o campo esta vázio. }
  if not Field.IsNull then
  begin

    { Cria objeto do tipo TJPEG, e objeto do tipo MemoryStream}
    vJpeg   := TJPEGImage.Create;
    vStream := TMemoryStream.Create;

    { Trata o campo como do tipo BLOB e salva o seu conteudo na memória. }
    TBlobField(Field).SaveToStream(vStream);

    { Ajusta a posicao inicial de leitura da memória }
    vStream.Position := 0;

    { Carrega da memoria os dados, para uma estrutura do tipo TJPEG
      (A partir da posicao 0)}
    vJpeg.LoadFromStream(vStream);

    { Exibe o jpg no Timage. }
    Img.Picture.Assign(vJpeg);

    { Libera a memoria utilizada pelos componentes de conversão }
    vJpeg.Free;
    vStream.Free;
  end
  else
  begin
    Img.Picture.Bitmap.Clear;
  end;
end;

procedure TRdGrid.clicarnopainel(Sender: TObject);
begin
  FFDataset.Locate('codigo', TPanel(Sender).Tag, [loPartialKey]);
  sSelCodigo := FFDataset.FieldByName('codigo').AsInteger;
  if FTemDescricao then
  	sSelDescricao := FFDataset.FieldByName('descricao').AsString;
 	if FTemValor then
  	sSelValor := FFDataset.FieldByName('valor').AsFloat;
  if FTemStatus then
  	sSelStatus := FFDataset.FieldByName('status').AsString;
  if Assigned(FDados) then;
  	FDados(sSelCodigo, sSelDescricao, sSelStatus, sSelValor);
end;

constructor TRdGrid.Create(pDataSet: TDataSet);
begin
  FTemCodigo					:= False;
  FTemDescricao				:= False;
  FTemValor						:= False;
  FTemImagem					:= False;
  FTemStatus					:= False;
  FFDataset 					:= pDataSet;
  FTamFonteCodigo			:= 8;
  FTamFonteDescricao	:= 8;
  FTamFonteValor			:= 8;
end;

destructor TRdGrid.destroy;
begin
  FPainel.Free;
  inherited destroy;
end;

procedure TRdGrid.montargrid(pSelf: TCustomPanel);
var
  i, iSeparacao, lIndex : integer;
  lSStatus : TStringArray;
begin
  if not FTemCodigo then
  begin
    MessageDlg('Falha','Campo código obrigatório não foi informado',mtError,[mbOK],0);
    Abort;
  end;

  for i := pSelf.ComponentCount -1 downto 0 do
      pSelf.Components[i].Free;

  lSStatus := SplitString(FStatus,'|');

  FFDataset.DisableControls;
  try
    FFDataset.First;
    while not FFDataset.EOF do
    begin
      //criar os paineis
      FPainel 						:= TPanel.Create(pSelf);
      FPainel.Parent 			:= pSelf;
      FPainel.Width  			:= FLargura;
      FPainel.Height 			:= FAltura;
      FPainel.Tag    			:= FFDataset.FieldByName('codigo').AsInteger;
      FPainel.Color  			:= FColor;
      FPainel.BorderStyle	:= bsSingle;;
      FPainel.OnClick			:= @clicarnopainel;
      //criar o label codigo
      if FTemCodigo then
      begin
        FlbCodigo        		:= TLabel.Create(FPainel);
        FlbCodigo.Parent 		:= FPainel;
        FlbCodigo.Top    		:= FTopCodigo;
        FlbCodigo.Left   		:= FLeftCodigo;
        FlbCodigo.Caption		:= Concat(FTextoCodigo,FFDataset.FieldByName('codigo').AsInteger.ToString);
        FlbCodigo.Font.Size	:= FTamFonteCodigo;
        FlbCodigo.Font.Color:= FColorCodigo;
        FlbCodigo.Font.Bold := FNegritoCodigo;
      end;
      //criar o label descricao
      if FTemDescricao then
      begin
        FlbDescricao        		:= TLabel.Create(FPainel);
        FlbDescricao.Parent 		:= FPainel;
        FlbDescricao.Top    		:= FTopDescricao;
        FlbDescricao.Left   		:= FLeftDescricao;
        FlbDescricao.Caption		:= FFDataset.FieldByName('descricao').AsString;
        FlbDescricao.Font.Size	:= FTamFonteDescricao;
        FlbDescricao.Font.Color	:= FColorDescricao;
        FlbDescricao.Font.Bold  := FNegritoDescricao;
      end;
      //criar o label valor
      if FTemValor then
      begin
        FlbValor             := TLabel.Create(FPainel);
        FlbValor.Parent      := FPainel;
        FlbValor.Top         := FTopValor;
        FlbValor.Left        := FLeftValor;
        FlbValor.Caption     := concat(FTextoValor,FormatFloat('###,###,##0.00', FFDataset.FieldByName('valor').AsFloat));
        FlbValor.Font.Size	 := FTamFonteValor;
        FlbValor.Font.Color  := FColorValor;
        FlbValor.Font.Bold   := FNegritoValor;
      end;

      if FTemStatus then
      begin
        FImg 							 := TTIImage.Create(FPainel);
        FImg.Parent        := FPainel;
        FImg.Left          := FLeftStatus;
        FImg.Top           := FTopStatus;
        FImg.Width         := FTamanhoStatus;
        FImg.Height        := FTamanhoStatus;
        FImg.Stretch       := True;

        //FStatus  'A=1|B=2|C=3' ;
        for i := Low(lSStatus) to High(lSStatus) do
        begin
          iSeparacao:= Pos('=', lSStatus[i]);
          if iSeparacao > 0 then
             if FDataset.FieldByName('status').AsString = Copy(lSStatus[i],1,pred(iSeparacao)) then
             begin
               lIndex:= StrToIntDef(Copy(lSStatus[i], (iSeparacao+1), Length(lSStatus[i])),0);
               FlbImgList.GetBitmap(lIndex, FImg.Picture.Bitmap);
             end;
        end;
        //if MatchStr(FDataset.FieldByName('status').AsString+'=2', lSStatus) then
        //begin
        //  FlbImgList.GetBitmap(2, FImg.Picture.Bitmap);
        //end;
      end;
      if FTemImagem then
      begin
        if not FDataset.FieldByName('imagem').IsNull then
        begin
    		  FImagem 							:= TImage.Create(FPainel);
          FImagem.Parent        := FPainel;
          FImagem.Left          := FLeftImagem;
          FImagem.Top           := FTopImagem;
          FImagem.Width         := FTamanhoImagem;
          FImagem.Height        := FTamanhoImagem;
          FImagem.Stretch       := True;
          RefreshImage(FFDataset.FieldByName('imagem'), FImagem);
        end;
      end;
      FFDataset.Next;
    end;
  finally
    FFDataset.EnableControls;
  end;
end;

procedure TRdGrid.configuraPainel(pAltura, pLargura: Integer; pColor: TColor);
begin
  FAltura   := pAltura;
  FLargura  := pLargura;
  FColor    := pColor;
end;

procedure TRdGrid.configuraLabel(pLabel: TTipoLabel; pTop, pLeft: integer; pTexto: string; pTamFonte: Integer; pNegrito: Boolean; pColor: TColor);
begin
  FTpLabel         := pLabel;
  case FTpLabel of
       tlbCodigo :    begin
         								FTemCodigo				:= True;
                        FTopCodigo      	:= pTop;
                        FLeftCodigo     	:= pLeft;
                        FTextoCodigo    	:= pTexto;
                        FColorCodigo    	:= pColor;
                        FNegritoCodigo  	:= pNegrito;
                        FTamFonteCodigo		:= pTamFonte;
                      end;
       tlbDescricao : begin
         								FTemDescricao			:= True;
                        FTopDescricao    	:= pTop;
                        FLeftDescricao   	:= pLeft;
                        FTextoDescricao  	:= pTexto;
                        FColorDescricao  	:= pColor;
                        FNegritoDescricao	:= pNegrito;
                        FTamFonteDescricao:= pTamFonte;
                      end;
       tlbValor     : begin
         								FTemValor					:= True;
                        FTopValor         := pTop;
                        FLeftValor        := pLeft;
                        FTextoValor       := pTexto;
                        FColorValor       := pColor;
                        FNegritoValor     := pNegrito;
                        FTamFonteValor		:= pTamFonte;
                      end;
  end;
end;

procedure TRdGrid.configurarStatus(pTop, pLeft, pTamanho: Integer; pImage: TImageList; pStatus: string);
begin
  FTemStatus		:=True;
  FTopStatus 		:= pTop;
  FLeftStatus 	:= pLeft;
  FTamanhoStatus:= pTamanho;
  FlbImgList 		:= pImage;
  FStatus 			:= pStatus;
end;

procedure TRdGrid.configurarImagem(pTop, pLeft, pTamanho: Integer);
begin
  FTemImagem		:= True;
  FTopImagem 		:= pTop;
  FLeftImagem 	:= pLeft;
  FTamanhoImagem:= pTamanho;
end;

end.

