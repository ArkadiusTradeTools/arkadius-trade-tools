describe('ArkadiusTradeTools', function()
    before_each(function()
        expect = assert
        _G.EVENT_MANAGER = { }
        _G.EVENT_MANAGER.RegisterForEvent = spy.new(function() end)
        local eventManager = mock(_G.EVENT_MANAGER)
        require('esoui/esoui/libraries/utility/baseobject')
        require('esoui/esoui/libraries/utility/zo_callbackobject')
        require("ArkadiusTradeTools")
    end)

    describe('GetStartOfWeek', function()
        describe('on NA', function()
            before_each(function()
                _G.GetWorldName = function() return 'NA Megaserver' end
                _G.GetTimeStamp = function() return 1596405423 end
            end)

            after_each(function()
                _G.GetWorldName = nil            
                _G.GetTimeStamp = nil
            end)

            describe('when asking for the start of the current trader week', function()
                -- I'm not sure the fewer than tests are actually testing things properly
                describe('with fewer than 1 hour into the week', function()
                    before_each(function()
                        -- 08-02-2020 @ 6:59:59pm UTC
                        _G.GetTimeStamp = function() return 1596418800 end
                    end)

                    it('should return Monday 1am UTC', function()
                        local result = ArkadiusTradeTools:GetStartOfWeek(0, true)
                        expect.equals(1596416400, result)
                    end)
                end)

                it('should return Monday 1am UTC', function()
                    local result = ArkadiusTradeTools:GetStartOfWeek(0, true)
                    expect.equals(1595811600, result)
                end)
            end)

            describe('when asking for the start of the previous trader week', function() 
                it('should return last Monday 1am UTC', function()
                    local result = ArkadiusTradeTools:GetStartOfWeek(-1, true)
                    -- 07-19-2020 @ 8pm EDT/07-20-2020 @ 1am UTC
                    expect.equals(1595206800, result)
                end)
            end)

            describe('when asking for the start of the trader week two weeks ago', function() 
                it('should return two Mondays ago at 1am UTC', function()
                    local result = ArkadiusTradeTools:GetStartOfWeek(-2, true)
                    -- 07-19-2020 @ 8pm EDT/07-20-2020 @ 1am UTC
                    expect.equals(1594602000, result)
                end)
            end)

            describe('when using Tues-Tues weeks', function()
                before_each(function()
                    _G.GetWorldName = function() return 'NA Megaserver' end
                    _G.GetTimeStamp = function() return 1596655800 end
                    ArkadiusTradeTools.USE_TRADITIONAL_WEEKS = false
                end)
    
                after_each(function()
                    _G.GetWorldName = nil            
                    _G.GetTimeStamp = nil
                    ArkadiusTradeTools.USE_TRADITIONAL_WEEKS = true
                end)
    
                describe('when asking for the start of the current trader week', function()
                    -- I'm not sure the fewer than tests are actually testing things properly
                    describe('with fewer than 1 hour into the week', function()
                        before_each(function()
                            -- 08-02-2020 @ 6:59:59pm UTC
                            _G.GetTimeStamp = function() return 1596569400 end
                        end)
    
                        it('should return Tuesday 7pm UTC', function()
                            local result = ArkadiusTradeTools:GetStartOfWeek(0, true)
                            expect.equals(1596567600, result)
                        end)
                    end)
    
                    it('should return Tuesday 7pm UTC', function()
                        local result = ArkadiusTradeTools:GetStartOfWeek(0, true)
                        expect.equals(1596567600, result)
                    end)
                end)
    
                describe('when asking for the start of the previous trader week', function() 
                    it('should return last Tuesday 7pm UTC', function()
                        local result = ArkadiusTradeTools:GetStartOfWeek(-1, true)
                        -- 07-19-2020 @ 8pm EDT/07-20-2020 @ 1am UTC
                        expect.equals(1595962800, result)
                    end)
                end)
    
                describe('when asking for the start of the trader week two weeks ago', function() 
                    it('should return two Mondays ago at 1am UTC', function()
                        local result = ArkadiusTradeTools:GetStartOfWeek(-2, true)
                        -- 07-19-2020 @ 8pm EDT/07-20-2020 @ 1am UTC
                        expect.equals(1595358000, result)
                    end)
                end)
            end)
        end)

        describe('on EU', function()
            before_each(function()
                _G.GetWorldName = function() return 'EU Megaserver' end
                _G.GetTimeStamp = function() return 1596351600 end
            end)

            after_each(function()
                _G.GetWorldName = nil            
                _G.GetTimeStamp = nil
            end)
            
            describe('when asking for the start of the current trader week', function()
                describe('with fewer than 5 hours remaining', function()
                    before_each(function()
                        -- 08-02-2020 @ 6:59:59pm UTC
                        _G.GetTimeStamp = function() return 1596394799 end
                    end)

                    after_each(function()           
                        _G.GetTimeStamp = nil
                    end)

                    it('should return Sunday 7pm UTC', function()
                        local result = ArkadiusTradeTools:GetStartOfWeek(0, true)
                        expect.equals(1595790000, result)
                    end)                
                end)

                it('should return Sunday 7pm UTC', function()
                    local result = ArkadiusTradeTools:GetStartOfWeek(0, true)
                    expect.equals(1595790000, result)
                end)
                
            end)

            describe('when asking for the start of the previous trader week', function() 
                describe('with fewer than 5 hours remaining', function()
                    before_each(function()
                        -- 08-02-2020 @ 6:59:59pm UTC
                        _G.GetTimeStamp = function() return 1596394799 end
                    end)
                    after_each(function()           
                        _G.GetTimeStamp = nil
                    end)

                    it('should return last Sunday 7pm UTC', function()
                        local result = ArkadiusTradeTools:GetStartOfWeek(-1, true)
                        expect.equals(1595185200, result)
                    end)                
                end)

                it('should return last Sunday 7pm UTC', function()
                    local result = ArkadiusTradeTools:GetStartOfWeek(-1, true)
                    -- 07-19-2020 @ 8pm EDT/07-20-2020 @ 1am UTC
                    expect.equals(1595185200, result)
                end)
            end)

            describe('when asking for the start of the trader week two weeks ago', function() 
                describe('with fewer than 5 hours remaining', function()
                    before_each(function()
                        -- 08-02-2020 @ 6:59:59pm UTC
                        _G.GetTimeStamp = function() return 1596394799 end
                    end)

                    it('should return last Sunday 7pm UTC', function()
                        local result = ArkadiusTradeTools:GetStartOfWeek(-2, true)
                        expect.equals(1594580400, result)
                    end)                
                end)

                it('should return two Sundays ago at 7pm UTC', function()
                    local result = ArkadiusTradeTools:GetStartOfWeek(-2, true)
                    -- 07-19-2020 @ 8pm EDT/07-20-2020 @ 1am UTC
                    expect.equals(1594580400, result)
                end)
            end)

            
            describe('when using Tues-Tues weeks #only', function()
                before_each(function()
                    _G.GetWorldName = function() return 'EU Megaserver' end
                    _G.GetTimeStamp = function() return 1595964600 end
                    ArkadiusTradeTools.USE_TRADITIONAL_WEEKS = false
                end)
    
                after_each(function()
                    _G.GetWorldName = nil            
                    _G.GetTimeStamp = nil
                    ArkadiusTradeTools.USE_TRADITIONAL_WEEKS = true
                end)
            
                local TUE_AUGUST_4_2020_12PM_UTC = 1596542400
                describe('when asking for the start of the current trader week', function()
                    describe('with fewer than 5 hours remaining', function()
                        before_each(function()
                            -- 08-04-2020 @ 12:00:00pm UTC
                            _G.GetTimeStamp = function() return TUE_AUGUST_4_2020_12PM_UTC end
                        end)
    
                        after_each(function()
                            _G.GetTimeStamp = nil
                        end)
    
                        it('should return Tuesday 1pm UTC', function()
                            local result = ArkadiusTradeTools:GetStartOfWeek(0, true)
                            expect.equals(1595941200, result)
                        end)
                    end)
    
                    it('should return Tuesday 1pm UTC', function()
                        local result = ArkadiusTradeTools:GetStartOfWeek(0, true)
                        expect.equals(1595941200, result)
                    end)
                    
                end)
    
                describe('when asking for the start of the previous trader week', function() 
                    describe('with fewer than 5 hours remaining', function()
                        before_each(function()
                            -- 08-04-2020 @ 12:00:00pm UTC
                            _G.GetTimeStamp = function() return TUE_AUGUST_4_2020_12PM_UTC end
                        end)
                        after_each(function()           
                            _G.GetTimeStamp = nil
                        end)
    
                        it('should return last Tuesday 1pm UTC', function()
                            local result = ArkadiusTradeTools:GetStartOfWeek(-1, true)
                            expect.equals(1595336400, result)
                        end)                
                    end)
    
                    it('should return last Tuesday 1pm UTC', function()
                        local result = ArkadiusTradeTools:GetStartOfWeek(-1, true)
                        expect.equals(1595336400, result)
                    end)
                end)
    
                describe('when asking for the start of the trader week two weeks ago', function() 
                    describe('with fewer than 5 hours remaining', function()
                        before_each(function()
                            -- 08-04-2020 @ 12:00:00pm UTC
                            _G.GetTimeStamp = function() return TUE_AUGUST_4_2020_12PM_UTC end
                        end)
    
                        it('should return last Tuesday 1pm UTC', function()
                            local result = ArkadiusTradeTools:GetStartOfWeek(-2, true)
                            expect.equals(1594731600, result)
                        end)                
                    end)
    
                    it('should return two Tuesdays ago at 7pm UTC', function()
                        local result = ArkadiusTradeTools:GetStartOfWeek(-2, true)
                        -- 07-14-2020 @ 8pm EDT/07-20-2020 @ 1am UTC
                        expect.equals(1594731600, result)
                    end)
                end)
            end)
        end)
    end)    
end)