
local MessageBoxView = class("MessageBoxView", cc.load("mvc").ViewBase)

MessageBoxView.RESOURCE_FILENAME = "Platform/messageBox/MessageBox.csb"
MessageBoxView.RESOURCE_BINDING = {
    ["txt_title"] = {
        ["varname"] = "m_txt_title"
    },
    ["txt_content"] = {
        ["varname"] = "m_txt_content"
    },
    ["btn_cancel"] = {
        ["varname"] = "m_btn_cancel",
        ["events"] = {
            {
                event = "touch",
                method ="OnClickedCancelBtn"
            }
        }
    },
    ["btn_confirm"] = {
        ["varname"] = "m_btn_confirm",
        ["events"] = {
            {
                event = "touch",
                method ="OnClickedConfirmBtn"
            }
        }
    },
    ["btn_close"] = {
        ["varname"] = "m_btn_close",
        ["events"] = {
            {
                event = "touch",
                method ="OnClickedCloseBtn"
            }
        }
    },
    ["bmfTxt_cancel"] = {
        ["varname"] = "m_txt_cancel"
    },
    ["bmfTxt_confirm"] = {
        ["varname"] = "m_txt_confirm"
    }
}

local REGISTER_EVENTS = {
    cc.exports.define.EVENTS.SHOW_MSG,
}

local CONFIG = {
    title = "訊息標題",
    content = "訊息內容",
    confirmCB = function ()
        print("click confirm callback")
    end,
    cancelCB = function ()
        print("click cancel callback")
    end,
    btnPosType = 0, -- 0:取消+確認 1:只有確認
    cancelBtnText = "取消",
    confirmBtnText = "確認",
    showCloseBtn = false,
}

function MessageBoxView:onCreate()
    print("MessageBoxView:onCreate")

    self:Init()
    self:RegisterEvent()
end

function MessageBoxView:Init()
    print("MessageBoxView:Init")

    self.m_txt_title:setFontName( cc.exports.define.DEFAULT_FONT )
    self.m_txt_content:setFontName( cc.exports.define.DEFAULT_FONT )

    self.m_txt_cancel:setFontName( cc.exports.define.DEFAULT_FONT )
    self.m_txt_confirm:setFontName( cc.exports.define.DEFAULT_FONT )

    self.m_config = {}

    self:setVisible( false )
end

function MessageBoxView:RegisterEvent()
    print("MessageBoxView:RegisterEvent")

    local function eventHander( event )
        if event:getEventName() == tostring( cc.exports.define.EVENTS.SHOW_MSG ) then
            self:Show( event._usedata )
        end
    end

    for i, eventName in pairs( REGISTER_EVENTS ) do
        local listener = cc.EventListenerCustom:create( tostring(eventName), eventHander )
        local dispatcher = cc.Director:getInstance():getEventDispatcher()
        dispatcher:addEventListenerWithFixedPriority( listener, 10 )
    end
end

function MessageBoxView:OnEnter()
    print("MessageBoxView:OnEnter()")
    self.m_btnPositionChangeAction = cc.CSLoader:createTimeline( self.RESOURCE_FILENAME )
    self:runAction( self.m_btnPositionChangeAction )
    self.m_btnPositionChangeAction:gotoFrameAndPause( 0 )
end

function MessageBoxView:OnClickedCancelBtn( event )
    if event.name == "ended" then
        if self.m_config.cancelCB then
            self.m_config.cancelCB()
        end
        self:Hide()
    end
end

function MessageBoxView:OnClickedConfirmBtn( event )
    if event.name == "ended" then
        if self.m_config.confirmCB then
            self.m_config.confirmCB()
        end
        self:Hide()
    end
end

function MessageBoxView:OnClickedCloseBtn( event )
    if event.name == "ended" then
        self:Hide()
    end
end

function MessageBoxView:Show( config )
    self.m_config = config

    self.m_txt_title:setString( "" )
    self.m_txt_content:setString( "" )
    self.m_btnPositionChangeAction:gotoFrameAndPause( 0 )
    self.m_txt_cancel:setString( "取消" )
    self.m_txt_confirm:setString( "確認" )
    self.m_btn_close:setVisible( false )

    if self.m_config.title then
        self.m_txt_title:setString( self.m_config.title )
    end

    if self.m_config.content then
        self.m_txt_content:setString( self.m_config.content )
    end

    if self.m_config.btnPosType then
        self.m_btnPositionChangeAction:gotoFrameAndPause( self.m_config.btnPosType )
    end

    if self.m_config.cancelBtnText then
        self.m_txt_cancel:setString( self.m_config.cancelBtnText )
    end

    if self.m_config.confirmBtnText then
        self.m_txt_confirm:setString( self.m_config.confirmBtnText )
    end

    if self.m_config.showCloseBtn then
        self.m_btn_close:setVisible( true )
    end

    self:setVisible( true )
end

function MessageBoxView:Hide()
    self:setVisible( false )
end

return MessageBoxView
