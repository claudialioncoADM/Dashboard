#include "rwmake.ch"

user function ML_SRArea (_aAreaRest)
   local _aAreaAnt := {}
   local _nAlias   := 0
   local _xRet
   local _aAreaAtu := getarea ()
                         
   // Se nao recebi a area a restaurar, entao presumo que seja para salvar.
   if valtype (_aAreaRest) == "U"
      aadd (_aAreaAnt, {alias (), indexord (), recno ()})  // O primeiro eh o alias atual
      _nAlias = 1
      dbselectarea (_nAlias)
      do while alias () != ""
         if ascan (_aAreaAnt, {|_aVal| _aVal [1] == alias ()}) == 0
            aadd (_aAreaAnt, {alias (), indexord (), recno ()})
         endif
         _nAlias ++
         dbselectarea (_nAlias)
      enddo
      _xRet := _aAreaAnt
      restarea (_aAreaAtu)

   elseif valtype (_aAreaRest) == "A"
      for _nAlias = len (_aAreaRest) to 1 step -1  // Restaura "de re'", eh claro...
         _sAlias = _aAreaRest [_nAlias, 1]
         if ! empty (_sAlias) .and. select (_sAlias) != 0  // Algum arquivo pode nao estar mais aberto.
            dbselectarea (_sAlias)
            dbsetorder (_aAreaRest [_nAlias, 2])
            dbgoto (_aAreaRest [_nAlias, 3])
         endif
      next
      _xRet := NIL

   else
      msgbox (procname () + ": parametro incorreto recebido da funcao " + procname (1))
   endif

return _xRet

