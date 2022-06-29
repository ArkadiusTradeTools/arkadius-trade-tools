ArkadiusTradeTools.Templates = {}

-------------------------------------------------------------------------------
--------------------------- ArkadiusTradeToolsModule --------------------------
-------------------------------------------------------------------------------
local ArkadiusTradeToolsModule = ZO_Object:Subclass()
ArkadiusTradeTools.Templates.Module = ArkadiusTradeToolsModule

function ArkadiusTradeToolsModule:New(moduleName, moduleTitle, moduleVersion, moduleAuthor)
    local object = ZO_Object.New(self)
    object.NAME = moduleName
    object.TITLE = moduleTitle
    object.VERSION = moduleVersion
    object.AUTHOR = moduleAuthor

    return object
end

--- Meant to be averridden ---
function ArkadiusTradeToolsModule:Initialize(serverName, displayName)
end

--- meant to be averridden ---
function ArkadiusTradeToolsModule:Finalize()
end

--- meant to be averridden ---
function ArkadiusTradeToolsModule:GetSettingsMenu()
    return nil
end

-------------------------------------------------------------------------------
------------------------- ArkadiusTradeToolsObjectPool ------------------------
-------------------------------------------------------------------------------
ArkadiusTradeToolsObjectPool = ZO_Object:Subclass()

function ArkadiusTradeToolsObjectPool:New(factoryFunction)
    local object = ZO_Object.New(self)
    object.factoryFunction = factoryFunction
    object.free = {}
    object.used = {}

    return object
end

function ArkadiusTradeToolsObjectPool:AquireObject(...)
    local object
    local freeCount = #self.free

    if (freeCount == 0) then
        object = self.factoryFunction(...)
    else
        object = self.free[freeCount]
        self.free[freeCount] = nil
    end

    self.used[object] = object
    return object
end

function ArkadiusTradeToolsObjectPool:ReleaseObject(object)
    if ((object) and (self.used[object])) then
        self.used[object] = nil
        table.insert(self.free, object)
    end
end

-------------------------------------------------------------------------------
------------------------- ArkadiusTradeToolsTabWindow -------------------------
-------------------------------------------------------------------------------
local ArkadiusTradeToolsTabWindow = {}
ArkadiusTradeTools.Templates.TabWindow = ArkadiusTradeToolsTabWindow

function ArkadiusTradeToolsTabWindow:Initialize(control)
    ZO_ShallowTableCopy(self, control)
    control.tabs = {}
    control.buttonGroup = control:GetNamedChild("ButtonGroup")
end

function ArkadiusTradeToolsTabWindow:AddTab(frame, text, iconActive, iconInactive, iconCoords)
    if (frame == nil) then
        return
    end

    local tab = {}
    tab.frame = frame

    local i = 0
    repeat
        i = i + 1
    until (self:GetNamedChild("Button" .. i) == nil)

    tab.button = CreateControlFromVirtual(self:GetName() .. "Button" .. i, self.buttonGroup, "ArkadiusTradeToolsTabButton")
    tab.button:SetText(text)
    tab.button:SetIcons(iconActive, iconInactive)
    tab.button:SetFrame(frame)
    ZO_PreHookHandler(tab.button, "OnMouseUp", function(...) self:OnTabClicked(...) end)

    frame:SetParent(self)
    frame:ClearAnchors()
    frame:SetAnchor(TOPLEFT, self.buttonGroup, BOTTOMLEFT, 10, 0)
    frame:SetAnchor(BOTTOMRIGHT, self, BOTTOMRIGHT, -10, -34)

    if (iconCoords) then
        tab.button:SetIconCoords(iconCoords.left, iconCoords.right, iconCoords.top, iconCoords.bottom)
    end


    if (#self.tabs == 0) then
        tab.button:SetAnchor(TOPLEFT, self.buttonGroup, TOPLEFT)
        tab.button:SetAnchor(BOTTOMLEFT, self.buttonGroup, BOTTOMLEFT)
        tab.button:SetActive(true)
    else
        tab.button:SetAnchor(TOPLEFT, self.tabs[#self.tabs].button, TOPRIGHT)
        tab.button:SetAnchor(BOTTOMLEFT, self.tabs[#self.tabs].button, BOTTOMRIGHT)
        tab.button:SetActive(false)
    end

    table.insert(self.tabs, tab)
end

function ArkadiusTradeToolsTabWindow:RemoveTab(frame)
-- TODO
end

function ArkadiusTradeToolsTabWindow:OnTabClicked(tab, mouseButton, upInside)
    if ((mouseButton == MOUSE_BUTTON_INDEX_LEFT) and (upInside == true)) then
        for i = 1, #self.tabs do
            self.tabs[i].button:SetActive(tab == self.tabs[i].button)
        end
    end
end

-------------------------------------------------------------------------------
------------------------- ArkadiusTradeToolsTabButton -------------------------
-------------------------------------------------------------------------------
local ArkadiusTradeToolsTabButton = {}
ArkadiusTradeTools.Templates.TabButton = ArkadiusTradeToolsTabButton

function ArkadiusTradeToolsTabButton:Initialize(control)
    ZO_ShallowTableCopy(ArkadiusTradeToolsTabButton, control)

    control.textureActive = "ArkadiusTradeTools/ArkadiusTradeTools/img/tab_top_active.dds"
    control.textureInactive = "ArkadiusTradeTools/ArkadiusTradeTools/img/tab_top_inactive.dds"
    control.textureMouseOver = "ArkadiusTradeTools/ArkadiusTradeTools/img/tab_top_inactive_mouseover.dds"
    control.isActive = false
    control.icon = control:GetNamedChild("Icon")
end

function ArkadiusTradeToolsTabButton:SetText(text)
    self:GetNamedChild("Text"):SetText(text)
end

function ArkadiusTradeToolsTabButton:SetIcons(iconActive, iconInactive)
    self.iconActive = iconActive
    self.iconInactive = iconInactive
end

function ArkadiusTradeToolsTabButton:SetIcon(icon)
    if (self.icon) then
        self.icon:SetTexture(icon)
    end
end

function ArkadiusTradeToolsTabButton:SetIconCoords(left, right, top, bottom)
    if (self.icon) then
        self.icon:SetTextureCoords(left, right, top, bottom)
    end
end

function ArkadiusTradeToolsTabButton:SetFrame(frame)
    self.frame = frame

    if (frame) then
        frame:SetHidden(not self.isActive)
    end
end

function ArkadiusTradeToolsTabButton:SetActive(active)
    if (active) then
        self:GetNamedChild("Left"):SetTexture(self.textureActive)
        self:GetNamedChild("Center"):SetTexture(self.textureActive)
        self:GetNamedChild("Right"):SetTexture(self.textureActive)
        self:GetNamedChild("Text"):SetColor(1, 1, 1, 1)
        self:SetIcon(self.iconActive)
    else
        self:GetNamedChild("Left"):SetTexture(self.textureInactive)
        self:GetNamedChild("Center"):SetTexture(self.textureInactive)
        self:GetNamedChild("Right"):SetTexture(self.textureInactive)
        self:GetNamedChild("Text"):SetColor(0.5, 0.5, 0.5, 1)
        self:SetIcon(self.iconInactive)
    end

    if (self.frame) then
        self.frame:SetHidden(not active)
    end

    self.isActive = active
end

function ArkadiusTradeToolsTabButton:OnMouseEnter()
    if (self.isActive == false) then
        self:GetNamedChild("Left"):SetTexture(self.textureMouseOver)
        self:GetNamedChild("Center"):SetTexture(self.textureMouseOver)
        self:GetNamedChild("Right"):SetTexture(self.textureMouseOver)
    end
end

function ArkadiusTradeToolsTabButton:OnMouseExit()
    if (self.isActive == false) then
        self:GetNamedChild("Left"):SetTexture(self.textureInactive)
        self:GetNamedChild("Center"):SetTexture(self.textureInactive)
        self:GetNamedChild("Right"):SetTexture(self.textureInactive)
    end
end

-------------------------------------------------------------------------------
----------------------- ArkadiusTradeToolsToggleButton ------------------------
-------------------------------------------------------------------------------
ArkadiusTradeToolsToggleButton = {}

function ArkadiusTradeToolsToggleButton:New(control)
    ZO_ShallowTableCopy(self, control)
    control:SetHandler("OnClicked", function(mouseButton) control:OnClicked(mouseButton) end)
end

function ArkadiusTradeToolsToggleButton:SetPressed(pressed, forceCallback)
    local state = self:GetState()

    if (pressed) then
        self:SetState(BSTATE_PRESSED, true)
    else
        self:SetState(BSTATE_NORMAL, true)
    end

    if ((state ~= self:GetState()) or (forceCallback)) then
        self:OnToggle(pressed)
    end
end

function ArkadiusTradeToolsToggleButton:IsPressed()
    return (self:GetState() == BSTATE_PRESSED)
end

function ArkadiusTradeToolsToggleButton:OnClicked(mouseButton)
    if (self:GetState() == BSTATE_NORMAL) then
        self:SetState(BSTATE_PRESSED, true)
    else
        self:SetState(BSTATE_NORMAL, true)
    end

    self:OnToggle(self:GetState() == BSTATE_PRESSED)
end

function ArkadiusTradeToolsToggleButton:SetTooltipText(text)
    self.tooltipText = text
end

--- meant to be overridden ---
function ArkadiusTradeToolsToggleButton:OnToggle(pressed)
end

-------------------------------------------------------------------------------
------------------------ ArkadiusTradeToolsSortHeader -------------------------
-------------------------------------------------------------------------------
local ArkadiusTradeToolsSortHeader = {}
ArkadiusTradeTools.Templates.SortHeader = ArkadiusTradeToolsSortHeader

function ArkadiusTradeToolsSortHeader:Initialize(control, text, key, sortOrder, textAlignment, font)
    ZO_ShallowTableCopy(self, control)
    ZO_SortHeader_Initialize(control, text, key, sortOrder, textAlignment, font)

    control.switch = control:GetNamedChild("Switch")
    control.name = control:GetNamedChild("Name")

    if (control.switch) then
        local textWidth = control.name:GetTextWidth()

        control.switch:ClearAnchors()
        control.switch:SetAnchor(RIGHT, control, CENTER, -(textWidth / 2) - 3, 0)
    end
end

-------------------------------------------------------------------------------
---------------------- ArkadiusTradeToolsSortHeaderGroup ----------------------
-------------------------------------------------------------------------------
local ArkadiusTradeToolsSortHeaderGroup = ZO_SortHeaderGroup:Subclass()

function ArkadiusTradeToolsSortHeaderGroup:New(headerContainer, showArrows)
    return ZO_SortHeaderGroup.New(self, headerContainer, showArrows)
end

function ArkadiusTradeToolsSortHeaderGroup:SelectHeader(header)  
    ZO_SortHeaderGroup.SelectHeader(self, header)

    if (self.showArrows) then 
        local nameControl = header:GetNamedChild("Name")
        self.arrowTexture:ClearAnchors()

        if (nameControl:GetHorizontalAlignment() == TEXT_ALIGN_RIGHT) then
            self.arrowTexture:SetAnchor(LEFT, header, LEFT, 10, 0)
        else
            self.arrowTexture:SetAnchor(RIGHT, header, RIGHT, -10, 0)
        end

        --if(self.sortDirection == ZO_SORT_ORDER_UP) then
        --    self.arrowTexture:SetTexture("/esoui/art/tooltips/arrow_up.dds")
        --else
        --    self.arrowTexture:SetTexture("/esoui/art/tooltips/arrow_down.dds")
        --end
    end

    local background = header:GetNamedChild("Background")

    if(background) then
        background:SetTexture("ArkadiusTradeTools/ArkadiusTradeTools/img/blade_closed_down.dds")
    end
end

function ArkadiusTradeToolsSortHeaderGroup:DeselectHeader()
    if (self.selectedSortHeader) then
        local background = self.selectedSortHeader:GetNamedChild("Background")

        if (background) then
            background:SetTexture("ArkadiusTradeTools/ArkadiusTradeTools/img/blade_closed_up.dds")
        end
    end

    ZO_SortHeaderGroup.DeselectHeader(self)
end

function ArkadiusTradeToolsSortHeaderGroup:AddHeader(header)
    ZO_SortHeaderGroup.AddHeader(self, header)

    local function OnHeaderVisibilityChanged(header, hidden)
        if (self.selectedSortHeader == header) then
            self.arrowTexture:SetHidden(hidden)
        end

        if (hidden) then
            self:OnHeaderHide(header)
        else
            self:OnHeaderShow(header)
        end
    end

    header:SetHandler("OnShow", OnHeaderVisibilityChanged)
    header:SetHandler("OnHide", OnHeaderVisibilityChanged)
end

function ArkadiusTradeToolsSortHeaderGroup:OnHeaderClicked(header, suppressCallbacks, forceReselect)
    if (header.key == "headerSettings") then
        ClearMenu()

        for i = 1, self.headerContainer:GetNumChildren() do
            local header = self.headerContainer:GetChild(i)

            if ((header.key) and (header.key ~= "headerSettings")) then
                local headerName = header:GetNamedChild("Name"):GetText()
                local itemIndex = AddMenuItem(headerName, function(item, checked) item.header:SetHidden(not checked) end, MENU_ADD_OPTION_CHECKBOX)

                ZO_Menu.items[itemIndex].checkbox.header = header
                ZO_CheckButton_SetCheckState(ZO_Menu.items[itemIndex].checkbox, not header:IsHidden())
            end
        end

        ShowMenu(self)

        return
    end

    ZO_SortHeaderGroup.OnHeaderClicked(self, header, suppressCallbacks, forceReselect)
end

--- meant to be averridden ---
function ArkadiusTradeToolsSortHeaderGroup:OnHeaderShow(header)
end

--- meant to be averridden ---
function ArkadiusTradeToolsSortHeaderGroup:OnHeaderHide(header)
end

-------------------------------------------------------------------------------
---------------------- ArkadiusTradeToolsSortFilterList -----------------------
-------------------------------------------------------------------------------
ArkadiusTradeToolsSortFilterList = ZO_SortFilterList:Subclass()
ArkadiusTradeToolsSortFilterList.Filter = ZO_Object:Subclass()

function ArkadiusTradeToolsSortFilterList:New(parent, ...)
    local object = ZO_SortFilterList.New(self, ...)
    object.parent = parent
    object.masterList = {}
    object.updateFilterList = {}
    object.updateSortList = {}

--    object.Filter = ZO_Object.New(self.Filter)
    object.Filter = {}
    ZO_ShallowTableCopy(self.Filter, object.Filter)

    return object
end

function ArkadiusTradeToolsSortFilterList:GetMasterList()
    return self.masterList
end

function ArkadiusTradeToolsSortFilterList:UpdateMasterList(data)
    local entry = ZO_ScrollList_CreateDataEntry(1, {rawData = data})
    self.masterList[#self.masterList + 1] = entry
    self.updateFilterList[#self.updateFilterList + 1] = entry
end

function ArkadiusTradeToolsSortFilterList:InitializeSortFilterList(control)
    self.control = control
    self.list = control:GetNamedChild("List") 
    ZO_ScrollList_AddResizeOnScreenResize(self.list)
    self:SetUpdateInterval(1)

    self.headersContainer = control:GetNamedChild("Headers")
    if(self.headersContainer) then
        self.sortHeaderGroup = ArkadiusTradeToolsSortHeaderGroup:New(self.headersContainer, true)
        self.sortHeaderGroup:RegisterCallback(ZO_SortHeaderGroup.HEADER_CLICKED, function(key, order) self:OnSortHeaderClicked(key, order) end)
        self.sortHeaderGroup:AddHeadersFromContainer()
        self.sortHeaderGroup.OnHeaderShow = function(headerGroup, header, hidden) self:OnHeaderVisibilityChanged(headerGroup, header, hidden) end
        self.sortHeaderGroup.OnHeaderHide = function(headerGroup, header, hidden) self:OnHeaderVisibilityChanged(headerGroup, header, hidden) end
    end
end

--- Override this in a subclass ---
function ArkadiusTradeToolsSortFilterList:SetupFilters()
    return nil
end

function ArkadiusTradeToolsSortFilterList:FilterScrollList()
    local dataList
    self:SetupFilters()
    local filters = self.Filter:GetFilters()

    if (not filters.needsRefilter) then
        dataList = self.updateFilterList
    else        
        local scrollData = ZO_ScrollList_GetDataList(self.list)
        ZO_ClearNumericallyIndexedTable(scrollData)
        dataList = self.masterList
    end

    if ((filters) and (filters.keywords)) then
        for _, entry in pairs(dataList) do
            local data = entry.data.rawData
            local insert = false

            for i = 1, #filters.keys do
                for j = 1, #filters.keywords do
                    for key, func in pairs(filters.keys[i]) do
                        insert = false

                        if (data[key]) then
                            if (func(data[key], filters.keywords[j])) then
                                insert = true
                                break
                            end
                        end
                    end

			        if (not insert) then
                        break
                    end
                end

                if (not insert) then
                    break
                end
            end

            if (insert) then
                table.insert(self.updateSortList, entry)
            end

        end
    end

    self.updateFilterList = {}
end

function ArkadiusTradeToolsSortFilterList:SortScrollList()
    local function compare(value1, value2, tiebreaker1, tiebreaker2)
        if (self.currentSortOrder == ZO_SORT_ORDER_UP) then
            if value1 < value2 then return true end
            if value1 > value2 then return false end
            if ((tiebreaker1) and (tiebreaker2)) then
                return tiebreaker1 > tiebreaker2
            end
        else
            if value1 > value2 then return true end
            if value1 < value2 then return false end
            if ((tiebreaker1) and (tiebreaker2)) then
                return tiebreaker1 > tiebreaker2
            end
        end
    end

    if not ((self.currentSortKey) and (self.SORT_KEYS) and (self.SORT_KEYS[self.currentSortKey])) then
        return
    end

    local sortKey = self.SORT_KEYS[self.currentSortKey]

    local sortFunction = function(data1, data2)
        return compare(data1.data.rawData[sortKey.altKey or self.currentSortKey], data2.data.rawData[sortKey.altKey or self.currentSortKey], data1.data.rawData[sortKey.tiebreaker], data2.data.rawData[sortKey.tiebreaker])
    end

    local scrollData = ZO_ScrollList_GetDataList(self.list)

    if ((self.currentSortKey ~= self.previousSortKey) or (self.currentSortOrder ~= self.previousSortOrder)) then
        if (self.currentSortKey ~= self.previousSortKey) then
            table.sort(scrollData, sortFunction)
        else
            local d

            for i = 1, #scrollData / 2 do
                d = scrollData[i]
                scrollData[i] = scrollData[#scrollData - i + 1]
                scrollData[#scrollData - i + 1] = d
            end
        end

        self.previousSortKey = self.currentSortKey
        self.previousSortOrder = self.currentSortOrder
    end

	self.updateSortList = self.updateSortList or {}

    if (#scrollData == 0) then 
        for i, entry in pairs(self.updateSortList) do
            table.insert(scrollData, entry)
        end

        table.sort(scrollData, sortFunction)
    else
        if (#self.updateSortList > 0) then
            local insertAt
            local entry2

            if (self.currentSortOrder == ZO_SORT_ORDER_UP) then
                for i, entry1 in pairs(self.updateSortList) do
                    insertAt = 1

                    for j = #scrollData, 1, -1 do
                        entry2 = scrollData[j]

                        if (not sortFunction(entry1, entry2)) then
                            insertAt = j + 1

                            break
                        end
                    end

                    table.insert(scrollData, insertAt, entry1)
                end
            else
                for i, entry1 in pairs(self.updateSortList) do
                    insertAt = #scrollData + 1

                    for j = 1, #scrollData do
                        entry2 = scrollData[j]

                        if (sortFunction(entry1, entry2)) then
                            insertAt = j

                            break
                        end
                    end

                    table.insert(scrollData, insertAt, entry1)
                end
            end
        end
    end

   self.updateSortList = {}
end

function ArkadiusTradeToolsSortFilterList:SetupRow(row, data)
    local index = row:GetNamedChild("Index")
    index:SetText(data.sortIndex)

    ZO_SortFilterList.SetupRow(self, row, data)
end

function ArkadiusTradeToolsSortFilterList:IsHidden()
    return self.control:IsHidden()
end

function ArkadiusTradeToolsSortFilterList:OnHeaderVisibilityChanged(headerGroup, header, hidden)
    if ((self.headersContainer.Update) and (type(self.headersContainer.Update) == "function")) then
        self.headersContainer:Update()
    end

    self:CommitScrollList()
end

function ArkadiusTradeToolsSortFilterList.Filter:GetFilters()
    local filters = {}

    filters.keywords = self.keywords
    filters.keys = self.keyFuncs
    filters.needsRefilter = self.needsRefilter

    self.needsRefilter = false

    return filters
end

function ArkadiusTradeToolsSortFilterList.Filter:SetKeywords(keywords)
    if ((keywords == nil) or (#keywords == 0)) then
        keywords = {""}
    end

    if ((self.keywords == nil) or (#keywords ~= #self.keywords)) then
        self.keywords = keywords
        self.needsRefilter = true

        return
    end

    local needsRefilter = true

    for i = 1, #keywords do
        needsRefilter = true

        for j = 1, #self.keywords do
            if (keywords[i] == self.keywords[j]) then
                needsRefilter = false
                break
            end
        end

        if (needsRefilter == true) then
            break
        end
    end

    self.keywords = keywords

    if (not self.needsRefilter) then
        self.needsRefilter = needsRefilter
    end

end


function ArkadiusTradeToolsSortFilterList.Filter:SetKeyFunc(group, key, func)
    self.keyFuncs = self.keyFuncs or {}

    if (self.keyFuncs[group]) then
        if (self.keyFuncs[group][key]) then
            self.keyFuncs[group][key] = func

            if (func == nil) then
                self.needsRefilter = true
            end
        else
            self.keyFuncs[group][key] = func

            if (func ~= nil) then
                self.needsRefilter = true
            end
        end
    else
        self.keyFuncs[group] = {}
        self.keyFuncs[group][key] = func
        self.needsRefilter = true
    end
end

function ArkadiusTradeToolsSortFilterList.Filter:SetNeedsRefilter()
    self.needsRefilter = true
end
-------------------------------------------------------------------------------
--------------------------- ArkadiusTradeToolsSlider --------------------------
-------------------------------------------------------------------------------

ArkadiusTradeToolsSlider = ZO_Object:Subclass()

function ArkadiusTradeToolsSlider:New(control, ...)
    control.slider = ZO_Object.New(self)
    control.slider.control = control
    control.slider:Initialize(...)

	return control.slider
end

function ArkadiusTradeToolsSlider:Initialize(...)
    local control = self.control
    local sliderControl = control:GetNamedChild("Slider")
    local editControl = control:GetNamedChild("Edit")
    local minControl = control:GetNamedChild("Min")
    local maxControl = control:GetNamedChild("Max")

    self.minValue = tonumber(minControl:GetText()) or 0
    self.maxValue = tonumber(maxControl:GetText()) or 1
    self:SetValue(self.minValue)

    sliderControl:SetHandler("OnValueChanged", function(_, value) self:OnValueChanged(value) end)
    editControl:SetHandler("OnEnter", function(edit) edit:LoseFocus() self:OnValueChanged(tonumber(edit:GetText())) end)
end

function ArkadiusTradeToolsSlider:GetMinMax()
    return self.minValue, self.maxValue
end

function ArkadiusTradeToolsSlider:GetValue()
    return self.value
end

function ArkadiusTradeToolsSlider:GetText()
    local control = self.control
    local textControl = control:GetNamedChild("Text")

    return textControl:GetText()
end

function ArkadiusTradeToolsSlider:SetMinMax(minValue, maxValue)
    local control = self.control
    local sliderControl = control:GetNamedChild("Slider")
    local minControl = control:GetNamedChild("Min")
    local maxControl = control:GetNamedChild("Max")

    sliderControl:SetMinMax(minValue, maxValue)
    minControl:SetText(minValue)
    maxControl:SetText(maxValue)
    self.minValue = minValue
    self.maxValue = maxValue

    if (self:GetValue() < minValue) then
        self:SetValue(minValue)
    end

    if (self:GetValue() > maxValue) then
        self:SetValue(maxValue)
    end
end

function ArkadiusTradeToolsSlider:SetValue(value)
    if ((value < self.minValue) or (value > self.maxValue)) then
        return
    end

    local control = self.control
    local sliderControl = control:GetNamedChild("Slider")
    local editControl = control:GetNamedChild("Edit")

    editControl:SetText(value)
    sliderControl:SetValue(value)
    self.value = value
end

function ArkadiusTradeToolsSlider:SetText(text)
    local control = self.control
    local textControl = control:GetNamedChild("Text")

    textControl:SetText(text)
end

function ArkadiusTradeToolsSlider:OnValueChanged(value)
    if ((value < self.minValue) or (value > self.maxValue)) then
        return
    end

    self:SetValue(value)

    if ((self.control.OnValueChanged) and (type(self.control.OnValueChanged) == "function")) then
        self.control.OnValueChanged(self.control, value)
    end
end

-------------------------------------------------------------------------------
------------------------- ArkadiusTradeToolsFilterBar -------------------------
-------------------------------------------------------------------------------

ArkadiusTradeToolsFilterBar = {}
ArkadiusTradeToolsFilterBar.Time = {}
ArkadiusTradeToolsFilterBar.Text = {}
ArkadiusTradeToolsFilterBar.SubStrings = {}

function ArkadiusTradeToolsFilterBar:New(control, ...)
    ZO_ShallowTableCopy(self, control)
    control:Initialize(...)
end

function ArkadiusTradeToolsFilterBar:Initialize(...)
    local time = self.Time
    self.Time = self:GetNamedChild("Time")
    ZO_ShallowTableCopy(time, self.Time)

    local text = self.Text
    self.Text = self:GetNamedChild("Text")
    ZO_ShallowTableCopy(text, self.Text)

    local subStrings = self.SubStrings
    self.SubStrings = self:GetNamedChild("SubStrings")
    ZO_ShallowTableCopy(subStrings, self.SubStrings)

    self.Time.m_comboBox:SetSortsItems(false)

--    self.SubStrings:SetHandler("OnClicked", function(mouseButton) self.SubStrings.OnClicked(mouseButton) end)
end

function ArkadiusTradeToolsFilterBar.Time:AddItem(item)
    self.m_comboBox:AddItem(item)
end

function ArkadiusTradeToolsFilterBar.Time:GetSelectedItem()
    return self.m_comboBox:GetSelectedItemData()
end

function ArkadiusTradeToolsFilterBar.Time:GetSelectedIndex()
    local selectedItem = self:GetSelectedItem()

    for i = 1, #self.m_comboBox.m_sortedItems do
        local item = self.m_comboBox.m_sortedItems[i]
        if (item == selectedItem) then
            return i
        end
    end

    return 0
end

function ArkadiusTradeToolsFilterBar.Time:SelectByIndex(index)
    if ((index) and (index > 0) and (index <= self.m_comboBox:GetNumItems())) then
        self.m_comboBox:SelectItemByIndex(index)
    end
end

--- meant to be averridden ---
function ArkadiusTradeToolsFilterBar.SubStrings.OnToggle(pressed)
end

function ArkadiusTradeToolsFilterBar.SubStrings:SetTooltipText(text)
    self.tooltipText = text
end

function ArkadiusTradeToolsFilterBar.Text:GetStrings()
    local filterString = self:GetText()
    return {zo_strsplit(' ', string.lower(filterString))}
end

function ArkadiusTradeToolsFilterBar.Text:SetTooltipText(text)
    self.tooltipText = text
end


-------------------------------------------------------------------------------
------------------------ ArkadiusTradeToolsToolBar -------------------------
-------------------------------------------------------------------------------
local ArkadiusTradeToolsToolBar = {}
ArkadiusTradeTools.Templates.ToolBar = ArkadiusTradeToolsToolBar

function ArkadiusTradeToolsToolBar:Initialize(control)
    ZO_ShallowTableCopy(self, control)
end

-------------------------------------------------------------------------------
------------------------- ArkadiusTradeToolsTooltip -------------------------
-------------------------------------------------------------------------------
local ArkadiusTradeToolsTooltip = {}
ArkadiusTradeTools.Templates.Tooltip = ArkadiusTradeToolsTooltip

function ArkadiusTradeToolsTooltip:Initialize(control, content, point, offsetX, offsetY, relativePoint)
    control.tooltip = {}
    ZO_ShallowTableCopy(self, control.tooltip)

    control.tooltip.owner = control
    control.tooltip:SetContent(content)
    control.tooltip:SetPosition(point, offsetX, offsetY, relativePoint)
    
    ZO_PreHookHandler(control, "OnMouseEnter", function() control.tooltip:Show() end)
    ZO_PreHookHandler(control, "OnMouseExit", function() control.tooltip:Hide() end)
end

function ArkadiusTradeToolsTooltip:SetContent(content)
    self.content = content
end

function ArkadiusTradeToolsTooltip:SetPosition(point, offsetX, offsetY, relativePoint)
    self.point = point
    self.offsetX = offsetX
    self.offsetY = offsetY
    self.relativePoint = relativePoint
end

function ArkadiusTradeToolsTooltip:Show()
    if (self.content == nil) then
        return
    end

    InitializeTooltip(InformationTooltip, self.owner, self.point, self.offsetX, self.offsetY, self.relativePoint)

    if (type(self.content) == "string") then
        --InformationTooltip:AddLine(self.content)
        SetTooltipText(InformationTooltip, self.content)
    else
        InformationTooltip:AddControl(self.content, 0, false)
        self.content:SetAnchor(CENTER)
        self.content:SetHidden(false)
    end
end

function ArkadiusTradeToolsTooltip:Hide()
    ClearTooltip(InformationTooltip)
end

local ArkadiusTradeToolsEditBox = {}
ArkadiusTradeTools.Templates.EditBox = ArkadiusTradeToolsEditBox

function ArkadiusTradeToolsEditBox:Initialize(control)
    ZO_ShallowTableCopy(self, control)
    control:SetHandler('OnEnter', function(...) control:OnEnter(...) end)
    ArkadiusTradeTools.Templates.Tooltip:Initialize(control, nil, TOPLEFT, 0, 0, TOPRIGHT)
end

function ArkadiusTradeToolsEditBox:OnEnter()
    if ((self.OnChanged) and (type(self.OnChanged) == "function")) then
        self.OnChanged(self:GetText())
    end

    self:LoseFocus()
end

--- Small hack to create text string for key bindings ---
ZO_CreateStringId("SI_BINDING_NAME_ATT_TOGGLE_MAIN_WINDOW", ArkadiusTradeTools.Localization["ATT_STR_KEYBIND_TOGGLE_MAIN_WINDOW"])

