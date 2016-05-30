DEFAULT = 0
WHEEL = 1

ax12 = (driver) ->
    setSpeed = (id, speed) ->
        driver.setTorqueSpeed(id, -1, speed, 0) if speed? and id? and 0 < id < 255
    setTorque = (id, torque) ->
        driver.setTorqueSpeed(id, torque, -2000, 0) if torque? and id? and 0 < id < 255
    setMode = (id, mode) ->
        driver.setTorqueSpeed(id, -1, -2000, mode) if (mode is 0 or mode is 1) and id? and 0 < id < 255

    create = (id) ->
        currentSpeed = -2000
        currentTorque = -1
        upToDate =
            speed: false,
            torque: false
        presets = {}
        children = []
        moveCallback = -> console.log "AX12 #{id} move finished"

        result =
            update: ->
                return if id is 0
                setSpeed(id, currentSpeed) unless upToDate.speed
                setTorque(id, currentTorque) unless upToDate.torque
                upToDate.speed = upToDate.torque = true;
            # set speed and torque are lazy, they don't actually change the value
            speed: (speed) ->
                return currentSpeed unless speed?
                upToDate.speed = speed == currentSpeed;
                currentSpeed = speed
                child.speed(speed) for child in children
            torque: (torque) ->
                return currentTorque unless torque?
                upToDate.torque = torque == currentTorque;
                currentTorque = torque
                child.torque(torque) for child in children
            position: ->
                return driver.position(id) if id isnt 0
            moveTo: (position, callback) ->
                moveCallback = callback if callback?
                if id isnt 0 # real AX12
                    result.update()
                    driver.move(id, position, moveCallback);
                else if children.length isnt 0 # abstract template : move all the real children
                    childrenLeft = children.length;
                    # call the callback only when all the real children finished moving
                    childCallback = -> moveCallback() if --childrenLeft is 0
                    child.moveTo(position, childCallback) for child in children
                else # abstract template without any child : call callback now
                    moveCallback()
            turn: (speed) ->
                if id isnt 0 # real AX12
                    upToDate.speed = true;
                    result.update()
                    driver.setTorqueSpeed(id, -1, speed, WHEEL);
                else if children.length isnt 0 # abstract template : move all the real children
                    child.turn(speed) for child in children

            preset: (name, preset) ->
                presets[name] = preset
                result[name] = ->
                    result.torque preset.torque if preset.torque?
                    if preset.mode? and preset.mode is 'wheel' # wheel mode
                        result.turn preset.speed if preset.speed?
                    else  # position mode
                        result.speed preset.speed if preset.speed?
                        result.moveTo preset.position if preset.position?
            presets: (presets) ->
                result.preset name, preset for name, preset of presets

            create: (id) ->
                newAX = create id
                newAX.speed currentSpeed
                newAX.torque currentTorque
                newAX.presets presets
                children.push newAX
                return newAX

        return result

module.exports = ax12
