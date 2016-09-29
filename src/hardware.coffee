module.exports = (robot) ->
    robot.knee = robot.ax12(0)
    robot.leg = robot.ax12(0)

    robot.knee.speed(70)
    robot.knee.torque(50)

    robot.leg.speed(10)
    robot.leg.torque(50)


    robot.kneeFL = robot.knee.create(25)
    robot.kneeFR = robot.knee.create(20)
    robot.kneeRL = robot.knee.create(145)
    robot.kneeRR = robot.knee.create(161)

    robot.legFL = robot.leg.create(130)
    robot.legFR = robot.leg.create(129)
    robot.legRL = robot.leg.create(146)
    robot.legRR = robot.leg.create(162)

    robot.legFL.preset 'up', position: -40
    robot.legFR.preset 'up', position: 40
    robot.legRL.preset 'up', position: 40
    robot.legRR.preset 'up', position: -40

    robot.legFL.preset 'down', position: 0
    robot.legFR.preset 'down', position: 0
    robot.legRL.preset 'down', position: 0
    robot.legRR.preset 'down', position: 0

    robot.kneeFL.preset 'forward', position: -30
    robot.kneeFR.preset 'forward', position: 30
    robot.kneeRL.preset 'forward', position: 30
    robot.kneeRR.preset 'forward', position: -30

    robot.kneeFL.preset 'middle', position: 0
    robot.kneeFR.preset 'middle', position: 0
    robot.kneeRL.preset 'middle', position: 0
    robot.kneeRR.preset 'middle', position: 0

    robot.kneeFL.preset 'backward', position: 30
    robot.kneeFR.preset 'backward', position: -30
    robot.kneeRL.preset 'backward', position: -30
    robot.kneeRR.preset 'backward', position: 30

    robot.leg.preset 'down', position: 0, yes
    robot.knee.preset 'middle', position: 0, yes

    return robot
