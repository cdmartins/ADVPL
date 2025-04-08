//Bibliotecas
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

//Variveis Estaticas
Static cTitulo := "Cadastro de Tarefas"
Static cAliasMVC := "ZE1"

/*/{Protheus.doc} User Function zExer04
	Cadastro de Tarefas
@author CÁRITA DIAS MARTINS DA SILVA
@since 01/04/2025
@version 1.0
@type function
/*/

User Function zExer04()
	Local aArea   := FWGetArea()
	Local oBrowse
	Private aRotina := {}

	//Definicao do menu
	aRotina := MenuDef()

	//Instanciando o browse
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias(cAliasMVC)
	oBrowse:SetDescription(cTitulo)
	oBrowse:DisableDetails()

	//Adicionando as Legendas
	oBrowse:AddLegend( "ZE1->ZE1_STATUS = '01'", "GREEN",    "Concluído" )
	oBrowse:AddLegend( "ZE1->ZE1_STATUS = '02'", "ORANGE",    "Em Andamento" )
	oBrowse:AddLegend( "ZE1->ZE1_STATUS = '03'", "RED",    "Cancelado" )

	//Ativa a Browse
	oBrowse:Activate()

	FWRestArea(aArea)
Return Nil

/*/{Protheus.doc} MenuDef
Menu de opcoes na funcao zExer04
@author CÁRITA DIAS MARTINS DA SILVA
@since 01/04/2025
@version 1.0
@type function
/*/

Static Function MenuDef()
	Local aRotina := {}

	//Adicionando opcoes do menu
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.zExer04" OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.zExer04" OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.zExer04" OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.zExer04" OPERATION 5 ACCESS 0

Return aRotina

/*/{Protheus.doc} ModelDef
Modelo de dados na funcao zExer04
@author CÁRITA DIAS MARTINS DA SILVA
@since 01/04/2025
@version 1.0
@type function
/*/

Static Function ModelDef()
	Local oStruct := FWFormStruct(1, cAliasMVC)
	Local oModel
	Local bPre := Nil
	Local bPos := {|| u_z04bPos(), u_z05bPos()}
	Local bCancel := Nil


	//Cria o modelo de dados para cadastro
	oModel := MPFormModel():New("zExer04M", bPre, bPos, /*bCommit*/, bCancel)
	oModel:AddFields("ZE1MASTER", /*cOwner*/, oStruct)
	oModel:SetDescription("Modelo de dados - " + cTitulo)
	oModel:GetModel("ZE1MASTER"):SetDescription( "Dados de - " + cTitulo)
	oModel:SetPrimaryKey({})
Return oModel

/*/{Protheus.doc} ViewDef
Visualizacao de dados na funcao zExer04
@author CÁRITA DIAS MARTINS DA SILVA
@since 01/04/2025
@version 1.0
@type function
/*/

Static Function ViewDef()
	Local oModel := FWLoadModel("zExer04")
	Local oStruct := FWFormStruct(2, cAliasMVC)
	Local oView

	//Cria a visualizacao do cadastro
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField("VIEW_ZE1", oStruct, "ZE1MASTER")
	oView:CreateHorizontalBox("TELA" , 100 )
	oView:SetOwnerView("VIEW_ZE1", "TELA")

Return oView


/*/{Protheus.doc} z13bPos
	1: Função chamada no clique do botão Ok do Modelo de Dados (pós-validação)
		Valida se tem data final caso o Status seja diferente de vazio e igual à "Em andamento" Caso contrário,não permite. 
@type function
@author Cárita
@since 07/04/2025
/*/
 User Function z04bPos()
    Local oModelPad  := FWModelActive()
    Local cStatus   := oModelPad:GetValue('ZE1MASTER', 'ZE1_STATUS')
    Local cDataFin  := oModelPad:GetValue('ZE1MASTER', 'ZE1_DTFINA')
    Local lRet       := .T.
     
    //validacao
    If Empty(cDataFin) .AND. ! cStatus == "02"
        Help(, , "Help", , "Insira uma data para essa finalização!", 1, 0, , , , , , {"Apenas é permitido campo vazio em tarefas com status <b>EM ANDAMENTO</b>"})
        lRet := .F.
    EndIf
     
Return lRet


/*/{Protheus.doc} z05bPos()
		2: Validar se a data final é maior que a data inicial.                                                             
	@type  Function
	@author Cárita
	@since 08/04/2025
/*/
User Function z05bPos()
    Local oModelPad  := FWModelActive()
	Local cDataIni 	 := oModelPad:GetValue('ZE1MASTER', 'ZE1_DT')
	Local cDataFin	 := oModelPad:GetValue('ZE1MASTER', 'ZE1_DTFINA')
	Local lRet := .T.

	//Validação
	If cDataFin < cDataIni
        Help(, , "Help", , "Data Inválida!", 1, 0, , , , , , {"Data <b>Finalizar</b> não pode ser menor que a <b>Data Inicial</b>"})
        lRet := .F.	
	EndIf
	
Return lRet
