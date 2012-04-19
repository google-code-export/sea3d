/* Copyright (C) 2012 Sunag Entertainment
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>. */

// References: away3d.core.math.Quaternion.as <http://www.away3D.com>

using System;
using System.Collections.Generic;
using System.Text;

namespace Sunag.SEA3D
{
    public class Quaternion
    {
        public double X;
        public double Y;
        public double Z;
        public double W;

        public Quaternion()
        {
            X = Y = Z = 0;
            W = 1;
        }

        public Quaternion (double x, double y, double z, double w)
        {
            X = x; Y = y; Z = z; W = w;
        }

        public void FromEulerAngles(double x, double y, double z, string order)
        {
            FromEuler(x * MathHelper.RADIANS, y * MathHelper.RADIANS, z * MathHelper.RADIANS, order);
        }

        public void FromEuler(double x, double y, double z, string order)
        {
            Quaternion quat = null;

            Quaternion q1 = Quaternion.CreatFromAxis(Vector3D.X_AXIS, x);
            Quaternion q2 = Quaternion.CreatFromAxis(Vector3D.Y_AXIS, y);
            Quaternion q3 = Quaternion.CreatFromAxis(Vector3D.Z_AXIS, z);
                        
            if (order == "xyz")
            {
                quat = q2;
                quat.Multiply(quat, q3);
                quat.Multiply(quat, q1);
            }
            // xzy = standard
            else if (order == "xzy")
            {
                quat = q3;
                quat.Multiply(quat, q2);
                quat.Multiply(quat, q1);
            }

            if (quat != null)
            {
                X = quat.X;
                Y = quat.Y;
                Z = quat.Z;
                W = quat.W;
            }
        }

        public void FromAxisAngle(Vector3D axis, double angle)
        {
            FromAxis(axis, angle * MathHelper.RADIANS);
        }

        public void FromAxis(Vector3D axis, double angle)
		{
            angle /= 2;

            double sin_a = Math.Sin(angle);
            double cos_a = Math.Cos(angle);

            X = axis.X * sin_a;
            Y = axis.Y * sin_a;
            Z = axis.Z * sin_a;
            W = cos_a;

            Normalize();
		}

        public void Normalize()
        {
            Normalize(1);
        }

        public void Normalize(double val)
		{
			double mag = val / Math.Sqrt(X * X + Y * Y + Z * Z + W * W);

			X *= mag;
			Y *= mag;
			Z *= mag;
			W *= mag;
		}

        public void Multiply(Quaternion qa, Quaternion qb)
        {
            double w1 = qa.W, x1 = qa.X, y1 = qa.Y, z1 = qa.Z;
            double w2 = qb.W, x2 = qb.X, y2 = qb.Y, z2 = qb.Z;

            W = w1 * w2 - x1 * x2 - y1 * y2 - z1 * z2;
            X = w1 * x2 + x1 * w2 + y1 * z2 - z1 * y2;
            Y = w1 * y2 - x1 * z2 + y1 * w2 + z1 * x2;
            Z = w1 * z2 + x1 * y2 - y1 * x2 + z1 * w2;
        }

        public Vector3D ToEulerAngles()
        {
            Vector3D euler = ToEuler();
            euler.UniformScale(MathHelper.DEGREES);
            return euler;
        }

        public Vector3D ToEuler()
		{
            return new Vector3D
            (
			    Math.Atan2(2 * (W * X + Y * Z), 1 - 2 * (X * X + Y * Y)),
			    Math.Asin(2 * (W * Y - Z * X)),
			    Math.Atan2(2 * (W * Z + X * Y), 1 - 2 * (Y * Y + Z * Z))
            );
		}

        public static Quaternion CreatFromAxis(Vector3D axis, double angle)
        {
            Quaternion quat = new Quaternion();
            quat.FromAxis(axis, angle);            
            return quat;
        }
    }
}
