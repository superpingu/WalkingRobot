robot = require("@superpingu/walkinglib")()

# load hardware configuration and movement sequences
robot = require('./hardware')(robot)
robot = require('./sequences')(robot)

robot.startPosition.start ->
    robot.stepForward.start ->
        console.log 'one step further !'
