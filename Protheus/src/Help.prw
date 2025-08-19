user function Help (_sMsg, _sDAdic, _lHlpErro)
	local _nQuebra := 0
	local _sMsgLog := ''

	// Gera arquivo de log, se possivel.
	if ExistBlock ("LOG2")  // Se pode gerar arquivo de log
		
		// Verifica necessidade de formatar a mensagem para gravacao de log
		_sMsgLog = _sMsg
		if valtype (_sDAdic) == "C" .and. ! empty (_sDAdic)
			_sMsgLog += chr (13) + chr (10) + "Dados adicionais: " + _sDAdic
		endif
		_sMsgLog = strtran (_sMsgLog, chr (10), chr (13) + chr (10))  // Erros do SQL, por exemplo, tem apenas chr(10)
		_sMsgLog = strtran (_sMsgLog, chr (13) + chr (10), chr (13) + chr (10) + space (32))
		
		U_Log2 (iif (_lHlpErro, 'ERRO', 'Info'), '[' + procname () + '.' + procname (1) + '.' + procname (2) + '] ' + _sMsgLog)
	endif
	
	if ! _lHlpErro
		if type('_sMsgRetWS') == 'C'
			_sMsgRetWS := cValToChar(_sMsg)
		endif
	endif
	// Tratamentos em caso de mensagem de erro.
	_lHlpErro := iif (_lHlpErro == NIL, .F., _lHlpErro)
	if _lHlpErro != NIL .and. _lHlpErro
		if type ("_sErroAuto") == "C"  // Variavel private (customizada) para retorno de erros em rotinas automaticas.
			_sErroAuto += iif (empty (_sErroAuto), '', '; ') + cValToChar (_sMsg) + iif (valtype (_sDAdic) == "C", _sDAdic, "")
		endif
		if type ('_sErroWS') == 'C'  // Variavel private (customizada) geralmente usada em chamadas via web service.
			_sErroWS += iif (empty (_sErroWS), '', '; ') + cValToChar (_sMsg)
		endif
	endif

	if type ("_oBatch") == "O"
		_oBatch:Mensagens += iif (alltrim (_sMsg) $ _oBatch:Mensagens, '', '; ' + alltrim (_sMsg))
	endif

	if type ("oMainWnd") == "O"  // Se tem interface com o usuario
//		U_Log2 ('debug', '[' + procname () + ']tenho oMainWnd')
		if valtype (_sDAdic) == "C" .and. ! empty (_sDAdic) .and. existblock ("SHOWMEMO")
			U_ShowMemo (cValToChar (_sMsg) + chr (13) + chr (10) + chr (13) + chr (10) + "Dados adicionais:" + chr (13) + chr (10) + _sDAdic, procname (1) + " => " + procname (2))
		else
			// Se a mensagem for muito grande, quebra-a em varias linhas.
			if len (_sMsg) > 400 .and. ! chr (13) + chr (10) $ _sMsg
				_nQuebra = 400
				do while _nQuebra < len (_sMsg)
					_sMsg = left (_sMsg, _nQuebra) + chr (13) + chr (10) + substr (_sMsg, _nQuebra + 1)
					_nQuebra += 400
				enddo
			endif
			msgalert (_sMsg, procname (1) + " => " + procname (2) + " => " + procname (3) + " => " + procname (4) + " => " + procname (5))
		endif
	else
		if IsInCallStack ("SIGAACD")
		//	vtAlert (cValToChar (_sMsg), procname (), .t., 4000)  // Tempo em milissegundos
			_vtHelp (cValToChar (_sMsg), _lHlpErro)
		endif
	endif
return


// --------------------------------------------------------------------------
static function _vtHelp (_sMsg, _lHlpErro)
	local _cTela     := ''
	local _nLargTela := 39  // Por enquanto eh a unica tela que tenho...
	local _aLinhas   := {}

	_cTela := TerSave()
	TerCls()

	if _lHlpErro
		TerBeep (2)
	endif

	_aLinhas = U_QuebraTXT (_sMsg, _nLargTela - 2)
	//U_Log2 ('debug', _aLinhas)
	TeraChoice(,,,, _aLinhas)
	TerRestore(,,,,_cTela)
	//Function TeraChoice(nTop,nLeft,nBottom,nRight,aMenu,cFunct,nIniVetor,nIniW)
return
