local P, C, V, S, Cc, Ct, Cg = m.P, m.C, m.V, m.S, m.Cc, m.Ct, m.Cg

--local __debug = true
local spc = 0
if __debug then
    local VV = V
    V = function (id)
        return
            m.Cmt(P'',
                function ()
                    DBG(string.rep(' ',spc)..'>>>', id)
                    spc = spc + 2
                    return true
                end)
            * (
                VV(id) * m.Cmt(P'',
                            function ()
                                spc = spc - 2
                                DBG(string.rep(' ',spc)..'+++', id)
                                return true
                            end)
              + m.Cmt(P'',
                    function ()
                        spc = spc - 2
                        DBG(string.rep(' ',spc)..'---', id)
                        return false
                    end) * P(false)
            )
    end
end

local x = V'__SPACE'^0
local X = V'__SPACE'^1

local T = {
    {
        '`%*´ or `/´ or `%%´ or `%+´ or `%-´ or `>>´ or `<<´ or `&´ or `^´ or `|´ or `!=´ or `==´ or `<=´ or `>=´ or `<´ or `>´ or `and´ or `or´',
        'binary operator'
    },
    {
        '`%*´ or `/´ or `%%´ or `%+´ or `%-´ or `>>´ or `<<´ or `^´ or `|´ or `!=´ or `==´ or `<=´ or `>=´ or `<´ or `>´ or `and´ or `or´',
        'binary operator'
    },

    {
        '`&&´ or `%?´',
        'type modifier'
    },

    {
        '`&%?´ or `&´ or `%(´ or primitive type or abstraction identifier or native identifier',
        'type'
    },
    {
        'primitive type or abstraction identifier or native identifier',
        'type'
    },

    {
        '`native´ or `code´ or end of file',
        'end of file'
    },
    {
        '`;´ or `native´ or `code´ or `with´',
        '`with´'
    },
    {
        '`native´ or `code´ or `end´',
        '`end´'
    },

    {
        '`vector´ or `pool´ or `event´ or `dynamic´ or `var´',
        '`vector´ or `pool´ or `event´ or `var´',
    },
    {
        ' or `/dynamic´ or `/static´ or `/recursive´',
        '',
    },

    {
        '`%(´ or internal identifier or native identifier or `outer´ or `{´',
        'name expression'
    },
    {
        '`%*´ or `%$´ or name expression',
        'name expression'
    },
    {
        '`%*´ or `%$´ or internal identifier or native identifier or `outer´',
        'name expression'
    },
    {
        'abstraction identifier or name expression',
        'name expression'
    },
    {
        '`/dynamic´ or `/static´ or `/recursive´ or abstraction identifier',
        'abstraction identifier'
    },

    {
        '`do´ or `await´ or `%[´ or `call´ or name expression or `&&´ or `&´ or `sizeof´ or `null´ or number or `false´ or `true´ or `"´ or string literal or `not´ or `%-´ or `%+´ or `~´ or `%$%$´ or `emit´ or `call/recursive´ or `val´ or `new´ or `spawn´ or `_´ or `request´ or `watching´',
        'expression'
    },
    {
        '`call´ or name expression or `&&´ or `&´ or `sizeof´ or `null´ or number or `false´ or `true´ or `"´ or string literal or `not´ or `%-´ or `%+´ or `~´ or `%$%$´',
        'expression'
    },
    {
        'name expression or `call´ or `&&´ or `&´ or `sizeof´ or `null´ or number or `false´ or `true´ or `"´ or string literal or `not´ or `%-´ or `%+´ or `~´ or `%$%$´',
        'expression'
    },
    {
        '`not´ or `%-´ or `%+´ or `~´ or `%$%$´ or `call´ or name expression or `&&´ or `&´ or `sizeof´ or `null´ or number or `false´ or `true´ or `"´ or string literal',
        'expression'
    },

    {
        '`nothing´ or `var´ or `vector´ or `pool´ or `event´ or `input´ or `output´ or `data´ or `code´ or `input/output´ or `output/input´ or `native´ or `deterministic´ or name expression or `await´ or `emit´ or `call/recursive´ or `call´ or `request´ or `spawn´ or `kill´ or `do´ or `if´ or `loop´ or `every´ or `par/or´ or `par/and´ or `watching´ or `pause/if´ or `atomic´ or `pre´ or `%[´ or `lua´ or `escape´ or `break´ or `continue´ or `par´ or end of file',
        'statement'
    },
    {
        '`nothing´ or `var´ or `vector´ or `pool´ or `event´ or `input´ or `output´ or `data´ or `code´ or `input/output´ or `output/input´ or `native´ or `deterministic´ or name expression or `await´ or `emit´ or `call/recursive´ or `call´ or `request´ or `spawn´ or `kill´ or `do´ or `if´ or `loop´ or `every´ or `par/or´ or `par/and´ or `watching´ or `pause/if´ or `atomic´ or `pre´ or `%[´ or `lua´ or `escape´ or `break´ or `continue´ or `par´ or `end´',
        'statement'
    },
    {
        '`nothing´ or `var´ or `vector´ or `pool´ or `event´ or `input´ or `output´ or `data´ or `code´ or `input/output´ or `output/input´ or `native´ or `deterministic´ or `%*´ or name expression or `await´ or `emit´ or `call/recursive´ or `call´ or `request´ or `spawn´ or `kill´ or `do´ or `if´ or `loop´ or `every´ or `par/or´ or `par/and´ or `watching´ or `pause/if´ or `atomic´ or `pre´ or `%[´ or `lua´ or `escape´ or `break´ or `continue´ or `par´ or end of file',
        'statement'
    },
}
if TESTS then
    TESTS.parser_translate = TESTS.parser_translate or { ok={}, original=T }
end

-- ( ) . % + - * ? [ ] ^ $

local function translate (msg)
    for i,t in ipairs(T) do
        local fr,to = unpack(t)
        local new = string.gsub(msg, fr, to)
        if TESTS then
            if msg ~= new then
                TESTS.parser_translate.ok[i] = true
            end
        end
        msg = new
--return new
    end
    return msg
end

local ERR_i    = 0
local ERR_strs = {}
local LST_i    = 0
local LST_str  = 'begin of file'

local IGN = 0
local ign_inc   = m.Cmt(P'', function() IGN=IGN+1 return true  end)
local ign_dec_t = m.Cmt(P'', function() IGN=IGN-1 return true  end)
local ign_dec_f = m.Cmt(P'', function() IGN=IGN-1 return false end)

local function I (patt)
    return ign_inc * (patt*ign_dec_t + ign_dec_f*P(false))
end

local function ERR ()
--DBG(LST_i, ERR_i, ERR_strs, _I2L[LST_i], I2TK[LST_i])
    local file, line = unpack(CEU.i2l[LST_i])
    return 'ERR : '..file..
              ' : line '..line..
              ' : after `'..LST_str..'´'..
              ' : expected '..translate(table.concat(ERR_strs,' or '))
end

local function fail (i, err)
    if i==ERR_i and (not ERR_strs[err]) then
        ERR_strs[#ERR_strs+1] = err
        ERR_strs[err] = true
    elseif i > ERR_i then
        ERR_i = i
        ERR_strs = { err }
        ERR_strs[err] = true
    end
    return false
end

-- KK accepts leading chars
local function KK (patt, err, nox)
    if type(patt) == 'string' then
        err = err or '`'..patt..'´'
    else
        err = err or error(debug.traceback())
    end

    local ret = m.Cmt(patt,
                    -- SUCCESS
                    function (_, i, tk)
                        if IGN>0 then return true end
if __debug then
    DBG(string.rep(' ',spc)..'|||', '|'..tk..'|')
end
                        if i > LST_i then
                            LST_i   = i
                            LST_str = tk
                        end
                        return true
                    end)
              + m.Cmt(P'',
                    -- FAILURE
                    function (_,i)
                        if err==true or IGN>0 then return false end
                        return fail(i,err)
                    end) * P(false)
                           -- (avoids "left recursive" error (explicit fail))

    if not nox then
        ret = ret * x
    end
    return ret
end

-- K is exact match
local function K (patt, err, nox)
    err = err or '`'..patt..'´'
    patt = patt * -m.R('09','__','az','AZ','\127\255')
    return KK(patt, err, nox)
end

local CKK = function (tk,err,nox)
    local patt = C(KK(tk,err,true))
    if nox == nil then
        patt = patt * x
    end
    return patt
end
local CK = function (tk,err,nox)
    local patt = C(K(tk,err,true))
    if nox == nil then
        patt = patt * x
    end
    return patt
end

local OPT = function (patt)
    return patt + Cc(false)
end

local PARENS = function (patt)
    return KK'(' * patt * KK')'
end

local function LIST (patt)
    return patt * (KK','*patt)^0 * KK','^-1
end

local E = function (msg)
    return m.Cmt(P'',
            function (_,i)
                return fail(i,msg)
            end)
end

-- TODO; remove
local EE = function (msg)
    return m.Cmt(P'',
            function (_,i)
                TESTS_TODO = true
                return fail(i,msg)
            end)
end

-->>> OK
local TYPES = P'bool' + 'byte'
            + 'f32' + 'f64' + 'float'
            + 'int'
            + 's16' + 's32' + 's64' + 's8'
            + 'ssize'
            + 'u16' + 'u32' + 'u64' + 'u8'
            + 'uint' + 'usize' + 'void'
--<<<

-- must be in reverse order (to count superstrings as keywords)
KEYS = P
'with' +
'watching' +
'vector' +
'var' +
'val' +
'until' +
'true' +
'traverse' +
'tight' +
'thread' +
'then' +
'static' +
'spawn' +
'sizeof' +
'resume' +
'request' +
'recursive' +
'pure' +
'pre' +
'pos' +
'pool' +
'plain' +
'pause' +
'par' +
'output' +
'outer' +
'or' +
'null' +
'nothing' +
'not' +
'nohold' +
'new' +
'native' +
'lua' +
'loop' +
'kill' +
'isr' +
'is' +
'input' +
'in' +
'if' +
'hold' +
'FOREVER' +
'finalize' +
'false' +
'every' +
'event' +
'escape' +
'end' +
'emit' +
'else' +
'dynamic' +
'do' +
'deterministic' +
'data' +
'continue' +
'const' +
'code' +
'call' +
'break' +
'await' +
'atomic' +
'async' +
'as' +
'and' +
TYPES

KEYS = KEYS * -m.R('09','__','az','AZ','\127\255')

local Alpha    = m.R'az' + '_' + m.R'AZ'
local Alphanum = Alpha + m.R'09'
local ALPHANUM = m.R'AZ' + '_' + m.R'09'
local alphanum = m.R'az' + '_' + m.R'09'

-- Rule:    unchanged in the AST
-- _Rule:   changed in the AST as "Rule"
-- __Rule:  container for other rules, not in the AST
-- __rule:  (local) container for other rules

GG = { [1] = x * V'_Stmts' * V'Y' * (P(-1) + E('end of file'))

-->>> OK

    , Y = C''     -- yielding point

    , __seqs = KK';' * KK(';',true)^0     -- "true": ignore as "expected"
    , Nothing = K'nothing'

-- DO, BLOCK

    -- escape/A 10
    -- break/i
    -- continue/i
    , _Escape   = K'escape'   * ('/'*V'ID_int' + Cc(true)) * OPT(V'__Exp')
    , Break    = K'break'    * OPT('/'*V'ID_int') * V'Y'
    , Continue = K'continue' * OPT('/'*V'ID_int')

    -- do/A ... end
    , Do = K'do' * ('/'*(V'ID_int'+V'ID_any') + Cc(true)) *
                V'Block' *
           K'end'

    , __Do  = K'do' * V'Block' * K'end'
    , _Dopre = K'pre' * V'__Do'

    , Block = V'_Stmts'

-- PAR, PAR/AND, PAR/OR

    , Par     = K'par' * K'do' *
                 V'Block' * (K'with' * V'Block')^1 *
                K'end'
    , Par_And = K'par/and' * K'do' *
                    V'Block' * (K'with' * V'Block')^1 *
                K'end'
    , Par_Or  = K'par/or' * K'do' *
                    V'Block' * (K'with' * V'Block')^1 *
                K'end'

-- FLOW CONTROL

    , _If = K'if' * V'__Exp' * K'then' * V'Block' *
            (K'else/if' * V'__Exp' * K'then' * V'Block')^0 *
            OPT(K'else' * V'Block') *
            K'end'

    , _Loop_Num_Range = (CKK'[' + CKK']') * (
                            V'__Exp' * CKK'->' * (V'ID_any' + V'__Exp') +
                            (V'ID_any' + V'__Exp') * CKK'<-' * V'__Exp'
                          ) * (CKK'[' + CKK']') *
                          OPT(KK',' * V'__Exp')

    , _Loop_Num = K'loop' * OPT('/'*V'__Exp') *
                    (V'__ID_int'+V'ID_any') * OPT(K'in' * V'_Loop_Num_Range') *
                  V'__Do'
    , Loop_Pool = K'loop' * OPT('/'*V'__Exp') *
                    OPT(PARENS(V'List_Var')) *
                        K'in' * V'Exp_Name' *
                  V'__Do'
    , Loop      = K'loop' * OPT('/'*V'__Exp') *
                  V'__Do'

    , _Every  = K'every' * OPT((V'Exp_Name'+PARENS(V'List_Name')) * K'in') *
                    (V'Await_Ext' + V'Await_Int' + V'Await_Wclock') *
                V'__Do'

    , Stmt_Call = V'Abs_Call' + V'Nat_Call'

    , __fin_stmt  = V'___fin_stmt' * V'__seqs'
    , ___fin_stmt = V'Nothing'
                  + V'_Set'
                  + V'Emit_Ext_emit' + V'Emit_Ext_call'
                  + V'Stmt_Call'
    , __finalize  = K'finalize' * (PARENS(V'List_Name') + Cc(false)) * K'with' *
                        V'Block' *
                    OPT(K'pause'  * K'with' * V'Block') *
                    OPT(K'resume' * K'with' * V'Block') *
                    K'end'
    , Finalize = K'do' * OPT(V'__fin_stmt') * V'__finalize'

    , _Var_set_fin = K'var' * KK'&?' * V'Type' * V'__ID_int'
                   * (KK'='-'==') * KK'&'
                    * (V'Nat_Call' + V'Abs_Call')
                     * V'__finalize'

    , Pause_If = K'pause/if' * (V'Exp_Name'+V'ID_ext') * V'__Do'

-- ASYNCHRONOUS

    , Async        = K'await' * K'async' * (-P'/thread'-'/isr') * V'Y' *
                        OPT(PARENS(V'List_Var')) * V'__Do'
    , Async_Thread = K'await' * K'async/thread' * V'Y' *
                        OPT(PARENS(V'List_Var')) * V'__Do'
    , Async_Isr    = K'spawn' * K'async/isr' * KK'[' * V'List_Exp' * KK']' *
                        OPT(PARENS(V'List_Var')) * V'Y' *
                     V'__Do'
    , Atomic  = K'atomic' * V'__Do'

-- CODE / EXTS (call, req)

    -- CODE

    , __code = K'code' * Ct( Cg(K'/tight'*Cc'tight','tight') *
                             Cg(K'/dynamic'*Cc'dynamic','dynamic')^-1 *
                             Cg(K'/recursive'*Cc'recursive','recursive')^-1 ) *
                (V'__ID_abs'-V'__id_data') *
                    V'Code_Pars' * KK'->' *
                        Cc(false) *
                            (#V'Type' * V'Code_Ret')
             + K'code' * Ct( Cg(K'/await'*Cc'await','await') *
                             Cg(K'/dynamic'*Cc'dynamic','dynamic')^-1 *
                             Cg(K'/recursive'*Cc'recursive','recursive')^-1 ) *
                (V'__ID_abs'-V'__id_data') *
                    V'Code_Pars' * KK'->' *
                        OPT(V'_Code_Pars_Init' * KK'->') *
                            V'Code_Ret'

    , _Code_proto = V'Y' * V'__code' * Cc(false)
    , _Code_impl  = V'Y' * V'__code' * V'__Do' * V'Y'

    , _Spawn_Block = K'spawn' * V'__Do'

    -- EXTS

    -- call
    , __extcode = (CK'input/output' + CK'output/input') * K'/tight'
                    * OPT(CK'/recursive')
                    * V'__ID_ext' * V'Code_Pars' * KK'->' * V'Type'
* EE'TODO-PARSER: extcode'
    , _Ext_Code_proto = V'__extcode'
    , _Ext_Code_impl  = V'__extcode' * V'__Do'

    -- req
    , __extreq = (CK'input/output' + CK'output/input') * K'/await'
                   * OPT('[' * (V'__Exp'+Cc(true)) * KK']')
                   * V'__ID_ext' * V'Code_Pars' * KK'->' * V'Type'
* EE'TODO-PARSER: request'
    , _Ext_Req_proto = V'__extreq'
    , _Ext_Req_impl  = V'__extreq' * V'__Do'

    -- TYPEPARS

    -- (var& int, var/nohold void&&)
    -- (var& int v, var/nohold void&& ptr)
    , __typepars = Cc{} * CK'vector' * CKK'&' * V'__Dim' * V'Type'
                 + Cc{} * CK'pool'   * CKK'&' * V'__Dim' * V'Type'
                 + Cc{} * CK'event'  * CKK'&' * Cc(false) * (PARENS(V'Typelist') + V'Type')
                 + Ct(Cg(K'dynamic','dynamic')^-1)
                        * CK'var'    * OPT(CKK'&') * OPT(KK'/'*CK'hold') * V'Type'
    , _Code_Pars_Item  = V'__typepars' * OPT(V'__ID_int')

    , __typepars_init = Cc{} * CK'vector' * CKK'&' * V'__Dim' * V'Type'
                      + Cc{} * CK'pool'   * CKK'&' * V'__Dim' * V'Type'
                      + Cc{} * CK'event'  * (V'__ALS') * Cc(false) * (PARENS(V'Typelist') + V'Type')
                      + Cc{} * CK'var'    * (V'__ALS') * Cc(false) * V'Type'
    , _Code_Pars_Init_Item = V'__typepars_init' * OPT(V'__ID_int')

    , Code_Pars = #KK'(' * (
                    PARENS(P'void') +
                    PARENS(LIST(V'_Code_Pars_Item'))
                  )
    , _Code_Pars_Init = #KK'(' * (
                    PARENS(P'void') +
                    PARENS(LIST(V'_Code_Pars_Init_Item'))
                  )
    , Code_Ret = (V'Type' + CK'FOREVER')

-- DATA

    , __data       = K'data' * V'__ID_abs' * OPT(KK'as' * (V'__Exp'+CK'nothing'))
    , _Data_simple = V'__data'
    , _Data_block  = V'__data' * K'with' * (
                        (V'_Vars_set'+V'_Vecs_set'+V'_Pools_set'+V'_Evts_set') *
                            V'__seqs'
                     )^1 * K'end'

-- NATIVE, C, LUA

    -- C

    , _Nats  = K'native' *
                    OPT(KK'/'*(CK'pure'+CK'const'+CK'nohold'+CK'plain')) *
                        LIST(V'__ID_nat')
        --> Nat+

    , Nat_End = K'native' * KK'/' * K'end'
    , Nat_Block = K'native' * (CK'/pre'+CK'/pos') * (#K'do')*'do' *
                ( C(V'_C') + C((P(1)-(S'\t\n\r '*'end'*P';'^0*'\n'))^0) ) *
             x* K'end'

    , Nat_Stmt = KK'{' * V'__nat1' * KK'}'
    , _Nat_Exp = KK'{' * V'__nat1' * KK'}'
    , __nat1   = (V'__nat2' + C'{'*V'__nat1'*C'}')^0
    , __nat2   = C((1-S'{}'-V'__exp')^1) + V'__exp'

    , Nat_Call = (CK'call' + Cc'call') * (V'Exp_Name'+PARENS(V'__Exp')) *
                                            PARENS(OPT(V'List_Exp'))

    -- Lua

    , _Lua_Do  = K'lua' * V'__Dim' * V'__Do'
    , _Lua     = KK'[' * m.Cg(P'='^0,'lua') * KK('[',nil,true) *
                 ( V'__exp' + C((P(1)-V'__exp'-V'__luacmp')^1) )^0
                  * (V'__luacl'/function()end) *x
    , __luacl  = ']' * C(P'='^0) * KK']'
    , __luacmp = m.Cmt(V'__luacl' * m.Cb'lua',
                    function (s,i,a,b) return a == b end)

    , __exp = P'@' * V'__Exp'

-- VARS, VECTORS, POOLS, VTS, EXTS

    -- DECLARATIONS

    , __ALS = (CKK'&?' + CKK'&')

    , __vars_set  = V'__ID_int' * OPT(Ct(V'__Sets_one'+V'__Sets_many'))

    , _Vars_set  = K'var' * OPT(V'__ALS') * V'Type' *
                    LIST(V'__vars_set')
    , _Vars      = K'var' * OPT(V'__ALS') * V'Type' *
                    LIST(V'__ID_int')

    , _Vecs_set  = K'vector' * OPT(CKK'&') * V'__Dim' * V'Type' *
                    LIST(V'__vars_set')
                        -- TODO: only vec constr
    , _Vecs      = K'vector' * OPT(CKK'&') * V'__Dim' * V'Type' *
                    LIST(V'__ID_int')

    , _Pools_set = K'pool' * OPT(CKK'&') * V'__Dim' * V'Type' *
                    LIST(V'__vars_set')
    , _Pools     = K'pool' * OPT(CKK'&') * V'__Dim' * V'Type' *
                    LIST(V'__ID_int')

    , _Evts_set  = K'event' * OPT(V'__ALS') * (PARENS(V'Typelist')+V'Type') *
                    LIST(V'__vars_set')
    , _Evts      = K'event' * OPT(V'__ALS') * (PARENS(V'Typelist')+V'Type') *
                    LIST(V'__ID_int')

    , _Exts      = (CK'input'+CK'output') * (PARENS(V'Typelist')+V'Type') *
                    LIST(V'__ID_ext')
    , Typelist   = LIST(V'Type')

-- AWAIT, EMIT

    , __Awaits_one  = K'await' * (V'Await_Wclock' + V'Abs_Await')
    , __Awaits_many = K'await' * V'Await_Until'

    , Await_Until  = (V'Await_Ext' + V'Await_Int') * OPT(K'until'*V'__Exp')

    , Await_Ext    = V'ID_ext'   * V'Y' -I(V'Abs_Await')                 -- TODO: rem
    , Await_Int    = V'Exp_Name' * V'Y' -I(V'Await_Wclock'+V'Abs_Await') -- TODO: rem
    , Await_Wclock = (V'WCLOCKK' + V'WCLOCKE') * V'Y'

    , Await_Forever = K'await' * K'FOREVER' * V'Y'
    , Await_Pause   = K'await' * K'pause'   * V'Y'
    , Await_Resume  = K'await' * K'resume'  * V'Y'

    , _Emit_ps = OPT(V'__Exp' + PARENS(OPT(V'List_Exp')))
    , Emit_Wclock   = K'emit' * (V'WCLOCKK'+V'WCLOCKE')
    , Emit_Ext_emit = K'emit'                     * V'ID_ext' * V'_Emit_ps'
    , Emit_Ext_call = (K'call/recursive'+K'call') * V'ID_ext' * V'_Emit_ps'
    , Emit_Ext_req  = K'request'                  * V'ID_ext' * V'_Emit_ps'
* EE'TODO-PARSER: request'

    , Emit_Evt = K'emit' * -#(V'WCLOCKK'+V'WCLOCKE') * V'Exp_Name' * V'_Emit_ps' * V'Y'

    , __watch = (V'Await_Ext' + V'Await_Int' + V'Await_Wclock' + V'Abs_Await')
    , _Watching = K'watching'
                    * LIST(V'__watch')
                * V'__Do'

    , __num = CKK(m.R'09'^1,'number') / tonumber
    , WCLOCKK = #V'__num' *
                (V'__num' * KK'h'   *x + Cc(0)) *
                (V'__num' * KK'min' *x + Cc(0)) *
                (V'__num' * KK's'   *x + Cc(0)) *
                (V'__num' * KK'ms'  *x + Cc(0)) *
                (V'__num' * KK'us'  *x + Cc(0))
                    * OPT(CK'/_')
    , WCLOCKE = PARENS(V'__Exp') * (
                    CK'h' + CK'min' + CK's' + CK'ms' + CK'us'
                  + E'<h,min,s,ms,us>'
              ) * OPT(CK'/_')

-- DETERMINISTIC

    , __det_id = V'ID_ext' + V'ID_int' + V'ID_nat'
    , Deterministic = K'deterministic' * V'__det_id' * (
                        K'with' * LIST(V'__det_id')
                      )^-1

-- ABS
    , __abs_mods = Ct ( (Cg(K'/dynamic'*Cc'dynamic','dynamic') +
                         Cg(K'/static' *Cc'static', 'static'))^-1 *
                         Cg(K'/recursive'*Cc'recursive','recursive')^-1 )
    , Abs_Call  = K'call' * V'__abs_mods' * (V'Abs_Cons' -I(V'__id_data'))
    , Abs_Val   = CK'val' * V'Abs_Cons'
    , Abs_New   = CK'new' * V'Abs_Cons'
    , Abs_Await = V'__Abs_Cons_Code'
        -- TODO: "await Abs_Await" should not accept "-> (...)"
        --       but "watching Abs_Await" does

    , Abs_Spawn_Single = K'spawn' * V'__Abs_Cons_Code' * (-KK'in') * Cc(false)
    , Abs_Spawn_Pool   = K'spawn' * V'__Abs_Cons_Code' * KK'in' * V'Exp_Name'

    , __Abs_Cons_Code = V'__abs_mods' * (V'Abs_Cons' -I(V'__id_data')) *
                            OPT(KK'->' * PARENS(V'_List_Var_Ref')) * V'Y'
    , Abs_Cons   = V'ID_abs' * PARENS(OPT(V'Abslist'))
    , Abslist    = LIST(V'__abs_item')^-1
    , __abs_item = (V'Abs_Cons' + V'Vec_Cons' + V'__Exp' + V'ID_any')


-- SETS

    , _Set = V'Exp_Name' * V'__Sets_one'
           + (V'Exp_Name' + PARENS(V'List_Name')) * V'__Sets_many'

    , __Sets_one  = (KK'='-'==') * (V'__sets_one'  + PARENS(V'__sets_one'))
    , __Sets_many = (KK'='-'==') * (V'__sets_many' + PARENS(V'__sets_many'))

    , __sets_one =
          V'_Set_Do'
        + V'_Set_Await_one'
        + V'_Set_Async_Thread'
        + V'_Set_Lua'
        + V'_Set_Vec'
        + V'_Set_Emit_Wclock'
        + V'_Set_Emit_Ext_emit' + V'_Set_Emit_Ext_call'
        + V'_Set_Abs_Val'
        + V'_Set_Abs_New'
        + V'_Set_Abs_Spawn_Pool'
        + V'_Set_Any'
        + V'_Set_Exp'

    , __sets_many = V'_Set_Emit_Ext_req' + V'_Set_Await_many' + V'_Set_Watching'

    -- after `=´

    , _Set_Do             = #K'do'            * V'Do'

    , _Set_Await_one      = #K'await'         * V'__Awaits_one'
    , _Set_Await_many     = #K'await'         * V'__Awaits_many'
    , _Set_Watching       = #K'watching'      * V'_Watching'

    , _Set_Async_Thread   = #(K'await' * K'async/thread') * V'Async_Thread'
    , _Set_Lua            = #V'__lua_pre'     * V'_Lua'
    , _Set_Lua_Do         =                     V'_Lua_Do'
    , _Set_Vec            =                     V'Vec_Cons'

    , _Set_Emit_Wclock    = #K'emit'          * V'Emit_Wclock'
    , _Set_Emit_Ext_emit  = #K'emit'          * V'Emit_Ext_emit'
    , _Set_Emit_Ext_req   = #K'request'       * V'Emit_Ext_req'
    , _Set_Emit_Ext_call  = #V'__extcode_pre' * V'Emit_Ext_call'

    , _Set_Abs_Val        = #K'val'           * V'Abs_Val'
    , _Set_Abs_New        = #K'new'           * V'Abs_New'
    , _Set_Abs_Spawn_Pool = #K'spawn'         * V'Abs_Spawn_Pool'

    , _Set_Any            = #K'_'             * V'ID_any'
    , _Set_Exp            =                     V'__Exp'

    , __extcode_pre = (K'call/recursive'+K'call') * V'ID_ext'
    , __lua_pre     = KK'[' * (P'='^0) * '['
    , __vec_pre     = KK'[' - V'__lua_pre'

    , __vec_concat = KK'..' * (V'__Exp' + V'_Lua' + #KK'['*V'Vec_Tup')
    , Vec_Tup  = V'__vec_pre' * OPT(V'List_Exp') * KK']'
    , Vec_Cons = V'__Exp'   * V'__vec_concat'^1
               + V'Vec_Tup' * V'__vec_concat'^0

-- IDS

    , ID_prim = V'__ID_prim'
    , ID_ext  = V'__ID_ext'
    , ID_int  = V'__ID_int'
    , ID_abs  = V'__ID_abs'
    , ID_nat  = V'__ID_nat'
    , ID_any  = V'__ID_any'

    , __ID_prim = CK(TYPES,                     'primitive type')
    , __ID_ext  = CK(m.R'AZ'*ALPHANUM^0  -KEYS, 'external identifier')
    , __ID_int  = CK(m.R'az'*Alphanum^0  -KEYS, 'internal identifier')
    , __ID_nat  = CK(P'_' * Alphanum^1,         'native identifier')
    , __ID_any  = CK(P'_' * -Alphanum,          '`_´')

    , __id_abs  = m.R'AZ'*V'__one_az' -KEYS
    , __id_data = V'__id_abs' * ('.' * V'__id_abs')^1
    , __ID_abs = CK(V'__id_data'+V'__id_abs', 'abstraction identifier')

    -- at least one lowercase character
    , __one_az = #(ALPHANUM^0*m.R'az') * Alphanum^0


-- MODS

    , __Dim = KK'[' * (V'__Exp'+Cc('[]')) * KK']'

-- LISTS

-- TODO: rename List_*
    , List_Name = LIST(V'Exp_Name' + V'ID_any')
    , List_Exp  = LIST(V'__Exp')
    , List_Var  = LIST(V'ID_int' + V'ID_any')
    , _List_Var_Ref = LIST(KK'&'*V'ID_int' + V'ID_any')

 --<<<

    , Kill  = K'kill' * V'Exp_Name' * OPT(PARENS(V'__Exp'))

-- Types

    , Type = (V'ID_prim' + V'ID_abs' + V'ID_nat') * (CKK'&&')^0 * CKK'?'^-1

-- Expressions

    -- Exp_Name

    , Exp_Name   = V'__01_Name'
    , __01_Name  = (Cc('pre') * (CKK'*'+(CKK'$'-'$$')))^-1 * V'__02_Name'
    , __02_Name  = V'__03_Name' *
                    (Cc'pos' * (
                        KK'[' * Cc'idx' * V'__Exp' * KK']' +
                        (CKK':' + (CKK'.'-'..')) * (V'__ID_int'+V'__ID_nat') +
                        (CKK'!'-'!=') * Cc(false)
                      )
                    )^0
    , __03_Name  = PARENS(V'__01_Name' *
                    (CK'as' * (V'Type' + KK'/'*(CK'nohold'+CK'plain'+CK'pure')))^-1
                   )
                 + V'ID_int'  + V'ID_nat'
                 + V'Outer'
                 + V'_Nat_Exp'

    -- Exp

    , __Exp  = V'__01'
    , __01   = V'__12' * ( CK'is' * V'Type'
                         + CK'as' * (V'Type' + KK'/'*(CK'nohold'+CK'plain'+CK'pure'))
                         )
             + V'__02'
    , __02   = V'__03' * (CK'or'  * V'__03')^0
    , __03   = V'__04' * (CK'and' * V'__04')^0
    , __04   = V'__05' * ( ( CKK'!='+CKK'=='+CKK'<='+CKK'>='
                           + (CKK'<'-'<<'-'<-')+(CKK'>'-'>>')
                           ) * V'__05'
                         )^0
    , __05   = V'__06' * ((CKK'|'-'||') * V'__06')^0
    , __06   = V'__07' * (CKK'^' * V'__07')^0
    , __07   = V'__08' * ((CKK'&'-'&&') * V'__08')^0
    , __08   = V'__09' * ((CKK'>>'+CKK'<<') * V'__09')^0
    , __09   = V'__10' * ((CKK'+'+(CKK'-'-'->')) * V'__10')^0
    , __10   = V'__11' * ((CKK'*'+(CKK'/'-'//'-'/*')+CKK'%') * V'__11')^0
    , __11   = ( Cc('pre') *
                    ( CK'not'+(CKK'-'-'->')+CKK'+'+CKK'~'+CKK'$$' )
               )^0 * V'__12'
    , __12   = V'Nat_Call'  -- TODO: ambiguous w/ PARENS,Name
             + V'Abs_Call'
             + V'Exp_Name' * (Cc'pos' * (CKK'?' * Cc(false)))^-1
             + Cc('pre') * CKK'&&'       * V'Exp_Name'
             + Cc('pre') * (CKK'&'-'&&') * (V'Nat_Call'+V'Exp_Name')
             + PARENS(V'__Exp')
             + V'SIZEOF'
             + V'NULL' + V'NUMBER' + V'BOOL' + V'STRING'

    , SIZEOF = K'sizeof' * PARENS((V'Type' + V'__Exp'))

    , NUMBER = CK( #m.R'09' * (m.R'09'+S'xX'+m.R'AF'+m.R'af'+(P'.'-'..')
                                      +(S'Ee'*'-')+S'Ee')^1,
                   'number' )
             --+ CKK( "'" * (P(1)-"'")^0 * "'" , 'number' )

    , BOOL   = K'false' / function() return 0 end
             + K'true'  / function() return 1 end
    , STRING = CKK( CKK'"' * (P(1)-'"'-'\n')^0 * K'"', 'string literal' )
    , NULL   = CK'null'     -- TODO: the idea is to get rid of this

    , Outer   = K'outer'

---------
                -- "Ct" as a special case to avoid "too many captures" (HACK_1)
    , _Stmts  = Ct (( V'__Stmt_Simple' * V'__seqs' +
                      V'__Stmt_Block' * (KK';'^0)
                   )^0
                 * ( V'__Stmt_Last' * V'__seqs' +
                     V'__Stmt_Last_Block' * (KK';'^0)
                   )^-1
                 * (V'Nat_Block'+V'_Code_impl')^0 )

    , __Stmt_Last  = V'_Escape' + V'Break' + V'Continue' + V'Await_Forever'
    , __Stmt_Last_Block = V'Y' * V'Par'
    , __Stmt_Simple = V'Nothing'
                    + V'_Vars_set'  + V'_Vars'
                    + V'_Vecs_set'  + V'_Vecs'
                    + V'_Pools_set' + V'_Pools'
                    + V'_Evts_set'  + V'_Evts'
                    + V'_Exts'
                    + V'_Data_simple'
                    + V'_Code_proto' + V'_Ext_Code_proto' + V'_Ext_Req_proto'
                    + V'_Nats'  + V'Nat_End'
                    + V'Deterministic'
                    + V'_Set'
                    + V'__Awaits_one' + V'__Awaits_many'
                    + V'Await_Pause' + V'Await_Resume'
                    + V'Emit_Wclock'
                    + V'Emit_Ext_emit' + V'Emit_Ext_call' + V'Emit_Ext_req'
                    + V'Emit_Evt'
                    + V'Abs_Spawn_Single' + V'Abs_Spawn_Pool' + V'Kill'
-- TODO: remove class/interface
+ I((K'class'+K'interface'+K'traverse')) * EE'TODO-PARSER: class/interface'
                    + V'Stmt_Call'

    , __Stmt_Block = V'_Code_impl' + V'_Ext_Code_impl' + V'_Ext_Req_impl'
              + V'_Data_block'
              + V'Nat_Block'
              + V'Do'    + V'_If'
              + V'Loop' + V'_Loop_Num' + V'Loop_Pool'
              + V'_Every'
              + V'_Spawn_Block'
              + V'Finalize'
              + V'Y'*V'Par_Or' + V'Y'*V'Par_And' + V'_Watching'
              + V'Pause_If'
              + V'Async' + V'Async_Thread' + V'Async_Isr' + V'Atomic'
              + V'_Dopre'
              + V'Nat_Stmt'
              + V'_Lua' + V'_Lua_Do'
              + V'_Var_set_fin'

    --, _C = '/******/' * (P(1)-'/******/')^0 * '/******/'
    , _C      = m.Cg(V'_CSEP','mark') *
                    (P(1)-V'_CEND')^0 *
                V'_CEND'
    , _CSEP = '/***' * (1-P'***/')^0 * '***/'
    , _CEND = m.Cmt(C(V'_CSEP') * m.Cb'mark',
                    function (s,i,a,b) return a == b end)

    , __SPACE = ('\n' * (V'__comm'+S'\t\n\r ')^0 *
                  '#' * (P(1)-'\n')^0)
              + ('//' * (P(1)-'\n')^0)
              + S'\t\n\r '
              + V'__comm'

    , __comm    = '/' * m.Cg(P'*'^1,'comm') * (P(1)-V'__commcmp')^0 * 
                    V'__commcl'
                    / function () end
    , __commcl  = C(P'*'^1) * '/'
    , __commcmp = m.Cmt(V'__commcl' * m.Cb'comm',
                    function (s,i,a,b) return a == b end)

}

if TESTS then
    assert(m.P(GG):match(CEU.source), ERR())
else
    if not m.P(GG):match(CEU.source) then
             -- TODO: match only in ast.lua?
        DBG(ERR())
        os.exit(1)
    end
end
