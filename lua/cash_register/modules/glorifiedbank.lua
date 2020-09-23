local tr = PxlCashRegister.Language.GetDictionary("main")
local Modules = PxlCashRegister.Modules

if SERVER then
	Modules.Payments.GlorifiedBank = {
		Name = "Glorified Bank",
		Type = "credit",
		Pay = function(self, ply, amount, info, callback)
			if !ply:CanAffordBank( amount ) then
				callback("you_not_enough_money")
				return
			end

			local succ, err = info.dont_pay_machine or self:AddCredit(amount)

			if succ then
				ply:RemoveBankBalance( amount )

				callback()
			elseif err then
				callback(err)
			end
		end
	}

	Modules.Transfers.GlorifiedBank = {
		Name = "Glorified Bank",
		Type = "credit",
		Transfer = function(self, ply, amount, info, callback)
			if ply:CanAffordBank( amount ) then
				local succ, err = self:AddCredit(-amount)

				if succ then
					ply:AddBankBalance( amount )

					callback()
				elseif err then
					callback(err)
				end
			else
				callback("not_enough_money")
			end
		end
	}
end
