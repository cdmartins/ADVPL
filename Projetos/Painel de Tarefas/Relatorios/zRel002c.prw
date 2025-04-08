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
Static nCorLinha := RGB(232, 229, 229)
Static nClrText1 := RGB(82, 235, 52)
Static nClrText2 := RGB(235, 159, 52)
Static nClrText3 := RGB(235, 52, 52)

/*/{Protheus.doc} User Function zRel002c
Tarefas Detalhadas
@author CÁRITA DIAS MARTINS DA SILVA
@since 04/04/2025
@version 1.0
@type function
/*/

User Function zRel002c()
	Local aArea := FWGetArea()
	Local aPergs   := {}
	Local dDataDe := sToD("")
	Local dDataAt := sToD("")
	
	//Adicionando os parametros do ParamBox
    aAdd(aPergs, {1, "Iniciada Em ",  dDataDe,  "", ".T.", "", ".T.", 80,  .T.})
    aAdd(aPergs, {1, "Iniciada Até ", dDataAt,  "", ".T.", "", ".T.", 80,  .T.})
	
	//Se a pergunta for confirma, cria o relatorio
	If ParamBox(aPergs, 'Informe os parâmetros', /*aRet*/, /*bOk*/, /*aButtons*/, /*lCentered*/, /*nPosx*/, /*nPosy*/, /*oDlgWizard*/, /*cLoad*/, .F., .F.)
		Processa({|| fImprime()})
	EndIf
	
	FWRestArea(aArea)
Return

/*/{Protheus.doc} fImprime
Faz a impressão do relatório zRel002c
@author CÁRITA DIAS MARTINS DA SILVA
@since 04/04/2025
@version 1.0
@type function
/*/

Static Function fImprime()
    Local aArea        := FWGetArea()
    Local nTotAux      := 0
    Local nAtuAux      := 0
    Local cQryAux      := ''
    Local cArquivo     := 'zRel002c'+RetCodUsr()+'_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.pdf'
    Local cDataIni  
    Local cDataFin
    Local cStatus      := ''
    Local nClrText0    := RGB(0, 0, 0)

    Private oPrintPvt
    Private oBrushLin  := TBrush():New(,nCorLinha)
    Private cHoraEx    := Time()
    Private nPagAtu    := 1
    Private cLogoEmp   := fLogoEmp()
    //Linhas e colunas
    Private nLinAtu    := 0
    Private nLinFin    := 800
    Private nColIni    := 010 //distancia da coluna e a borda esquerda
    Private nColFin    := 580
    Private nColMeio   := (nColFin-nColIni)/2
    //Colunas dos relatorio
    Private nColDad1    := nColIni
    Private nColDad2    := nColIni + 50
    Private nColDad3    := nColIni + 245
    Private nColDad4    := nColIni + 320
    Private nColDad5    := nColIni + 450
    //Declarando as fontes
    Private cNomeFont  := 'Arial'
    Private oFontDet   := TFont():New(cNomeFont, /*uPar2*/, -10, /*uPar4*/, .F., /*uPar6*/, /*uPar7*/, /*uPar8*/, /*uPar9*/, .F.)
    Private oFontDetN  := TFont():New(cNomeFont, /*uPar2*/, -12, /*uPar4*/, .T., /*uPar6*/, /*uPar7*/, /*uPar8*/, /*uPar9*/, .F.)
    Private oFontDtN2  := TFont():New(cNomeFont, /*uPar2*/, -9, /*uPar4*/, .T., /*uPar6*/, /*uPar7*/, /*uPar8*/, /*uPar9*/, .F.)
    Private oFontRod   := TFont():New(cNomeFont, /*uPar2*/, -8,  /*uPar4*/, .F., /*uPar6*/, /*uPar7*/, /*uPar8*/, /*uPar9*/, .F.)
    Private oFontMin   := TFont():New(cNomeFont, /*uPar2*/, -7,  /*uPar4*/, .F., /*uPar6*/, /*uPar7*/, /*uPar8*/, /*uPar9*/, .F.)
    Private oFontTit   := TFont():New(cNomeFont, /*uPar2*/, -15, /*uPar4*/, .T., /*uPar6*/, /*uPar7*/, /*uPar8*/, /*uPar9*/, .F.)
     

     cDataIni := DTOS(MV_PAR01)
     cDataFin := DTOS(MV_PAR02)
    //Monta a consulta de dados
    cQryAux += "SELECT "		+ CRLF
    cQryAux += " ZE1_CODIGO, "		+ CRLF
    cQryAux += " ZE1_TITULO, "		+ CRLF
    cQryAux += " ZE1_STATUS, "		+ CRLF
    cQryAux += " ZE1_DESCR"		+ CRLF
    cQryAux += "FROM "		+ CRLF
    cQryAux += " ZE1990 "		+ CRLF
    cQryAux += "WHERE "		+ CRLF
    cQryAux += " D_E_L_E_T_ = ' ' "		+ CRLF
    cQryAux += "AND "		+ CRLF
    cQryAux += "ZE1_DT BETWEEN '"+cDataIni+"' AND '"+cDataFin+"' "		+ CRLF
    cQryAux += "ORDER BY "		+ CRLF
    cQryAux += " ZE1_DT"		+ CRLF
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
                oPrintPvt:FillRect({nLinAtu - 2, nColIni, nLinAtu + 62, nColFin}, oBrushLin)
            EndIf

            //Mudo a cor da fonte e atribuo o Status 
            cStatus := QRY_AUX->ZE1_STATUS
            DO CASE
                CASE !Empty(cStatus) .AND. cStatus == "01"
                    cStatus := "Concluído"
                    nClrText0 = nClrText1
                CASE !Empty(cStatus) .AND. cStatus == "02"
                    cStatus := "Em Andamento"
                    nClrText0 = nClrText2
                CASE !Empty(cStatus) .AND. cStatus == "03"
                    cStatus := "Cancelado"
                    nClrText0 = nClrText3
                OTHERWISE
                    cStatus := "Status mão atribuído"
            END CASE

            //Imprime a linha atual
            oPrintPvt:SayAlign(nLinAtu, nColDad1, Alltrim(QRY_AUX->ZE1_CODIGO), oFontDet, 50, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
            oPrintPvt:SayAlign(nLinAtu, nColDad2, Alltrim(QRY_AUX->ZE1_TITULO), oFontDet, 200, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
            oPrintPvt:SayAlign(nLinAtu, nColDad3, Alltrim(cStatus), oFontDet, 100, 10, nClrText0, PAD_LEFT, /*nAlignVert*/)
            oPrintPvt:SayAlign(nLinAtu, nColDad4, Alltrim(QRY_AUX->ZE1_DESCR), oFontDtN2, 240, 150, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
 
            nLinAtu += 65
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
@since 04/04/2025
@version 1.0
@type function
/*/

Static Function fLogoEmp()
    Local cLogo       := 'C:\TOTVS\Protheus2310\protheus_data\anexos\logo_2.png'
Return cLogo

/*/{Protheus.doc} fImpCab
Função que imprime o cabeçalho do relatório
@author CÁRITA DIAS MARTINS DA SILVA
@since 04/04/2025
@version 1.0
@type function
/*/

Static Function fImpCab()
    Local cTexto   := ''
    Local nLinCab  := 015
     
    //Iniciando Pagina
    oPrintPvt:StartPage()
    
    //Imprime o logo
    If File(cLogoEmp)
        oPrintPvt:SayBitmap(005, nColIni, cLogoEmp, 050, 030)
    EndIf
     
    //Cabecalho
    cTexto := 'Relatório de Tarefas - Descrição'
    oPrintPvt:SayAlign(nLinCab, nColMeio-200, cTexto, oFontTit, 400, 20, /*nClrText*/, PAD_CENTER, /*nAlignVert*/)
     
    //Linha Separatoria
    nLinCab += 020
    oPrintPvt:Line(nLinCab,   nColIni, nLinCab,   nColFin)
     
    //Atualizando a linha inicial do relatorio
    nLinAtu := nLinCab + 5
    
    If nPagAtu == 1
        //Imprimindo os parâmetros
        cTexto := dToC(MV_PAR01)
        oPrintPvt:SayAlign(nLinAtu, nColIni, 'Desde de:', oFontDetN, 150, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
        oPrintPvt:SayAlign(nLinAtu, nColIni+200, cTexto, oFontDet, 150, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
        nLinAtu += 15
        
        cTexto := dToC(MV_PAR02)
        oPrintPvt:SayAlign(nLinAtu, nColIni, 'Até:', oFontDetN, 150, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
        oPrintPvt:SayAlign(nLinAtu, nColIni+200, cTexto, oFontDet, 150, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
        nLinAtu += 15
        
        oPrintPvt:Line(nLinAtu-3, nColIni, nLinAtu-3, nColFin, nCorCinza)
        nLinAtu += 5
    EndIf
    
    oPrintPvt:SayAlign(nLinAtu, nColDad1, 'Código', oFontMin, 50, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
    oPrintPvt:SayAlign(nLinAtu, nColDad2, 'Título', oFontMin, 150, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
    oPrintPvt:SayAlign(nLinAtu, nColDad3, 'Status', oFontMin, 50, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
    oPrintPvt:SayAlign(nLinAtu, nColDad4, 'Descrição', oFontMin, 200, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
    nLinAtu += 15
Return

/*/{Protheus.doc} fImpRod
Função que imprime o rodapé e encerra a página
@author CÁRITA DIAS MARTINS DA SILVA
@since 04/04/2025
@version 1.0
@type function
/*/

Static Function fImpRod()
    Local nLinRod:= nLinFin
    Local cTexto := ''
 
    //Linha Separatoria
    oPrintPvt:Line(nLinRod,   nColIni, nLinRod,   nColFin)
    nLinRod += 3
     
    //Dados da Esquerda
    cTexto := dToC(dDataBase) + '     ' + cHoraEx + '     ' + FunName() + ' (zRel002c)     ' + UsrRetName(RetCodUsr())
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
@since 04/04/2025
@version 1.0
@type function
/*/

Static Function fQuebra()
    If nLinAtu >= nLinFin-10
        fImpRod()
        fImpCab()
    EndIf
Return
