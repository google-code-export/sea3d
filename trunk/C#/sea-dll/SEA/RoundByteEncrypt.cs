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

using System;
using System.Collections.Generic;
using System.Text;

namespace Sunag.SEA
{
    public class RoundByteEncrypt
    {
        public static string chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

        public string GetPassword(int count)
        {
            string data = "";
            Random random = new Random();

            for (int i = 0; i < count; i++)
            {
                data += chars[(int)Math.Round(random.NextDouble() * (chars.Length-1))];
            }

            return data;
        }

        public byte[] GetHashKey()
        {
            Random random = new Random();
            
            int limit = 8 + (int)(random.NextDouble() * 24);

            byte[] result = new byte[limit];

            for (int i = 0; i < limit; i++)
            {
                result[i] = (byte)(random.NextDouble() * 256);
            }

            return result;
        }

        public void Process(byte[] bytes, string password)
        {
            Process(bytes, Encoding.UTF8.GetBytes(password));
        }

        public void Process(byte[] bytes, byte[] round)
        {
            for (int i = 0; i < bytes.Length; i++)
            {   
                // Get Values
                int value = round[i % round.Length];
                int mod = round[value % round.Length];

                // Encrypty
                bytes[i] += (byte)mod;

                //Bug/Limitation C#: bytes[i] += round[i % round.Length] + (byte)i // i as unit; Not convert int to byte in assembly process
            }
        }
    }
}
