import numpy as np



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
        kx = -0
        ky = -0
        cx = -0
        cy = -0
        k = -0.5
        print("x_init = ", x_init)
        self.x = x_init
        # self.A = np.array([[k, 0],  [0, k]])
        self.A = -np.eye(
           4,4, 
        )
        self.B = 0.2*np.array([[0 ,0], [0, 0], [1 ,0], [0, 1]]) # old 10*np.array([[1 ,0], [-0.5, 1]])
        # self.dt = dt
        self.dt = 0.08
        # self.Ad = (1 +  self.A*dt)
        # self.Bd = self.B*dt

    def step(self, y_target, y_process):
        """_summary_

        Args:
            y_target (_type_): _description_
            y_process (_type_): should be equals to x[1,2]

        Returns:
            _type_: _description_
        """
        # reconstruct x with the x observed
        self.x[0:2] = y_process


        # construct input of the process
        err = y_target - y_process # is the input
        u = err
        
        # process step
        xd = self.A @ self.x + self.B  @ u
        self.x = self.x + xd*self.dt
        action = self.x[2:4]

        return action