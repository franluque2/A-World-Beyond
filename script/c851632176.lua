--Storming Gate Guardians
Duel.LoadScript ("wb_aux.lua")
local s,id=GetID()
function s.initial_effect(c)
	local chk1=Effect.CreateEffect(c)
	chk1:SetType(EFFECT_TYPE_SINGLE)
	chk1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	chk1:SetCode(946)
	chk1:SetCondition(s.cusxyzCondition(nil,7,3))
	chk1:SetTarget(s.cusxyzTarget(nil,7,3))
	chk1:SetOperation(s.cusxyzOperation(nil,7,3))
	c:RegisterEffect(chk1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetDescription(1173)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.cusxyzCondition(nil,7,3))
	e1:SetTarget(s.cusxyzTarget(nil,7,3))
	e1:SetOperation(s.cusxyzOperation(nil,7,3))
	e1:SetValue(SUMMON_TYPE_XYZ)
	e1:SetLabelObject(chk1)
	c:RegisterEffect(e1)
    
    c:EnableReviveLimit()

    local e0=Effect.CreateEffect(c)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e0:SetRange(LOCATION_EXTRA)
	e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(id)
	e0:SetTargetRange(LOCATION_SZONE,0)
    e0:SetTarget(function(e,c) return c:IsType(TYPE_SPELL) and c:IsOriginalType(TYPE_MONSTER) and c:GetOriginalLevel()==7 end)
    e0:SetValue(7)
	c:RegisterEffect(e0)


    	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id)
	e2:SetCondition(function(e) return e:GetHandler():IsXyzSummoned() end)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)

		local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(3,{id,1})
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(s.condition)
	e3:SetCost(Cost.DetachFromSelfFromSelf(1))
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)

    local eaux3=Effect.CreateEffect(c)
    eaux3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    eaux3:SetCode(EVENT_TO_GRAVE)
    eaux3:SetRange(LOCATION_MZONE)
    eaux3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
        return eg:IsExists(Card.IsCode,1,nil,{CARD_SANGA_OF_THE_THUNDER,CARD_KAZEJIN,CARD_SUIJIN}) and eg:GetFirst():IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_XYZ)
		and eg:GetFirst():IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler()==e:GetHandler() end)
    eaux3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
        local c=e:GetHandler()
        if c:IsFaceup() then
            c:RegisterFlagEffect(id, RESETS_STANDARD+RESET_CHAIN, 0, 0)
        end
    end)
    c:RegisterEffect(eaux3)

    	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(s.spcon)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)

end
s.listed_names={CARDS_SANGA_KAZEJIN_SUIJIN}

function s.thfilter(c)
    return (c:IsCode(CARDS_SANGA_KAZEJIN_SUIJIN) or (c:ListsCode(CARD_SANGA_OF_THE_THUNDER) and c:ListsCode(CARD_KAZEJIN) and c:ListsCode(CARD_SUIJIN))) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
         return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,eg,1,tp,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=eg:GetFirst()
    if not tc or not tc:IsFaceup() then return end
    local atk=tc:GetAttack()
    if atk<=0 then return end
    Duel.HintSelection(eg)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_ATTACK_FINAL)
    e1:SetValue(0)
    e1:SetReset(RESETS_STANDARD)
    tc:RegisterEffect(e1)
    
    if e:GetHandler():GetFlagEffect(id)>0 then
        Duel.NegateEffect(ev)
    end

end


function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local trig_loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return ep==1-tp and re:IsMonsterEffect() and trig_loc&(LOCATION_MZONE|LOCATION_GRAVE)>0 and re:GetHandler():GetAttack()>0
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsSpecialSummoned() and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousControler(tp) and rp==1-tp
end
function s.spfilter(c,e,tp)
	if not (c:IsLevel(9) and c:IsSetCard(SET_GATE_GUARDIAN) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)) then return false end
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end

-- rewriting some xyz things to make this work
function s.cusxyzMatFilter2(c,f,lv,xyz,tp)
	if f and not f(c,xyz,SUMMON_TYPE_XYZ|MATERIAL_XYZ,tp) then return false end
	if lv and not c:IsXyzLevel(xyz,lv) then return false end
	return c:IsCanBeXyzMaterial(xyz,tp)
end
function s.cusxyzGetMaterials(tp,xyz)
	return Duel.GetMatchingGroup(function(c)
		if c:IsLocation(LOCATION_GRAVE) and not (c:IsHasEffect(EFFECT_XYZ_MAT_FROM_GRAVE)) then return false end
		if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return false end
		return (c:IsControler(tp) or Xyz.EffectXyzMaterialChk(c,xyz,tp))
	end,tp,LOCATION_MZONE|LOCATION_GRAVE,LOCATION_MZONE,nil)
end
function s.cusxyzMatFilter(c,f,lv,xyz,tp)
	return (c:IsControler(tp) or Xyz.EffectXyzMaterialChk(c,xyz,tp)) and s.cusxyzMatFilter2(c,f,lv,xyz,tp)
end
function s.cusxyzSubMatFilter(c,lv,xyz,tp)
	if not lv then return false end
	local te=c:GetCardEffect(EFFECT_SPELL_XYZ_MAT)
    if not te then
        te=c:GetCardEffect(id)
    end
	if not te then return false end
	local f
    if type(te)=='number'then
        f=te
    else
        f=te:GetValue()
    end
	if type(f)=='function' then
		if f(te)~=lv then return false end
	else
		if f~=lv then return false end
	end
	return true
end
function s.cusxyzCheckValidMultiXyzMaterial(effs,xyz,matg)
	for i,te in ipairs(effs) do
		local tgf=te:GetOperation()
		if not tgf or tgf(te,xyz,matg) then return true end
	end
	return false
end
function s.cusxyzMatNumChk(matct,ct,comp)
	if (comp&0x1)==0x1 and matct>ct then return true end
	if (comp&0x2)==0x2 and matct==ct then return true end
	if (comp&0x4)==0x4 and matct<ct then return true end
	return false
end
function s.cusxyzMatNumChkF(tg)
	for chkc in tg:Iter() do
		for _,te in ipairs({chkc:GetCardEffect(EFFECT_STAR_SERAPH_SOVEREIGNTY)}) do
			local rct=te:GetValue()&0xffff
			local comp=(te:GetValue()>>16)&0xffff
			if not s.cusxyzMatNumChk(tg:FilterCount(Card.IsMonster,nil),rct,comp) then return false end
		end
	end
	return true
end
function s.cusxyzMatNumChkF2(tg,lv,xyz)
	for chkc in tg:Iter() do
		local rev={}
		for _,te in ipairs({chkc:GetCardEffect(EFFECT_SATELLARKNIGHT_CAPELLA)}) do
			local rct=te:GetValue()&0xffff
			local comp=(te:GetValue()>>16)&0xffff
			if not s.cusxyzMatNumChk(tg:FilterCount(Card.IsMonster,nil),rct,comp) then
				local con=te:GetLabelObject():GetCondition()
				if not con then con=aux.TRUE end
				if not rev[te] then
					table.insert(rev,te)
					rev[te]=con
					te:GetLabelObject():SetCondition(aux.FALSE)
				end
			end
		end
		if #rev>0 then
			local islv=chkc:IsXyzLevel(xyz,lv)
			for _,te in ipairs(rev) do
				local con=rev[te]
				te:GetLabelObject():SetCondition(con)
			end
			if not islv then return false end
		end
	end
	return true
end
function s.cusxyzCheckMaterialSet(matg,xyz,tp,exchk,mustg,lv)
	if not matg:Includes(mustg) then return false end
	if not s.cusxyzMatNumChkF(matg) then
		return false
	end
	if lv and not s.cusxyzMatNumChkF2(matg,lv,xyz) then
		return false
	end
	if exchk and #matg>0 and not exchk(matg,tp,xyz) then
		return false
	end
	if xyz:IsLocation(LOCATION_EXTRA) then
		return Duel.GetLocationCountFromEx(tp,tp,matg,xyz)>0
	end
	return Duel.GetMZoneCount(tp,matg,tp)>0
end
function s.cusxyzRecursionChk(c,mg,xyz,tp,min,max,minc,maxc,sg,matg,ct,matct,mustbemat,exchk,f,mustg,lv,eqmg,equips_inverse)
	local addToMatg=true
	if eqmg and eqmg:IsContains(c) then
		if not sg:IsContains(c:GetEquipTarget()) then return false end
		addToMatg=false
	end
	local xct=ct
	local rg=Group.CreateGroup()
	if not c:IsHasEffect(EFFECT_ORICHALCUM_CHAIN) then
		xct=xct+1
	else
		addToMatg=true
	end
	local xmatct=matct+1
	if (max and xct>max) or (maxc~=Xyz.InfiniteMats and xmatct>maxc) then mg:Merge(rg) return false end
	for i,f in ipairs({c:GetCardEffect(EFFECT_XYZ_MAT_RESTRICTION)}) do
		if matg:IsExists(Auxiliary.HarmonizingMagFilter,1,c,f,f:GetValue()) then
			mg:Merge(rg)
			return false
		end
		local sg2=mg:Filter(Auxiliary.HarmonizingMagFilter,nil,f,f:GetValue())
		rg:Merge(sg2)
		mg:Sub(sg2)
	end
	for tc in sg:Iter() do
		for i,f in ipairs({tc:GetCardEffect(EFFECT_XYZ_MAT_RESTRICTION)}) do
			if Auxiliary.HarmonizingMagFilter(c,f,f:GetValue()) then
				mg:Merge(rg)
				return false
			end
		end
	end
	if addToMatg then
		matg:AddCard(c)
	end
	sg:AddCard(c)
	local eqg=nil
	local res=(function()
		if (xct>=min and xmatct>=minc) and s.cusxyzCheckMaterialSet(matg,xyz,tp,exchk,mustg,lv) then return true end
		if equips_inverse then
			eqg=equips_inverse[c]
			if eqg then
				mg:Merge(eqg)
			end
		end
		if mg:IsExists(s.cusxyzRecursionChk,1,sg,mg,xyz,tp,min,max,minc,maxc,sg,matg,xct,xmatct,mustbemat,exchk,f,mustg,lv,eqmg,equips_inverse) then return true end
		if not mustbemat then
			local retchknum={}
			for i,te in ipairs({c:IsHasEffect(EFFECT_DOUBLE_XYZ_MATERIAL,tp)}) do
				local tgf=te:GetOperation()
				local val=te:GetValue()
				if val>0 and not retchknum[val] and (not maxc or xmatct+val<=maxc) and (not tgf or tgf(te,xyz,matg)) then
					retchknum[val]=true
					te:UseCountLimit(tp)
					local chk=(xct+val>=min and xmatct+val>=minc and s.cusxyzCheckMaterialSet(matg,xyz,tp,exchk,mustg,lv))
								or mg:IsExists(s.cusxyzRecursionChk,1,sg,mg,xyz,tp,min,max,minc,maxc,sg,matg,xct,xmatct+val,mustbemat,exchk,f,mustg,lv,eqmg,equips_inverse)
					te:RestoreCountLimit(tp)
					if chk then return true end
				end
			end
		end
		return false
	end)()
	if addToMatg then
		matg:RemoveCard(c)
	end
	sg:RemoveCard(c)
	if eqg then
		mg:Sub(eqg)
	end
	mg:Merge(rg)
	return res
end
function Auxiliary.HarmonizingMagFilterXyz(c,e,f)
	return not f or f(e,c) or c:IsHasEffect(EFFECT_ORICHALCUM_CHAIN) or c:IsHasEffect(EFFECT_EQUIP_SPELL_XYZ_MAT)
end
function s.cusxyzCondition(f,lv,minc,maxc,mustbemat,exchk)
	--og: use specific material
	return function(e,c,must,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg
				local g
				local eqmg
				local equips_inverse
				if og then
					g=og
					mg=og:Filter(s.cusxyzMatFilter,nil,f,lv,c,tp)
				else
					g=s.cusxyzGetMaterials(tp,c)
					mg=g:Filter(s.cusxyzMatFilter2,nil,f,lv,c,tp)
					if not mustbemat then
						for tc in aux.Next(mg) do
							local eq=tc:GetEquipGroup():Filter(Card.IsHasEffect,nil,EFFECT_EQUIP_SPELL_XYZ_MAT)
							if #eq~=0 then
								if not equips_inverse then
									eqmg=Group.CreateGroup()
									equips_inverse={}
								end
								equips_inverse[tc]=eq
								eqmg:Merge(eq)
							end
						end
						if eqmg then
							mg:Merge(eqmg)
						end
						if not f then
							mg:Merge(Duel.GetMatchingGroup(s.cusxyzSubMatFilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,lv,c,tp))
						end
					end
				end
				local mustg=Auxiliary.GetMustBeMaterialGroup(tp,g,tp,c,mg,REASON_XYZ)
				if must then mustg:Merge(must) end
				if not mg:Includes(mustg) then return false end
				if not mustbemat then
					mg:Merge(Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,EFFECT_ORICHALCUM_CHAIN))
				end
				min=min or 0
				return mg:IsExists(s.cusxyzRecursionChk,1,nil,mg,c,tp,min,max,minc,maxc,Group.CreateGroup(),Group.CreateGroup(),0,0,mustbemat,exchk,f,mustg,lv,eqmg,equips_inverse)
			end
end
function s.cusxyzTarget(f,lv,minc,maxc,mustbemat,exchk)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,c,must,og,min,max)
				local cancel=not og and Duel.IsSummonCancelable()
				local mg
				local eqmg
				local equips_inverse
				if og then
					g=og
					mg=og:Filter(s.cusxyzMatFilter,nil,f,lv,c,tp)
				else
					g=s.cusxyzGetMaterials(tp,c)
					mg=g:Filter(s.cusxyzMatFilter2,nil,f,lv,c,tp)
					if not mustbemat then
						for tc in aux.Next(mg) do
							local eq=tc:GetEquipGroup():Filter(Card.IsHasEffect,nil,EFFECT_EQUIP_SPELL_XYZ_MAT)
							if #eq~=0 then
								if not equips_inverse then
									eqmg=Group.CreateGroup()
									equips_inverse={}
								end
								equips_inverse[tc]=eq
								eqmg:Merge(eq)
							end
						end
						if eqmg then
							mg:Merge(eqmg)
						end
						if not f then
							mg:Merge(Duel.GetMatchingGroup(s.cusxyzSubMatFilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,lv,c,tp))
						end
					end
				end
				local mustg=Auxiliary.GetMustBeMaterialGroup(tp,g,tp,c,mg,REASON_XYZ)
				if must then mustg:Merge(must) end
				local orichalcumGroup
				if not mustbemat then
					orichalcumGroup=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,EFFECT_ORICHALCUM_CHAIN)
					mg:Merge(orichalcumGroup)
				end
				if (not orichalcumGroup or #orichalcumGroup==0) and (must and #must==min and #must==max) then
					e:SetLabelObject(mustg:Clone():KeepAlive())
					return true
				end
				do
					local extra_mats=0
					min=min or 0
					local matg=Group.CreateGroup()
					local sg=Group.CreateGroup()
					local multiXyzSelectedCards={}
					local finishable=false
					while true do
						local ct=#matg
						local matct=ct+extra_mats
						if not ((not max or #matg<max) and (maxc==Xyz.InfiniteMats or matct<maxc)) then break end
						local selg=mg:Filter(s.cusxyzRecursionChk,sg,mg,c,tp,min,max,minc,maxc,sg,matg,ct,matct,mustbemat,exchk,f,mustg,lv,eqmg,equips_inverse)
						if #selg==0 then break end
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
						local cancelable=not og and Duel.IsSummonCancelable() and #sg==0
						local sc=Group.SelectUnselect(selg,sg,tp,finishable,cancelable)
						if not sc then
							if not finishable then return false end
							break
						end
						if not sg:IsContains(sc) then
							sg:AddCard(sc)
							if equips_inverse and equips_inverse[sc] then
								mg:Merge(equips_inverse[sc])
							end
							local multiXyz={sc:IsHasEffect(EFFECT_DOUBLE_XYZ_MATERIAL,tp)}
							if #multiXyz>0 and s.cusxyzCheckValidMultiXyzMaterial(multiXyz,c,matg) and ct<minc then
								matg:AddCard(sc)
								local multi={}
								if mg:IsExists(s.cusxyzRecursionChk,1,sg,mg,c,tp,min,max,minc,maxc,sg,matg,ct+1,matct+1,mustbemat,exchk,f,mustg,lv,eqmg,equips_inverse) then
									multi[1]={}
								end
								for i=1,#multiXyz do
									local te=multiXyz[i]
									local tgf=te:GetOperation()
									local val=te:GetValue()
									if val>0 and (not tgf or tgf(te,c,matg)) then
										local newCount=matct+1+val
										te:UseCountLimit(tp)
										local chk=(minc<=newCount and newCount<=maxc and sg:Includes(mustg))
													or mg:IsExists(s.cusxyzRecursionChk,1,sg,mg,c,tp,min,max,minc,maxc,sg,matg,ct+1,newCount,mustbemat,exchk,f,mustg,lv,eqmg,equips_inverse)
										if chk then
											if not multi[1+val] then
												multi[1+val]={}
											end
											table.insert(multi[1+val],te)
										end
										te:RestoreCountLimit(tp)
									end
								end
								local availableNumbers={}
								for k in pairs(multi) do
									table.insert(availableNumbers,k)
								end
								if #availableNumbers>0 then
									local chosen=availableNumbers[1]
									if #availableNumbers~=1 then
										table.sort(availableNumbers)
										Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
										chosen=Duel.AnnounceNumber(tp,availableNumbers)
									end
									if chosen>1 then
										local eff=multi[chosen][1]
										extra_mats=extra_mats+chosen-1
										eff:UseCountLimit(tp)
										multiXyzSelectedCards[sc]={eff,chosen}
									end
								end
							elseif sc:IsHasEffect(EFFECT_ORICHALCUM_CHAIN) then
								extra_mats=extra_mats+1
							else
								matg:AddCard(sc)
							end
						else
							if equips_inverse and equips_inverse[sc] then
								local equips=equips_inverse[sc]
								if sg:Includes(equips) then
									goto continue
								end
								mg:Sub(equips)
							end
							sg:RemoveCard(sc)
							if sc:IsHasEffect(EFFECT_ORICHALCUM_CHAIN) then
								extra_mats=extra_mats-1
							else
								matg:RemoveCard(sc)
								local multiXyzSelection=multiXyzSelectedCards[sc]
								if multiXyzSelection then
									multiXyzSelectedCards[sc]=nil
									local eff,num=table.unpack(multiXyzSelection)
									eff:RestoreCountLimit(tp)
									extra_mats=extra_mats-(num-1)
								end
							end
						end
						finishable=#matg>=minc and s.cusxyzCheckMaterialSet(matg,c,tp,exchk,mustg,lv)
						::continue::
					end
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				end
				return false
			end
end
function s.cusxyzOperation(f,lv,minc,maxc,mustbemat,exchk)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,must,og,min,max)
				local g=e:GetLabelObject()
				if not g then return end
				local remg=g:Filter(Card.IsHasEffect,nil,EFFECT_ORICHALCUM_CHAIN)
				remg:ForEach(function(c) c:RegisterFlagEffect(511002115,RESET_EVENT+RESETS_STANDARD,0,0) end)
				g:Remove(Card.IsHasEffect,nil,EFFECT_ORICHALCUM_CHAIN):Remove(Card.IsHasEffect,nil,511002115)
				c:SetMaterial(g)
				Duel.Overlay(c,g,true)
				g:DeleteGroup()
			end
end