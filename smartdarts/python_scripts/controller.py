import numpy as np

WIDTH_TARGET = 20

class closed_loops():
    def __init__(self, x_init, dt = 0.008):
        """the controller acting as a closed loops, we needs to compute the error in 2D and then return the displacement actions

            this controller is control as xd = Ax + Bu
                                          y = Cx + Du

            X is [x, y, xdot, ydot]
            xd is [xdd, ydd]
            Y is xdisp and ydisp
            xd = 
        """
        # kx = -0
        # ky = -0
        # cx = -0
        # cy = -0
        # k = -1
        # ku = 1
        # self.kp = 10
        # print("x_init = ", x_init)
        # self.x = x_init
 
        # # self.A = -k*np.eye(
        # #    4,4, 
        # # )

        # # self.A = k*np.array([[0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1], [-0, -0, -0.1, 1]])
        # # self.B = ku * np.array([[0 ,0], [0, 0], [0.008 ,0], [0, 0.008]]) # 0.2*np.array([[0 ,0], [0, 0], [1 ,0], [0, 1]])
        # # # self.dt = dt
        # self.A = np.array([[0, 1], [-1, -1]])
        # self.B = np.array([[1, 0], [0, 1]])
        # self.dt = 1
        # self.frame_in = 0
        # # self.Ad = (1 +  self.A*dt)
        # # self.Bd = self.B*dt

        # x position system [x, xdot]
        self.Ax = 0.08*np.array([[0, 1], [-1, -1]])
        self.Bx = np.array([[1], [0]])/12.5


        self.Ay = np.array([[0, 1], [-1, -1]]) * 0.08
        self.By = np.array([[1], [0]])/12.5

        self.xx = [x_init[0], 0]
        self.xy = [x_init[1] , 0]

        self.dt = 1


    def step(self, y_target, y_process):
        """_summary_

        Args:
            y_target (_type_): _description_
            y_process (_type_): should be equals to x[1,2]

        Returns:
           
            
        """
        print("y_target = ", y_target)
        print("y_process = ", y_process)
        err = y_target - y_process # is the input
        if np.linalg.norm(err) < WIDTH_TARGET:
            click_action = 1
        else :
            click_action = 0
        

        # x system
        # recontruct x with the x observed
        self.xx[0] = y_process[0] 
        xxdot = self.Ax @ self.xx + self.Bx @ [y_target[0]]
        self.xx = self.xx + xxdot*self.dt

        # y system
        # recontruct x with the x observed
        self.xy[0] = y_process[1] 
        xydot = self.Ay @ self.xy + self.By @  [y_target[1]]
        self.xy= self.xy + xydot*self.dt


        action = [xxdot[0] , xydot[0]]
        # # reconstruct x with the x observed

        # self.x[0:2] = y_process
        # print(y_target)
        # # construct input of the process
        # err = y_target - y_process # is the input


        # u = self.kp*err
        # u = y_target
        # # u =  # Bis id

        # # process step
        # xd = self.A @ self.x + self.B @ u
        # self.x = self.x + xd*self.dt
        # action = xd
        # print("self.x  at the end", self.x[2:], "err ", err)
        return action, click_action