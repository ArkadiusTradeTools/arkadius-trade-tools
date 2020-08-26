ArkadiusTradeToolsSalesGraph = ZO_Object:Subclass()

function ArkadiusTradeToolsSalesGraph:New(control, ...)
    local object = ZO_Object.New(self, ...)
    object.control = control
    object.minX = 0
    object.maxX = 0
    object.minY = 0
    object.maxY = 0
    object.drawArea = control:GetNamedChild("DrawArea")
    object.labelYTop = control:GetNamedChild("LabelYTop")
    object.labelYCenter = control:GetNamedChild("LabelYCenter")
    object.labelYBottom = control:GetNamedChild("LabelYBottom")
    object.labelXLeft = control:GetNamedChild("LabelXLeft")
    object.labelXCenter = control:GetNamedChild("LabelXCenter")
    object.labelXRight = control:GetNamedChild("LabelXRight")
    object.drawArea:SetColor(nil, 0, 1, 0, 1)
    object.numSurfaces = 0
    object.numDots = 0
    control.object = object
    return object
end

function ArkadiusTradeToolsSalesGraph:Clear()
    for i = 1, self.numSurfaces do
       self.drawArea:SetSurfaceHidden(i, true)
    end

    self.numDots = 0
end

function ArkadiusTradeToolsSalesGraph:SetRange(minX, maxX, minY, maxY)
    self.minX = minX or 0
    self.maxX = maxX or 0
    self.minY = minY or 0
    self.maxY = maxY or 0
end

function ArkadiusTradeToolsSalesGraph:SetXLabels(left, center, right)
    self.labelXLeft:SetText(left)
    self.labelXCenter:SetText(center)
    self.labelXRight:SetText(right)
end

function ArkadiusTradeToolsSalesGraph:SetYLabels(top, center, bottom)
    self.labelYTop:SetText(top)
    self.labelYCenter:SetText(center)
    self.labelYBottom:SetText(bottom)
end

function ArkadiusTradeToolsSalesGraph:AddDot(x, y, color)
    local drawAreaWidth, drawAreaHeight = self.drawArea:GetDimensions()
    local rangeX = self.maxX - self.minX

    local posX = x - self.minX
    local rangeY = self.maxY - self.minY
    local posY = self.maxY - y

    local left = drawAreaWidth / rangeX * posX
    local right = -(drawAreaWidth - left - 2)
    local top = drawAreaHeight / rangeY * posY
    local bottom = -(drawAreaHeight - top - 2)

    -- Serves as the index for our current surface
    self.numDots = self.numDots + 1

    if (self.numDots > self.numSurfaces) then
        self.drawArea:AddSurface(0.25, 0.75, 0.25, 0.75)
        self.numSurfaces = self.numSurfaces + 1
    else
        self.drawArea:SetSurfaceHidden(self.numDots, false)
    end

    self.drawArea:SetColor(self.numDots, color:UnpackRGBA())
    self.drawArea:SetInsets(self.numDots, left - 1, right - 1, top - 1, bottom - 1)
end
