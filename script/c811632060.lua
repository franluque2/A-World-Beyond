--There is a Stacker Among Us
local s,id=GetID()
function s.initial_effect(c)
	--Activate Skill
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(1)
	e1:SetRange(0x5f)
	e1:SetLabel(0)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)

    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PHASE+PHASE_DRAW)
    e2:SetCountLimit(1,id)
    e2:SetCondition(function() return Duel.GetTurnCount()==1 end)
    e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)  Duel.ShuffleDeck(0) Duel.ShuffleDeck(1) end)
    Duel.RegisterEffect(e2,0)

end

function s.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
        Duel.DisableShuffleCheck()
        Duel.Hint(HINT_CARD, tp, id)

        Duel.RegisterFlagEffect(tp, id, 0, 0, 0)

        Duel.SendtoDeck(e:GetHandler(), tp, -2, REASON_EFFECT)

        Duel.Hint(HINT_SKILL_COVER,tp,id|(300000000<<32))
        Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))



		end
	e:SetLabel(1)
end
