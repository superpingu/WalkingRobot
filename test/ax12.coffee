# using chai-spies to check driver is called
chai = require 'chai'
chai.use(require 'chai-spies')
should = chai.should()
{assert, expect} = chai

describe 'AX12', ->
    ax12 = positions = driver = {}
    beforeEach ->
        # create a mockup for the ax12 driver object
        positions = {}
        driver =
            position: chai.spy((id) -> positions[id])
            setTorqueSpeed: chai.spy()
            move: chai.spy()
            reset: chai.spy()
        ax12 = require('../lib/robot/ax12')(driver)

    describe '.position()', ->
        it 'should return the position of the AX12 if the ID is not 0', ->
            positions[126] = 829
            positions[157] = 334
            ax12(126).position().should.equal 829
            ax12(157).position().should.equal 334
            driver.position.should.have.been.called.twice()
        it 'shouldnt call the driver if the ID is 0', ->

            positions[0] = 334
            expect(ax12(0).position()).to.be.undefined
            driver.position.should.not.have.been.called()
    describe '.speed()', ->
        it 'should change current speed on update if ID isnt 0', ->
            servo = ax12(126)
            servo.speed(500)
            servo.update()
            driver.setTorqueSpeed.should.have.been.called.with(126, -1, 500, 0)
        it 'should return current speed when called without argument', ->
            servo = ax12(149)
            servo.speed(432)
            servo.speed().should.equal 432
        it 'should not call anything if ID is 0', ->
            servo = ax12(0)
            servo.speed(500)
            servo.update()
            driver.setTorqueSpeed.should.not.have.been.called()
        it 'should change children speed if ID isnt 0', ->
            template = ax12(0)
            template.speed(200)
            servo = template.create(129)
            servo2 = template.create(127)
            servo.update()
            driver.setTorqueSpeed.should.have.been.called.with(129, -1, 200, 0)
            template.speed(500)
            servo.update()
            servo2.update()
            driver.setTorqueSpeed.should.have.been.called.with(129, -1, 500, 0)
            driver.setTorqueSpeed.should.have.been.called.with(127, -1, 500, 0)
    describe '.torque()', ->
        it 'should change current torque on update if ID isnt 0', ->
            servo = ax12(126)
            servo.torque(500)
            servo.update()
            driver.setTorqueSpeed.should.have.been.called.with(126, 500, -2000, 0)
        it 'should return current torque when called without argument', ->
            servo = ax12(148)
            servo.torque(432)
            servo.torque().should.equal 432
        it 'should not call anything if ID is 0', ->
            servo = ax12(0)
            servo.torque(500)
            servo.update()
            driver.setTorqueSpeed.should.not.have.been.called()
        it 'should change children torque if ID isnt 0', ->
            template = ax12(0)
            template.torque(200)
            servo = template.create(129)
            servo2 = template.create(127)
            servo.update()
            driver.setTorqueSpeed.should.have.been.called.with(129, 200, -2000, 0)
            template.torque(500)
            servo.update()
            servo2.update()
            driver.setTorqueSpeed.should.have.been.called.with(129, 500, -2000, 0)
            driver.setTorqueSpeed.should.have.been.called.with(127, 500, -2000, 0)
    describe '.update()', ->
        it 'should update speed and torque when changed', ->
            servo = ax12(140)
            servo.torque(200)
            servo.speed(500)
            servo.update()
            driver.setTorqueSpeed.should.have.been.called.with(140, 200, -2000, 0)
            driver.setTorqueSpeed.should.have.been.called.with(140, -1, 500, 0)
        it 'shouldnt update if the values are up to date', ->
            servo = ax12(140)
            servo.torque(200)
            servo.speed(500)
            servo.update()
            servo.update()
            servo.torque(200)
            servo.speed(500)
            servo.update()
            driver.setTorqueSpeed.should.have.been.called.twice()
        it 'shouldnt call anything if ID is 0', ->
            template = ax12(0)
            template.torque(200)
            template.speed(500)
            template.update()
            driver.setTorqueSpeed.should.not.have.been.called()
