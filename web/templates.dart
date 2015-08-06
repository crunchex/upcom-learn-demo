part of updroid_learn;

class UpDroidLearnCode {
    static const String manipulation =
    r'''
#!/usr/bin/env python

import rospy, sys, time
from moveit_commander import RobotCommander, MoveGroupCommander, roscpp_initialize, roscpp_shutdown
from geometry_msgs.msg import PoseStamped
from sensor_msgs.msg import Joy
from tf.transformations import quaternion_from_euler

class TeleopEffJoy():
    def __init__(self):
        roscpp_initialize(sys.argv)
        rospy.init_node('teleop_eff_joy')
        rospy.Subscriber('joy', Joy, self.callback)
        self.robot = RobotCommander()
        self.initRobot()
        self.button_list = dict()
        self.initButtons()





        p = PoseStamped()
        p.header.frame_id = 'up1_footprint'
        p.pose.position.x = 0.12792118579
        p.pose.position.y = -0.285290879999
        p.pose.position.z = 0.120301181892
        roll = 0
        pitch = 0
        yaw = -1.57 #pi/2 radians

        q = quaternion_from_euler(roll, pitch, yaw)
        p.pose.orientation.x = q[0]
        p.pose.orientation.y = q[1]
        p.pose.orientation.z = q[2]
        p.pose.orientation.w = q[3]

        self.button_list['a'].setPose(p)
        self.button_list['a'].setArm(MoveGroupCommander('right_arm'))





        rospy.spin()
        moveit_commander.roscpp_shutdown()

    def initButtons(self):
        buttons = [['a',0],['b',1],['y',3],['LB',4],['back',8],['start',9],['power',16],['left_stick',10],['right_stick',11]]
        for button in buttons:
            self.button_list[button[0]] = Button(button[0],button[1])

    def initRobot(self):
        self.robot.right_arm.allow_replanning(True)
        self.robot.right_arm.allow_looking(True)
        self.robot.right_arm.set_goal_tolerance(0.05)
        self.robot.right_arm.set_planning_time(60)
        self.robot.right_arm.allow_replanning(True)
        self.robot.right_arm.allow_looking(True)
        self.robot.right_arm.set_goal_tolerance(0.05)
        self.robot.right_arm.set_planning_time(60)

    def callback(self, data):
        now = rospy.Time.now()

        for key, button in self.button_list.iteritems():
            if now > button.t_next:
                if data.buttons[button.button_id]:
                    button.doPose()
                    button.t_next = now + button.t_delta

class Button:
    def __init__(self, button_name, button_id):
        self.button_name = button_name
        self.button_id = button_id
        self.pose = 'none'
        self.arm = 'none'
        self.t_delta = rospy.Duration(.25)
        self.t_next = rospy.Time.now() + self.t_delta

    def setPose(self, pose):
        self.pose = pose

    def setArm(self, arm):
        self.arm = arm

    def doPose(self):
        if self.arm == 'none':
            rospy.loginfo('Arm not set for this button')
            return
        elif self.pose == 'none':
            rospy.loginfo('Pose not set for this button')
            return

        rospy.loginfo('Pose set: ' + self.pose)
        success = 0
        attempt = 0
        while not success:
            p_plan = self.arm.plan()
            attempt = attempt + 1
            rospy.loginfo('Planning attempt: ' + str(attempt))
            if p_plan.joint_trajectory.points != []:
                success = 1
        self.arm.execute(p_plan)

if __name__ == '__main__':
    teleopArmJoy = TeleopEffJoy()

    ''';

    static const String navigation =
    r'''
#!/usr/bin/env python
import roslib; roslib.load_manifest('teleop_twist_keyboard')
import rospy

from geometry_msgs.msg import Twist

import sys, select, termios, tty

msg = """
Reading from the keyboard  and Publishing to Twist!
---------------------------
Moving around:
   u    i    o
   j    k    l
   m    ,    .

q/z : increase/decrease max speeds by 10%
w/x : increase/decrease only linear speed by 10%
e/c : increase/decrease only angular speed by 10%
anything else : stop

CTRL-C to quit
"""

moveBindings = {
		'i':(1,0),
		'o':(1,-1),
		'j':(0,1),
		'l':(0,-1),
		'u':(1,1),
		',':(-1,0),
		'.':(-1,1),
		'm':(-1,-1),
	       }

speedBindings={
		'q':(1.1,1.1),
		'z':(.9,.9),
		'w':(1.1,1),
		'x':(.9,1),
		'e':(1,1.1),
		'c':(1,.9),
	      }

def getKey():
	tty.setraw(sys.stdin.fileno())
	select.select([sys.stdin], [], [], 0)
	key = sys.stdin.read(1)
	termios.tcsetattr(sys.stdin, termios.TCSADRAIN, settings)
	return key

speed = .5
turn = 1

def vels(speed,turn):
	return "currently:\tspeed %s\tturn %s " % (speed,turn)

if __name__=="__main__":
    	settings = termios.tcgetattr(sys.stdin)

	pub = rospy.Publisher('cmd_vel', Twist)
	rospy.init_node('teleop_twist_keyboard')

	x = 0
	th = 0
	status = 0

	try:
		print msg
		print vels(speed,turn)
		while(1):
			key = getKey()
			if key in moveBindings.keys():
				x = moveBindings[key][0]
				th = moveBindings[key][1]
			elif key in speedBindings.keys():
				speed = speed * speedBindings[key][0]
				turn = turn * speedBindings[key][1]

				print vels(speed,turn)
				if (status == 14):
					print msg
				status = (status + 1) % 15
			else:
				x = 0
				th = 0
				if (key == '\x03'):
					break

			twist = Twist()
			twist.linear.x = x*speed; twist.linear.y = 0; twist.linear.z = 0
			twist.angular.x = 0; twist.angular.y = 0; twist.angular.z = th*turn
			pub.publish(twist)

	except:
		print e

	finally:
		twist = Twist()
		twist.linear.x = 0; twist.linear.y = 0; twist.linear.z = 0
		twist.angular.x = 0; twist.angular.y = 0; twist.angular.z = 0
		pub.publish(twist)

    		termios.tcsetattr(sys.stdin, termios.TCSADRAIN, settings)

    ''';

  static const String joypad =
  r'''
#!/usr/bin/env python

import rospy, time
import sys, select, termios, tty
from sensor_msgs.msg import Joy


class JoyCMDR():
    def __init__(self):
        self.msg = """
        ***************************************************
        *                                                 *
        * Open Commander tab for Xbox Controller input    *
        * Controller input published to /joy ros topic    *
        *                                                 *
        * CTRL-C to quit                                  *
        *                                                 *
        ***************************************************
        """

        self.pub = rospy.Publisher('joy', Joy, queue_size=10)
        rospy.init_node('joy_cmdr')
        rospy.loginfo(self.msg)

        self.joy_msg = Joy()

        # define the function blocks
        def state_init(self):
            if self.key == '[':
                self.state = 1
        def state_axes(self):
            if self.key == ';':
                self.joy_msg.axes = [float(x) for x in self.line.split(',') if x.strip()]
                self.state = 2
                self.line = ''
                return
            self.line = self.line + self.key

        def state_buttons(self):
            if self.key == ']':
                self.joy_msg.buttons = [int(x) for x in self.line.split(',') if x.strip()]
                self.joy_msg.header.stamp = rospy.Time.now()
                self.pub.publish(self.joy_msg)
                self.state = 0
                self.line = ''
                return
            self.line = self.line + self.key

        # map the inputs to the function blocks
        states = {0 : state_init,
                  1 : state_axes,
                  2 : state_buttons}
        # initial state
        self.state = 0
        self.line = ''

        while 1:
            self.key = sys.stdin.read(1)
            if self.key == '\x03':
                return
            # call switch
            states[self.state](self)

        rospy.signal_shutdown('Shutting down joy_cmdr node')

if __name__ == '__main__':
    joyCMDR = JoyCMDR()

    ''';
}