local function check_blk (to_blk, fr_blk)
    --  NO: big = &&small
    if to_blk.__depth >= fr_blk.__depth then
        assert(AST.is_par(fr_blk,to_blk), 'bug found')
        return true
    else
        assert(AST.is_par(to_blk,fr_blk), 'bug found')
        return false
    end
end

F = {
    Set_Exp = function (me)
        local fr, to = unpack(me)
        local to_ptr = TYPES.check(TYPES.pop(to.info.tp,'?'),'&&')
        local fr_ptr = TYPES.check(fr.info.tp,'&&')
        if to_ptr or fr_ptr then
            local to_nat = TYPES.is_nat(to.info.tp)
            local fr_nat = TYPES.is_nat(fr.info.tp)
            assert((to_ptr or to_nat) and (fr_ptr or fr_nat), 'bug found')
            local ok do
                if fr_nat or (not fr.info.dcl) then
                    ok = true   -- var int&& x = _X/null/""/...;
                elseif to_nat then
                    ok = false  -- _X = &&x;
                else
                    local to_blk = to.info.dcl_obj and to.info.dcl_obj.blk or
                                    to.info.dcl.blk
                    local fr_blk = fr.info.dcl_obj and fr.info.dcl_obj.blk or
                                    fr.info.dcl.blk
                    ok = check_blk(to_blk, fr_blk)
                end
            end 
            if not ok then
                if AST.get(me.__par,'Stmts', 2,'Escape') then
                    ASR(false, me, 'invalid `escape´ : incompatible scopes')
                else
                    local fin = AST.par(me, 'Finalize')
                    ASR(fin, me,
                        'invalid pointer assignment : expected `finalize´')
                end
            end
        end
    end,

    Set_Alias = function (me)
        local fr, to = unpack(me)
        local ok = check_blk(to.info.dcl.blk, fr.info.dcl.blk)
        ASR(ok, me, 'invalid binding : incompatible scopes')
    end,

    __stmts = { Set_Exp=true, Set_Alias=true,
                Emit_Ext_emit=true, Emit_Ext_call=true,
                Abs_Call=true, Exp_Call=true },

    Finalize = function (me)
        local Stmt, Namelist, Block = unpack(me)
        if not Stmt then
            ASR(not Namelist.tag=='Mark', me,
                'invalid `finalize´ : unexpected `varlist´')
            return
        end
        assert(Stmt)

        -- NO: |do r=await... finalize...end|
        local tag_id = AST.tag2id[Stmt.tag]
        ASR(F.__stmts[Stmt.tag], Stmt,
            'invalid `finalize´ : unexpected '..
            (tag_id and '`'..tag_id..'´' or 'statement'))

        if Stmt.tag=='Set_Exp' or Stmt.tag=='Set_Alias' then
            local Exp_Name = AST.asr(Stmt,'', 2,'Exp_Name')
            local ID = AST.get(Exp_Name,'', 1,'ID_int') or
                       AST.get(Exp_Name,'', 1,'ID_nat')
            ASR(ID, Exp_Name,
                'invalid `finalize´ : expected identifier : got "'..Exp_Name.info.id..'"')
            ASR(Namelist.tag=='Namelist', Namelist,
                'invalid `finalize´ : expected `varlist´')
            ASR(#Namelist==1 and Namelist[1].info.dcl==ID.info.dcl, Namelist,
                'invalid `finalize´ : unmatching identifiers : expected "'..
                ID.info.id..'" (vs. '..Stmt.ln[1]..':'..Stmt.ln[2]..')')
        end
    end,
}

AST.visit(F)
