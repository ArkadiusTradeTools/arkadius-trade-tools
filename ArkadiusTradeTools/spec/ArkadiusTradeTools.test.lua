describe('ArkadiusTradeTools', function()
  before_each(function()
    expect = assert
    _G.EVENT_MANAGER = { }
    _G.EVENT_MANAGER.RegisterForEvent = spy.new(function() end)
    _G.Settings = { forceTraditionalTraderWeek = false }
    local eventManager = mock(_G.EVENT_MANAGER)
    require('esoui/esoui/libraries/utility/baseobject')
    require('esoui/esoui/libraries/utility/zo_callbackobject')
    require("ArkadiusTradeTools")
  end)

  describe('GetStartOfWeek', function()      
    describe('on #NA', function()
      before_each(function()
        _G.GetWorldName = function() return 'NA Megaserver' end
        _G.GetTimeStamp = function() return 1596405423 end
        _G.Settings = { forceTraditionalTraderWeek = false }
      end)

      after_each(function()
        _G.GetWorldName = nil            
        _G.GetTimeStamp = nil
      end)

      describe('when asking for the start of the current trader week', function()
        -- I'm not sure the fewer than tests are actually testing things properly
        describe('with fewer than 1 hour into the week', function()
          before_each(function()
            _G.GetTimeStamp = function() return 1595814000 end
          end)

          it('should return Monday 1am UTC', function()
            local result = ArkadiusTradeTools:GetStartOfWeek(0, true)
            expect.equals(1595811600, result)
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
          expect.equals(1595206800, result)
        end)
      end)

      describe('when asking for the start of the trader week two weeks ago', function() 
        it('should return two Mondays ago at 1am UTC', function()
          local result = ArkadiusTradeTools:GetStartOfWeek(-2, true)
          expect.equals(1594602000, result)
        end)
      end)

      describe('when using weeks tied to server flip-time on Tuesdays', function()
        before_each(function()
          _G.GetWorldName = function() return 'NA Megaserver' end
          _G.GetTimeStamp = function() return 1599073200 end
        end)

        after_each(function()
          _G.GetWorldName = nil            
          _G.GetTimeStamp = nil
        end)

        describe('when asking for the start of the current trader', function()
          -- I'm not sure the fewer than tests are actually testing things properly
          describe('with fewer than 1 hour into the week', function()
            before_each(function()
              _G.GetTimeStamp = function() return 1598988600 end
            end)

            it('should return Tuesday 7pm UTC', function()
              local result = ArkadiusTradeTools:GetStartOfWeek(0, true)
              expect.equals(1598986800, result)
            end)
          end)

          it('should return Tuesday 7pm UTC', function()
            local result = ArkadiusTradeTools:GetStartOfWeek(0, true)
            expect.equals(1598986800, result)
          end)
        end)

        describe('when asking for the start of the previous trader week', function() 
          it('should return last Tuesday 7pm UTC', function()
            local result = ArkadiusTradeTools:GetStartOfWeek(-1, true)
            expect.equals(1598382000, result)
          end)
        end)

        describe('when asking for the start of the trader week two weeks ago', function() 
          it('should return two Mondays ago at 1am UTC', function()
            local result = ArkadiusTradeTools:GetStartOfWeek(-2, true)
            expect.equals(1597777200, result)
          end)
        end)
      end)
    end)

    describe('on #EU', function()
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
          expect.equals(1595185200, result)
        end)
      end)

      describe('when asking for the start of the trader week two weeks ago', function() 
        describe('with fewer than 5 hours remaining', function()
          before_each(function()
            _G.GetTimeStamp = function() return 1596394799 end
          end)

          it('should return last Sunday 7pm UTC', function()
            local result = ArkadiusTradeTools:GetStartOfWeek(-2, true)
            expect.equals(1594580400, result)
          end)
        end)

        it('should return two Sundays ago at 7pm UTC', function()
          local result = ArkadiusTradeTools:GetStartOfWeek(-2, true)
          expect.equals(1594580400, result)
        end)
      end)

      describe('when using weeks tied to server flip-time on Tuesdays', function()
        before_each(function()
          _G.GetWorldName = function() return 'EU Megaserver' end
          _G.GetTimeStamp = function() return 1598970600 end
        end)

        after_each(function()
          _G.GetWorldName = nil            
          _G.GetTimeStamp = nil
        end)
    
        local SEPTEMBER_8TH_12PM_UTC = 1599566400
        local SEPTEMBER_1ST_2PM_UTC = 1598968800
        describe('when asking for the start of the current trader week', function()
          describe('with fewer than 5 hours remaining', function()
            before_each(function()
              _G.GetTimeStamp = function() return SEPTEMBER_8TH_12PM_UTC end
            end)

            after_each(function()
              _G.GetTimeStamp = nil
            end)

            it('should return Tuesday 2pm UTC', function()
              local result = ArkadiusTradeTools:GetStartOfWeek(0, true)
              expect.equals(SEPTEMBER_1ST_2PM_UTC, result)
            end)
          end)

          it('should return Tuesday 2pm UTC', function()
            local result = ArkadiusTradeTools:GetStartOfWeek(0, true)
            expect.equals(SEPTEMBER_1ST_2PM_UTC, result)
          end)
        end)
        
        local AUGUST_25TH_2PM_UTC = 1598364000
        describe('when asking for the start of the previous trader week', function() 
          describe('with fewer than 5 hours remaining', function()
            before_each(function()
              _G.GetTimeStamp = function() return SEPTEMBER_8TH_12PM_UTC end
            end)
            after_each(function()           
              _G.GetTimeStamp = nil
            end)

            it('should return last Tuesday 2pm UTC', function()
              local result = ArkadiusTradeTools:GetStartOfWeek(-1, true)
              expect.equals(AUGUST_25TH_2PM_UTC, result)
            end)                
          end)

          it('should return last Tuesday 2pm UTC', function()
            local result = ArkadiusTradeTools:GetStartOfWeek(-1, true)
            expect.equals(AUGUST_25TH_2PM_UTC, result)
          end)
        end)

        local AUGUST_25TH_2PM_UTC = 1597759200
        describe('when asking for the start of the trader week two weeks ago', function() 
          describe('with fewer than 5 hours remaining', function()
            before_each(function()
              _G.GetTimeStamp = function() return SEPTEMBER_8TH_12PM_UTC end
            end)

            it('should return last Tuesday 1pm UTC', function()
              local result = ArkadiusTradeTools:GetStartOfWeek(-2, true)
              expect.equals(AUGUST_25TH_2PM_UTC, result)
            end)                
          end)

          it('should return two Tuesdays ago at 2pm UTC', function()
              local result = ArkadiusTradeTools:GetStartOfWeek(-2, true)
              expect.equals(AUGUST_25TH_2PM_UTC, result)
          end)
        end)
      end)
    end)
  end)
      
  describe('on #PTS', function()
    before_each(function()
      _G.GetWorldName = function() return 'PTS' end
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
          _G.GetTimeStamp = function() return 1596418800 end
        end)

        it('should return Monday 1am UTC', function()
          local result = ArkadiusTradeTools:GetStartOfWeek(0, true)
          expect.equals(1595811600, result)
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
        expect.equals(1595206800, result)
      end)
    end)

    describe('when asking for the start of the trader week two weeks ago', function() 
      it('should return two Mondays ago at 1am UTC', function()
        local result = ArkadiusTradeTools:GetStartOfWeek(-2, true)
        expect.equals(1594602000, result)
      end)
    end)

    describe('when using weeks tied to server flip-time on Tuesdays', function()
      before_each(function()
        _G.GetWorldName = function() return 'NA Megaserver' end
        _G.GetTimeStamp = function() return 1599073200 end
      end)

      after_each(function()
        _G.GetWorldName = nil            
        _G.GetTimeStamp = nil
      end)

      describe('when asking for the start of the current trader', function()
        -- I'm not sure the fewer than tests are actually testing things properly
        describe('with fewer than 1 hour into the week', function()
          before_each(function()
            _G.GetTimeStamp = function() return 1598988600 end
          end)

          it('should return Tuesday 7pm UTC', function()
            local result = ArkadiusTradeTools:GetStartOfWeek(0, true)
            expect.equals(1598986800, result)
          end)
        end)

        it('should return Tuesday 7pm UTC', function()
          local result = ArkadiusTradeTools:GetStartOfWeek(0, true)
          expect.equals(1598986800, result)
        end)
      end)

      describe('when asking for the start of the previous trader week', function() 
        it('should return last Tuesday 7pm UTC', function()
          local result = ArkadiusTradeTools:GetStartOfWeek(-1, true)
          expect.equals(1598382000, result)
        end)
      end)

      describe('when asking for the start of the trader week two weeks ago', function() 
        it('should return two Mondays ago at 1am UTC', function()
          local result = ArkadiusTradeTools:GetStartOfWeek(-2, true)
          expect.equals(1597777200, result)
        end)
      end)
    end)
  end)
end)
