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

  describe('when the date falls within the elongated trader week', function()
    describe('when using default times on #NA', function()
      before_each(function()
        _G.GetWorldName = function() return 'NA Megaserver' end
        _G.GetTimeStamp = function() return 1596655800 end
      end)

      after_each(function()
        _G.GetTimeStamp = nil
      end)
      
      describe('when asking for the start of the current trader week', function()
        describe('with fewer than 5 hours remaining', function()
          before_each(function()
            _G.GetTimeStamp = function() return 1597168800 end
          end)

          after_each(function()           
            _G.GetTimeStamp = nil
          end)

          it('should return Sunday 7pm UTC', function()
            local result = ArkadiusTradeTools:GetStartOfWeek(0, true)
            expect.equals(1596416400, result)
          end)                
        end)

        it('should return Sunday 7pm UTC', function()
            local result = ArkadiusTradeTools:GetStartOfWeek(0, true)
            expect.equals(1596416400, result)
        end)
      end)

      describe('when asking for the start of the previous trader week', function() 
        before_each(function()
          _G.GetTimeStamp = function() return 1597260600 end
        end)
        after_each(function()
          _G.GetTimeStamp = nil
        end)

        describe('with fewer than 5 hours remaining', function()
          before_each(function()
            _G.GetTimeStamp = function() return 1597773600 end
          end)
          after_each(function()
            _G.GetTimeStamp = nil
          end)

          it('should return last Sunday 7pm UTC', function()
            local result = ArkadiusTradeTools:GetStartOfWeek(-1, true)
            expect.equals(1596416400, result)
          end)
        end)

        it('should return last Sunday 7pm UTC', function()
          local result = ArkadiusTradeTools:GetStartOfWeek(-1, true)
          expect.equals(1596416400, result)
        end)
      end)

      describe('when asking for the start of the trader week two weeks ago', function() 
        before_each(function()
          _G.GetTimeStamp = function() return 1597865400 end
        end)

        after_each(function()           
          _G.GetTimeStamp = nil
        end)

        describe('with fewer than 5 hours remaining', function()
          before_each(function()
            _G.GetTimeStamp = function() return 1598378400 end
          end)

          it('should return last Sunday 7pm UTC', function()
            local result = ArkadiusTradeTools:GetStartOfWeek(-2, true)
            expect.equals(1596416400, result)
          end)
        end)

        it('should return two Sundays ago at 7pm UTC', function()
          local result = ArkadiusTradeTools:GetStartOfWeek(-2, true)
          expect.equals(1596416400, result)
        end)
      end)
    end)

    describe('when using default times on #EU', function()
      local AUGUST_2ND_7PM_UTC = 1596394800
      before_each(function()
        _G.GetWorldName = function() return 'EU Megaserver' end
        _G.GetTimeStamp = function() return 1596655800 end
      end)

      after_each(function()
        _G.GetTimeStamp = nil
      end)

      describe('when asking for the start of the current trader week', function()
        describe('with fewer than 1 hour into the week', function()
          before_each(function()
            _G.GetTimeStamp = function() return 1596396600 end
          end)

          after_each(function()
            _G.GetTimeStamp = nil
          end)

          it('should return Sunday 7pm UTC', function()
            local result = ArkadiusTradeTools:GetStartOfWeek(0, true)
            expect.equals(AUGUST_2ND_7PM_UTC, result)
          end)
        end)

        it('should return Sunday 7pm UTC', function()
          local result = ArkadiusTradeTools:GetStartOfWeek(0, true)
          expect.equals(AUGUST_2ND_7PM_UTC, result)
        end)
      end)

      describe('when asking for the start of the previous trader week', function() 
        before_each(function()
          _G.GetTimeStamp = function() return 1597260600 end
        end)

        after_each(function()
          _G.GetTimeStamp = nil
        end)

        describe('with fewer 1 hour into the week', function()
          before_each(function()
              _G.GetTimeStamp = function() return 1597156200 end
          end)
          after_each(function()
              _G.GetTimeStamp = nil
          end)

          it('should return last Sunday 7pm UTC', function()
            local result = ArkadiusTradeTools:GetStartOfWeek(-1, true)
            expect.equals(AUGUST_2ND_7PM_UTC, result)
          end)
        end)

        it('should return last Sunday 7pm UTC', function()
          local result = ArkadiusTradeTools:GetStartOfWeek(-1, true)
          expect.equals(AUGUST_2ND_7PM_UTC, result)
        end)
      end)

      describe('when asking for the start of the trader week two weeks ago', function() 
        before_each(function()
          _G.GetTimeStamp = function() return 1597865400 end
        end)

        after_each(function()
          _G.GetTimeStamp = nil
        end)

        describe('with fewer than 1 hour into the week', function()
          before_each(function()
            _G.GetTimeStamp = function() return 1597779000 end
          end)

          it('should return two Sundays ago at 7pm UTC', function()
            local result = ArkadiusTradeTools:GetStartOfWeek(-2, true)
            expect.equals(AUGUST_2ND_7PM_UTC, result)
          end)
        end)

        it('should return two Sundays ago at 7pm UTC', function()
          local result = ArkadiusTradeTools:GetStartOfWeek(-2, true)
          expect.equals(AUGUST_2ND_7PM_UTC, result)
        end)
      end)
    end)

    describe('when using default times on #PTS', function()
      before_each(function()
        _G.GetWorldName = function() return 'PTS' end
        _G.GetTimeStamp = function() return 1596051000 end
      end)

      after_each(function()
        _G.GetTimeStamp = nil
      end)

      local JULY_27TH_1AM_UTC = 1595811600
      describe('when asking for the start of the current trader week', function()
        describe('with fewer than 5 hours remaining', function()
          before_each(function()
            _G.GetTimeStamp = function() return 1596564000 end
          end)

          after_each(function()
            _G.GetTimeStamp = nil
          end)

          it('should return Monday 1am UTC', function()
            local result = ArkadiusTradeTools:GetStartOfWeek(0, true)
            expect.equals(JULY_27TH_1AM_UTC, result)
          end)
        end)

        it('should return Monday 1am UTC', function()
          local result = ArkadiusTradeTools:GetStartOfWeek(0, true)
          expect.equals(JULY_27TH_1AM_UTC, result)
        end)
      end)

      describe('when asking for the start of the previous trader week', function() 
        before_each(function()
          _G.GetTimeStamp = function() return 1596655800 end
        end)

        after_each(function()
          _G.GetTimeStamp = nil
        end)

        describe('with fewer than 5 hours remaining', function()
          before_each(function()
            _G.GetTimeStamp = function() return 1597168800 end
          end)
          after_each(function()
            _G.GetTimeStamp = nil
          end)

          it('should return last Sunday 7pm UTC', function()
            local result = ArkadiusTradeTools:GetStartOfWeek(-1, true)
            expect.equals(JULY_27TH_1AM_UTC, result)
          end)
        end)

        it('should return last Sunday 7pm UTC', function()
          local result = ArkadiusTradeTools:GetStartOfWeek(-1, true)
          expect.equals(JULY_27TH_1AM_UTC, result)
        end)
      end)

      describe('when asking for the start of the trader week two weeks ago', function() 
        before_each(function()
          _G.GetTimeStamp = function() return 1597260600 end
        end)

        after_each(function()
          _G.GetTimeStamp = nil
        end)
        describe('with fewer than 5 hours remaining', function()
          before_each(function()
            _G.GetTimeStamp = function() return 1597773600 end
          end)

          it('should return last Sunday 7pm UTC', function()
            local result = ArkadiusTradeTools:GetStartOfWeek(-2, true)
            expect.equals(JULY_27TH_1AM_UTC, result)
          end)
        end)

        it('should return two Sundays ago at 7pm UTC', function()
            local result = ArkadiusTradeTools:GetStartOfWeek(-2, true)
            expect.equals(JULY_27TH_1AM_UTC, result)
        end)
      end)
    end)
  end)

  describe('if we\'re on PTS the current date is during the last two days of the elongated week', function()
    before_each(function()
      _G.GetWorldName = function() return 'PTS' end
      _G.GetTimeStamp = function() return 1596502800 end
    end)

    after_each(function()
      _G.GetTimeStamp = nil
    end)    
    
    local JULY_13TH_1AM_UTC = 1594602000
    local JULY_20TH_1AM_UTC = 1595206800
    local JULY_27TH_1AM_UTC = 1595811600
    describe('when asking for the start of the current trader week', function()
      it('should return Monday 1am UTC', function()
        local result = ArkadiusTradeTools:GetStartOfWeek(0, true)
        expect.equals(JULY_27TH_1AM_UTC, result)
      end)
    end)

    describe('when asking for the start of the previous trader week', function()
      it('should return last Monday 1am UTC', function()
        local result = ArkadiusTradeTools:GetStartOfWeek(-1, true)
        expect.equals(JULY_20TH_1AM_UTC, result)
      end)
    end)

    describe('when asking for the start of the trader week two weeks ago', function()
      it('should return two Mondays ago at 1am UTC', function()
          local result = ArkadiusTradeTools:GetStartOfWeek(-2, true)
          expect.equals(JULY_13TH_1AM_UTC, result)
      end)
    end)
  end)

  -- This only works if we make Settings global, at least until I can call OnAddonLoaded and set the settings properly
  describe('if we\'re on PTS the current date is during the last two days of the elongated week and we have force traditional weeks enabled', function()
    before_each(function()
      _G.GetWorldName = function() return 'PTS' end
      _G.GetTimeStamp = function() return 1596502800 end
      _G.Settings = { forceTraditionalTraderWeek = true }
    end)

    after_each(function()
      _G.GetTimeStamp = nil
    end)    
    
    local JULY_13TH_1AM_UTC = 1594602000
    local JULY_20TH_1AM_UTC = 1595206800
    local JULY_27TH_1AM_UTC = 1595811600
    local AUGUST_3RD_1AM_UTC = 1596416400
    describe('when asking for the start of the current trader week', function()
      it('should return Monday 1am UTC', function()
        local result = ArkadiusTradeTools:GetStartOfWeek(0, true)
        expect.equals(AUGUST_3RD_1AM_UTC, result)
      end)
    end)

    describe('when asking for the start of the previous trader week', function()
      it('should return last Monday 1am UTC', function()
        local result = ArkadiusTradeTools:GetStartOfWeek(-1, true)
        expect.equals(JULY_27TH_1AM_UTC, result)
      end)
    end)

    describe('when asking for the start of the trader week two weeks ago', function()
      it('should return two Mondays ago at 1am UTC', function()
          local result = ArkadiusTradeTools:GetStartOfWeek(-2, true)
          expect.equals(JULY_20TH_1AM_UTC, result)
      end)
    end)
  end)
  
  describe('if we\'re on NA and the current date is during the last two days of the elongated week', function()
    before_each(function()
      _G.GetWorldName = function() return 'NA Megaserver' end
      _G.GetTimeStamp = function() return 1597107600 end
    end)

    after_each(function()
      _G.GetTimeStamp = nil
    end)
    
    local JULY_20TH_1AM_UTC = 1595206800
    local JULY_27TH_1AM_UTC = 1595811600
    local AUGUST_3RD_1AM_UTC = 1596416400
    describe('when asking for the start of the current trader week', function()
      it('should return Monday 1am UTC', function()
        local result = ArkadiusTradeTools:GetStartOfWeek(0, true)
        expect.equals(AUGUST_3RD_1AM_UTC, result)
      end)
    end)

    describe('when asking for the start of the previous trader week', function()
      it('should return last Monday 1am UTC', function()
        local result = ArkadiusTradeTools:GetStartOfWeek(-1, true)
        expect.equals(JULY_27TH_1AM_UTC, result)
      end)
    end)

    describe('when asking for the start of the trader week two weeks ago', function()
      it('should return two Mondays ago at 1am UTC', function()
          local result = ArkadiusTradeTools:GetStartOfWeek(-2, true)
          expect.equals(JULY_20TH_1AM_UTC, result)
      end)
    end)
  end)

  describe('if we\'re on EU and the current date is during the last two days of the elongated week', function()
    before_each(function()
      _G.GetWorldName = function() return 'EU Megaserver' end
      _G.GetTimeStamp = function() return 1597107600 end
    end)

    after_each(function()
      _G.GetTimeStamp = nil
    end)
    
    local JULY_19TH_7PM_UTC = 1595185200
    local JULY_26TH_7PM_UTC = 1595790000
    local AUGUST_2RD_7PM_UTC = 1596394800
    describe('when asking for the start of the current trader week', function()
      it('should return Sunday 7pm UTC', function()
        local result = ArkadiusTradeTools:GetStartOfWeek(0, true)
        expect.equals(AUGUST_2RD_7PM_UTC, result)
      end)
    end)

    describe('when asking for the start of the previous trader week', function()
      it('should return last Sunday 7pm UTC', function()
        local result = ArkadiusTradeTools:GetStartOfWeek(-1, true)
        expect.equals(JULY_26TH_7PM_UTC, result)
      end)
    end)

    describe('when asking for the start of the trader week two weeks ago', function()
      it('should return two Sundays ago at 7pm UTC', function()
          local result = ArkadiusTradeTools:GetStartOfWeek(-2, true)
          expect.equals(JULY_19TH_7PM_UTC, result)
      end)
    end)
  end)
end)
