/*
    context =
        ok: true/false login ok
        err: true/false login err
        user:
            name: user name
            passwd: user password
*/

require! 'aea': {check-login}

component-name = "login"
Ractive.components[component-name] = Ractive.extend do
    isolated: yes
    template: "\##{component-name}"
    oninit: ->
        self = @
        # check whether we are logged in
        check-login (@get \db), (err) ->
            if not err
                #console.log "Login component says: we are logged in..."
                self.fire \success
            else
                console.log "Login component says: we are not logged in!"
        @on do
            do-login: ->
                self = @
                db = @get \db
                user = self.get \context ._user
                ajax-opts = ajax: headers:
                    Authorization: "Basic #{window.btoa user.name + ':' + user.password}"
                #console.log "LOGIN: Logging in with #{user.name} and #{user.password}"
                err, res <- db.login user.name, user.password, ajax-opts
                if err
                    #console.log "LOGIN: Error while logging in: ", err
                    self.set \context.err, {msg: err.message}
                else
                    #console.log "LOGIN: Seems logged in succesfully: ", res
                    self.set \context.err, null
                    self.fire \success

            do-logout: ->
                self = @
                db = @get \db
                #console.log "LOGIN: Logging out!"
                err, res <- db.logout!
                #console.log "LOGIN: Logged out: err: #{err}, res: ", res
                self.set \context.ok, no if res.ok

            success: ->
                #console.log "LOGIN: Login component success... "
                db = @get \db
                self = @
                err, res <- db.get-session
                try
                    throw if res.user-ctx.name is null
                    self.set \context.ok, yes
                    self.set \context.err, null
                    self.set \context.user, res.user-ctx
                catch
                    #console.log "LOGIN: not logged in, returning: ", e
                    self.set \context.ok, no


    data:
        context: null
        db: null
