# for debugging purposes
start-time = new Date! .get-time!

export debug-log = (...x) ->
    console.log.apply this, [(new Date! .get-time! - start-time) + "ms : "]  ++ x

function align-left width, inp
    x = (inp + " " * width).slice 0, width

export get-logger = (debug-source, opts={}) ->
    (...x) ->
        return if debug-level is \silent
        if opts.incremental
            timestamp = (new Date! .get-time! - start-time) + "ms"
        else
            timestamp = Date!
        console.log.apply this, ["#{timestamp}:", (align-left 15, "#{debug-source}") + ":"] ++ x

export debug-levels =
    silent: 0
    normal: 1
    verbose: 2
    debug: 3

export class logger
    (source-name, opts={}) ->
        @source-name = source-name
        @level = debug-levels.normal
        @opts = opts
        @start-time = start-time


    log: (...args) ->
        if @level > debug-levels.silent
            console.log.apply this, [@_get-prefix!] ++ args

    debug-log: (...args) ->
        if @level >= debug-levels.debug
            @log ...args

    err: (...args) ->
        if @level > debug-levels.silent
            console.error.apply this, [@_get-prefix!] ++ args

    debug-err: (...args) ->
        ...

    _get-timestamp: ->
        "#{new Date! .get-time! - @start-time}ms"

    _get-prefix: ->
        src-name = align-left 15, "#{@source-name}"
        "#{@_get-timestamp!}: #{src-name} :"

if testing=no
    a = new logger \a
    a.log "hello there"
    # =>
    # 1ms: a               : hello there
