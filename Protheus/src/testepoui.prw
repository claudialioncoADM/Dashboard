
#include "protheus.ch"

User Function testepoui()
    Private cPerg := 'POUItestepoui'

	_ValidPerg ()
	Pergunte (cPerg, .T.)

	Do Case
	Case mv_par01 == 1
		Fwcallapp("my-po-project")
	Case mv_par01 == 2
		Fwcallapp("calculadora")
	Case mv_par01 == 3
		Fwcallapp("Dashboard")
	Case mv_par01 == 4
		Fwcallapp("gerenciador-de-tarefas")
	EndCase
Return
//
// --------------------------------------------------------------------------
// Cria Perguntas no SX1
Static Function _ValidPerg ()
	local _aRegsPerg := {}
	//                     PERGUNT                 TIPO TAM DEC VALID F3        Opcoes Help
	aadd (_aRegsPerg, {01, "Tipo  ", "N", 1, 0,  "",   "   ", {"1-POUI Project","2-Calculadora","3-Dashboard","4-Gerenciador Tarefas"},    ""})

	U_ValPerg (cPerg, _aRegsPerg)
Return
