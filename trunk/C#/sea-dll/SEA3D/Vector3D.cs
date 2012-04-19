using System;
using System.Collections.Generic;
using System.Text;

namespace Sunag.SEA3D
{
    public class Vector3D
    {
        public static readonly Vector3D X_AXIS = new Vector3D(1, 0, 0);
        public static readonly Vector3D Y_AXIS = new Vector3D(0, 1, 0);
        public static readonly Vector3D Z_AXIS = new Vector3D(0, 0, 1);

        public double X = 0;
        public double Y = 0;
        public double Z = 0;

        public Vector3D()
        {
            X = Y = Z = 0;            
        }

        public Vector3D(double x, double y, double z)
        {
            X = x;
            Y = y;
            Z = z;
        }

        public void UniformScale(double s)
        {
            X *= s;
            Y *= s;
            Z *= s;
        }
    }
}
