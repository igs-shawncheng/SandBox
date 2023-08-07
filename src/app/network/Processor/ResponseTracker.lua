local ResponseTracker = class("ResponseTracker")

--[[
    處理command綁定，command逾時處理
]]
function ResponseTracker:ctor(trackResponseId, trackSecond)
    self.trackResponseId = trackResponseId
    self.trackSecond = trackSecond
end

--[[
    回傳true就刪除這個tracker
]]
function ResponseTracker:Update(delta)
    if self.trackSecond > delta then
        self.trackSecond = self.trackSecond - delta
        return false
    else
        --response time out
        print("ResponseTracker.Update TimeOut", self.trackResponseId)
        return true
    end
end

cc.ResponseTracker = ResponseTracker
return ResponseTracker