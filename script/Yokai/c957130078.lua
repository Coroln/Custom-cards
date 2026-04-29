local s,id=GetID()
function s.initial_effect(c)
    Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_YOKAI),1,1,Synchro.NonTuner(nil),1,99)
end
