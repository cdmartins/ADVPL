//Bibliotecas
#Include "Totvs.ch"
#Include "TopConn.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"

//Alinhamentos
#Define PAD_LEFT    0
#Define PAD_RIGHT   1
#Define PAD_CENTER  2
#Define PAD_JUSTIFY 3 //Opção disponível somente a partir da versão 1.6.2 da TOTVS Printer

//Cor(es)
Static nCorCinza := RGB(110, 110, 110)
Static nCorLinha := RGB(241, 237, 237)

/*/{Protheus.doc} User Function zExer05
    Relatório PDF de: CDs x Artista x Quantidade de Músicas
@author CÁRITA DIAS MARTINS DA SILVA
@since 02/04/2025
@version 1.0
@type function
@see http://autumncodemaker.com
/*/

User Function zExer05()
	Local aArea := FWGetArea()
	Local aPergs   := {}
	Local xPar0 := Space(15)
	Local xPar1 := Space(15)
	
	//Adicionando os parametros do ParamBox
	aAdd(aPergs, {1, "Artista de:", xPar0,  "", ".T.", "ZD1", ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Artista até:", xPar1,  "", ".T.", "ZD1", ".T.", 80,  .F.})
	
	//Se a pergunta for confirma, cria o relatorio
	If ParamBox(aPergs, 'Informe os parâmetros', /*aRet*/, /*bOk*/, /*aButtons*/, /*lCentered*/, /*nPosx*/, /*nPosy*/, /*oDlgWizard*/, /*cLoad*/, .F., .F.)
		Processa({|| fImprime()})
	EndIf
	
	FWRestArea(aArea)
Return

/*/{Protheus.doc} fImprime
Faz a impressão do relatório zExer05
@author CÁRITA DIAS MARTINS DA SILVA
@since 02/04/2025
@version 1.0
@type function
@see http://autumncodemaker.com
/*/

Static Function fImprime()
    Local aArea        := FWGetArea()
    Local nTotAux      := 0
    Local nAtuAux      := 0
    Local cQryAux      := ''
    Local cArquivo     := 'zExer05'+RetCodUsr()+'_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.pdf'
    Private oPrintPvt
    Private oBrushLin  := TBrush():New(,nCorLinha)
    Private cHoraEx    := Time()
    Private nPagAtu    := 1
    Private cLogoEmp   := fLogoEmp()
    //Linhas e colunas
    Private nLinAtu    := 0
    Private nLinFin    := 800
    Private nColIni    := 010
    Private nColFin    := 580
    Private nColMeio   := (nColFin-nColIni)/2
    //Colunas dos relatorio
    Private nColDad1    := nColIni
    Private nColDad2    := nColIni + 50
    Private nColDad3    := nColIni + 230 //100 aumentei pra 150 aumentei pra 250
    Private nColDad4    := nColIni + 350 //É AQUI Q MEXE 250
    Private nColDad5    := nColIni + 450 //É AQUI Q MEXE 250
    //Declarando as fontes
    Private cNomeFont  := 'Arial'
    Private oFontDet   := TFont():New(cNomeFont, /*uPar2*/, -11, /*uPar4*/, .F., /*uPar6*/, /*uPar7*/, /*uPar8*/, /*uPar9*/, .F.)
    Private oFontDetN  := TFont():New(cNomeFont, /*uPar2*/, -13, /*uPar4*/, .T., /*uPar6*/, /*uPar7*/, /*uPar8*/, /*uPar9*/, .F.)
    Private oFontRod   := TFont():New(cNomeFont, /*uPar2*/, -8,  /*uPar4*/, .F., /*uPar6*/, /*uPar7*/, /*uPar8*/, /*uPar9*/, .F.)
    Private oFontMin   := TFont():New(cNomeFont, /*uPar2*/, -9,  /*uPar4*/, .F., /*uPar6*/, /*uPar7*/, /*uPar8*/, /*uPar9*/, .F.)
    Private oFontTit   := TFont():New(cNomeFont, /*uPar2*/, -15, /*uPar4*/, .T., /*uPar6*/, /*uPar7*/, /*uPar8*/, /*uPar9*/, .F.)
     
    MV_PAR01 = Alltrim(MV_PAR01)
    MV_PAR02 = Alltrim(MV_PAR02)

    //Monta a consulta de dados
    cQryAux += "SELECT "		+ CRLF
    cQryAux += " c.ZD2_CD, "		+ CRLF
    cQryAux += " c.ZD2_NOMECD , "		+ CRLF
    cQryAux += " a.ZD1_NOME, "		+ CRLF
    cQryAux += " COUNT(m.ZD3_ITEM) AS QTD_MSC"		+ CRLF
    cQryAux += "FROM "		+ CRLF
    cQryAux += " ZD2990 AS c "		+ CRLF
    cQryAux += "Inner Join "		+ CRLF
    cQryAux += " ZD1990 AS a ON ZD1_CODIGO = c.ZD2_ARTIST "		+ CRLF
    cQryAux += "Left Join "		+ CRLF
    cQryAux += " ZD3990 AS m ON ZD3_CD = c.ZD2_CD "		+ CRLF
    cQryAux += "WHERE "		+ CRLF
    cQryAux += " c.D_E_L_E_T_ = '' "		+ CRLF
    cQryAux += " AND "		+ CRLF
    cQryAux += " a.D_E_L_E_T_ = '' "		+ CRLF
    cQryAux += " AND "		+ CRLF
    cQryAux += " m.D_E_L_E_T_ = '' "		+ CRLF
    cQryAux += " AND "		+ CRLF
    cQryAux += " a.ZD1_CODIGO BETWEEN '"+   MV_PAR01    +"' AND '"  +   MV_PAR02   +"' " + CRLF
    cQryAux += "GROUP BY "		+ CRLF
    cQryAux += " c.ZD2_CD,c.ZD2_NOMECD,a.ZD1_NOME "		+ CRLF
    cQryAux += "ORDER BY "		+ CRLF
    cQryAux += " ZD1_NOME"		+ CRLF
	If '--' $ cQryAux .Or. 'WITH' $ Upper(cQryAux) .Or. 'NOLOCK' $ Upper(cQryAux)
		FWAlertInfo('Alguns comandos (como --, WITH e NOLOCK), não são executados pela PLSQuery devido ao ChangeQuery. Tente migrar da PLSQuery para TCQuery.', 'Atenção')
	EndIf 
    PLSQuery(cQryAux, 'QRY_AUX')
 
    //Define o tamanho da régua
    DbSelectArea('QRY_AUX')
    QRY_AUX->(DbGoTop())
    Count to nTotAux
    ProcRegua(nTotAux)
    QRY_AUX->(DbGoTop())
     
    //Somente se tiver dados
    If ! QRY_AUX->(EoF())
        //Criando o objeto de impressao
        oPrintPvt := FWMSPrinter():New(;
        	cArquivo,;    // cFilePrinter
        	IMP_PDF,;     // nDevice
        	.F.,;         // lAdjustToLegacy
        	,;            // cPathInServer
        	.T.,;         // lDisabeSetup
        	,;            // lTReport
        	@oPrintPvt,;  // oPrintSetup
        	,;            // cPrinter
        	,;            // lServer
        	,;            // lParam10
        	,;            // lRaw
        	.T.;          // lViewPDF
        )
        oPrintPvt:cPathPDF := GetTempPath()
        oPrintPvt:SetResolution(72)
        oPrintPvt:SetPortrait()
        oPrintPvt:SetPaperSize(DMPAPER_A4)
        oPrintPvt:SetMargin(0, 0, 0, 0)
 
        //Imprime os dados
        fImpCab()
        While ! QRY_AUX->(EoF())
            nAtuAux++
            IncProc('Imprimindo registro ' + cValToChar(nAtuAux) + ' de ' + cValToChar(nTotAux) + '...')
 
            //Se atingiu o limite, quebra de pagina
            fQuebra()
             
            //Faz o zebrado ao fundo
            If nAtuAux % 2 == 0
                oPrintPvt:FillRect({nLinAtu - 2, nColIni, nLinAtu + 12, nColFin}, oBrushLin)
            EndIf
 
            //Imprime a linha atual
            oPrintPvt:SayAlign(nLinAtu, nColDad1, Alltrim(QRY_AUX->ZD2_CD), oFontDet, 50, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
            oPrintPvt:SayAlign(nLinAtu, nColDad2, Alltrim(QRY_AUX->ZD2_NOMECD), oFontDetN, 150, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
            oPrintPvt:SayAlign(nLinAtu, nColDad3, Alltrim(QRY_AUX->ZD1_NOME), oFontDet, 100, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
            oPrintPvt:SayAlign(nLinAtu, nColDad4, Alltrim(cValToChar(QRY_AUX->QTD_MSC)), oFontDet, 50, 15, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
 
            nLinAtu += 15
            oPrintPvt:Line(nLinAtu-3, nColIni, nLinAtu-3, nColFin, nCorCinza)
 
            //Se atingiu o limite, quebra de pagina
            fQuebra()
             
            QRY_AUX->(DbSkip())
        EndDo
        
        //Imprime o último rodapé
        fImpRod()
         
        oPrintPvt:Preview()
    Else
        FWAlertError('Não foi encontrado informações com os parâmetros informados!', 'Atenção')
    EndIf
    QRY_AUX->(DbCloseArea())
     
    FWRestArea(aArea)
Return

/*/{Protheus.doc} fLogoEmp
Função que retorna o logo da empresa conforme configuração da DANFE
@author CÁRITA DIAS MARTINS DA SILVA
@since 02/04/2025
@version 1.0
@type function
@see http://autumncodemaker.com
/*/

Static Function fLogoEmp()
    Local cLogo       := 'C:\TOTVS\Protheus2310\protheus_data\anexos\logo_2.png'
Return cLogo

/*/{Protheus.doc} fImpCab
Função que imprime o cabeçalho do relatório
@author CÁRITA DIAS MARTINS DA SILVA
@since 02/04/2025
@version 1.0
@type function
@see http://autumncodemaker.com
/*/

Static Function fImpCab()
    Local cTexto   := ''
    Local nLinCab  := 015
     
    //Iniciando Pagina
    oPrintPvt:StartPage()
    
    //Imprime o logo
    If File(cLogoEmp)
        oPrintPvt:SayBitmap(005, nColIni, cLogoEmp, 060, 030)
    EndIf
     
    //Cabecalho
    cTexto := 'CDs x Artista'
    oPrintPvt:SayAlign(nLinCab, nColMeio-200, cTexto, oFontTit, 400, 20, /*nClrText*/, PAD_CENTER, /*nAlignVert*/)
     
    //Linha Separatoria
    nLinCab += 020
    oPrintPvt:Line(nLinCab,   nColIni, nLinCab,   nColFin)
     
    //Atualizando a linha inicial do relatorio
    nLinAtu := nLinCab + 5
    
    If nPagAtu == 1
        //Imprimindo os parâmetros
        cTexto := MV_PAR01
        oPrintPvt:SayAlign(nLinAtu, nColIni, 'Artista de:', oFontDetN, 200, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
        oPrintPvt:SayAlign(nLinAtu, nColIni+200, cTexto, oFontDet, 200, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
        nLinAtu += 15
        
        cTexto := MV_PAR02
        oPrintPvt:SayAlign(nLinAtu, nColIni, 'Artista até:', oFontDetN, 200, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
        oPrintPvt:SayAlign(nLinAtu, nColIni+200, cTexto, oFontDet, 200, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
        nLinAtu += 15
        
        oPrintPvt:Line(nLinAtu-3, nColIni, nLinAtu-3, nColFin, nCorCinza)
        nLinAtu += 5
    EndIf
    
    oPrintPvt:SayAlign(nLinAtu, nColDad1, 'Código', oFontMin, 50, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
    oPrintPvt:SayAlign(nLinAtu, nColDad2, 'Título do CD', oFontMin, 50, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
    oPrintPvt:SayAlign(nLinAtu, nColDad3, 'Artista', oFontMin, 100, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
    //Aqui eu aumento o tamango da caixa do texto caso esteja cortando, logo apos o font 
    oPrintPvt:SayAlign(nLinAtu, nColDad4, 'Quantidade de Músicas', oFontMin, 100, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)

    nLinAtu += 15
Return

/*/{Protheus.doc} fImpRod
Função que imprime o rodapé e encerra a página
@author CÁRITA DIAS MARTINS DA SILVA
@since 02/04/2025
@version 1.0
@type function
@see http://autumncodemaker.com
/*/

Static Function fImpRod()
    Local nLinRod:= nLinFin
    Local cTexto := ''
 
    //Linha Separatoria
    oPrintPvt:Line(nLinRod,   nColIni, nLinRod,   nColFin)
    nLinRod += 3
     
    //Dados da Esquerda
    cTexto := dToC(dDataBase) + '     ' + cHoraEx + '     ' + FunName() + ' (zExer05)     ' + UsrRetName(RetCodUsr())
    oPrintPvt:SayAlign(nLinRod, nColIni, cTexto, oFontRod, 500, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
     
    //Direita
    cTexto := 'Pagina '+cValToChar(nPagAtu)
    oPrintPvt:SayAlign(nLinRod, nColFin-40, cTexto, oFontRod, 040, 10, /*nClrText*/, PAD_RIGHT, /*nAlignVert*/)
     
    //Finalizando a pagina e somando mais um
    oPrintPvt:EndPage()
    nPagAtu++
Return

/*/{Protheus.doc} fQuebra
Função que valida se a linha esta próxima do final, se sim quebra a página
@author CÁRITA DIAS MARTINS DA SILVA
@since 02/04/2025
@version 1.0
@type function
@see http://autumncodemaker.com
/*/

Static Function fQuebra()
    If nLinAtu >= nLinFin-10
        fImpRod()
        fImpCab()
    EndIf
Return
