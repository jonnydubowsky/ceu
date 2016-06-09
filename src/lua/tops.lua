TOPS = {
--[[
    [id] = node + {
        id    = <string>,
        group = 'primitive' | 'native' | 'data' | 'code'
              | 'input' | 'output' | ...,
        is_num = true | false,
        is_used = ...,
    },
]]
}

-- Primitive types: id / is_num
do
    local prims = {
        bool=false, byte=true, f32=true, f64 =true, float=true, int =true,
        s16 =true,  s32 =true, s64=true, s8  =true, ssize=true, u16 =true,
        u32 =true,  u64 =true, u8 =true, uint=true, usize=true, void=false,
    }
    for id, is_num in pairs(prims) do
        TOPS[id] = {
            id      = id,
            group   = 'primitive',
            is_num  = is_num,
            is_used = true,
        }
    end
end

-- native declarations are allowed until `native/end´
local native_end = false

local function tops_new (me)
    local old = TOPS[me.id]
    ASR(not old, me, old and
        'identifier "'..me.id..'" is already declared'..
            ' ('..old.ln[1]..' : line '..old.ln[2]..')')
    TOPS[me.id] = me
end

local function tops_use (me, id, group)
    local dcl = ASR(TOPS[id], me,
                    group..' "'..id..'" is not declared')
    dcl.is_used = true
    return dcl
end

F = {

-- PRIMITIVE

    ID_prim = function (me)
        local id = unpack(me)
        me.dcl = tops_use(me, id, 'primitive')
    end,

-- NATIVE

    Nat_End = function (me)
        native_end = true
    end,
    Nat = function (me)
        local _,id = unpack(me)
        me.id    = id
        me.group = 'native'
        tops_new(me)

        ASR(not native_end, me,
            'native declarations are disabled')
    end,
    ID_nat = function (me)
        local id = unpack(me)
        me.dcl = tops_use(me, id, 'native')
    end,

-- EXT

    Extcall_proto = 'Extcall_impl',
    Extcall_impl = function (me)
        local grp, _, id = unpack(me)
        me.id    = id
        me.group = grp
        tops_new(me)
    end,

    Ext = function (me)
        local grp, tp, id = unpack(me)
        me.id    = id
        me.group = grp
        tops_new(me)
    end,

    ID_ext = function (me)
        local id = unpack(me)
        me.dcl = tops_use(me, id, 'external')
    end,

-- CODE / DATA

    Code_proto = function (me)
        local mod, is_rec, id, ins, out = unpack(me)
        me.id    = id
        me.group = 'code'
        tops_new(me)
    end,
    Code_impl = function (me)
        local mod, is_rec, id, ins, out, blk = unpack(me)
        me.id    = id
        me.group = 'code'

        local dcl = TOPS[id]
        if (not dcl) or dcl.blk then
            tops_new(me)
            dcl = me
        end

        -- CHECK prototype
        if me ~= dcl then
            -- ...
        end
        dcl.blk = blk
    end,

    Data = function (me)
        local id, super = unpack(me)
        me.id    = id
        me.group = 'data'
        tops_new(me)
    end,

    ID_abs = function (me)
        local id = unpack(me)
        me.dcl = tops_use(me, id, 'abstraction')
    end,
}

AST.visit(F)

for _, dcl in pairs(TOPS) do
    if dcl.group=='data' and string.sub(dcl.id,1,1)=='_' then
        -- auto generated
    else
        WRN(dcl.is_used, dcl, dcl.group..' "'..dcl.id..' declared but not used')
    end
end
