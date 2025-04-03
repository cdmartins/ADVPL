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
	Local bPos := Nil
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
