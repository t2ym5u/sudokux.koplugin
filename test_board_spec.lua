local DIR = debug.getinfo(1, "S").source:sub(2):match("(.*[/\\])") or "./"

package.preload["gettext"] = function()
    return setmetatable({}, { __call = function(_, s) return s end })
end
package.path = DIR .. "common/?.lua;" .. DIR .. "?.lua;" .. package.path

describe("SudokuXBoard", function()
    local Mod, SudokuXBoard

    setup(function()
        Mod = require("board")
        SudokuXBoard = Mod.SudokuXBoard
    end)

    describe("new", function()
        it("creates an empty 9x9 board", function()
            local b = SudokuXBoard:new()
            assert.are.equal(9, b.n)
        end)
    end)

    describe("generate", function()
        it("fills a solution valid on rows/cols/boxes AND both diagonals", function()
            math.randomseed(42)
            local b = SudokuXBoard:new()
            b:generate("medium")
            local n = b.n
            for r = 1, n do
                local seen = {}
                for c = 1, n do seen[b.solution[r][c]] = true end
                for d = 1, n do assert.is_true(seen[d], "row " .. r .. " missing " .. d) end
            end
            local diag1, diag2 = {}, {}
            for r = 1, n do
                diag1[b.solution[r][r]] = true
                diag2[b.solution[r][n + 1 - r]] = true
            end
            for d = 1, n do
                assert.is_true(diag1[d], "main diagonal missing " .. d)
                assert.is_true(diag2[d], "anti-diagonal missing " .. d)
            end
        end)
    end)

    describe("recalcConflicts (diagonal violations)", function()
        it("flags a duplicate value on the main diagonal", function()
            math.randomseed(42)
            local b = SudokuXBoard:new()
            b:generate("medium")
            local r1, r2 = 1, 2
            if not b:isGiven(r1, r1) and not b:isGiven(r2, r2) then
                b.user[r1][r1] = 5
                b.user[r2][r2] = 5
                b:recalcConflicts()
                assert.is_true(b.conflicts[r1][r1])
                assert.is_true(b.conflicts[r2][r2])
            end
        end)
    end)

    describe("serialize / load", function()
        it("round-trips puzzle and solution", function()
            math.randomseed(42)
            local b = SudokuXBoard:new()
            b:generate("medium")
            local data = b:serialize()

            local b2 = SudokuXBoard:new()
            assert.is_true(b2:load(data))
            for r = 1, b.n do
                for c = 1, b.n do
                    assert.are.equal(b.solution[r][c], b2.solution[r][c])
                end
            end
        end)

        it("load returns false for invalid data", function()
            local b = SudokuXBoard:new()
            assert.is_false(b:load(nil))
            assert.is_false(b:load({}))
        end)
    end)
end)
