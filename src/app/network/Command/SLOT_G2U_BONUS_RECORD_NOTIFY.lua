require "app.network.Command.IDeserialize"
local SLOT_G2U_BONUS_RECORD_NOTIFY = class("SLOT_G2U_BONUS_RECORD_NOTIFY", cc.IDeserialize:create())

function SLOT_G2U_BONUS_RECORD_NOTIFY:ctor(content)
    self:Deserialize(content)
    --     self.BonusRecord = {}
    --     self.BonusRecord.accountId
    --     self.BonusRecord.bbCount
    --     self.BonusRecord.rbCount
    --     self.BonusRecord.sbbCount
end

cc.SLOT_G2U_BONUS_RECORD_NOTIFY = SLOT_G2U_BONUS_RECORD_NOTIFY