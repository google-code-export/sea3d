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
using System.Windows.Forms;
using Sunag.IO;
using System.Threading;

namespace Sunag.SEA
{
    public class Assets
    {        
        public static readonly byte Version = 1;
        public static readonly byte Subversion = 0;        

        private List<File> list = new List<File>();

        private string type;

        private byte compressMethod = 0;
        private byte protectMethod = 0;

        private string password = null;

        public Assets(string type)
        {
            this.type = type;
        }

        public byte[] Build()
        {
            // Write Head
            ByteArray bytes = new ByteArray();
            RoundByteEncrypt encrypt = new RoundByteEncrypt();

            // Write Extension File
            bytes.WriteUTFBytes("SEA");

            // Write Version
            bytes.WriteByte(Version);
            bytes.WriteByte(Subversion);

            // Write Type File
            bytes.WriteUTFTiny(type);

            // Write Password Method
            bool useProtect = password != null && password.Length > 0;
            bytes.WriteByte(useProtect ? protectMethod : (byte)0);           

            // Write Compress Method
            bytes.WriteByte(compressMethod);

            // Write Body
            ByteArray data = new ByteArray();

            // Get Hash            
            if (useProtect)
            {
                if (protectMethod == 1)
                {
                    byte[] hash = encrypt.GetHashKey();

                    data.WriteByte((byte)hash.Length);
                    data.WriteBytes(hash);
                }
            }

            // Write Packets ID
            data.WriteShort((short)list.Count);
            foreach (File packet in list)
            {
                data.WriteUTFTiny(packet.Name);
                data.WriteUTFTiny(packet.Type);
                data.WriteUInt(packet.Data.Length);
            }

            // Write Packets Data            
            foreach (File packet in list)
            {
                data.WriteBytes(packet.Data.ToArray());
            }

            // Process Compress Method
            if (compressMethod > 0)
            {
                if (compressMethod == 1)
                {
                    data.Compress();
                }
                else if (compressMethod == 2)
                {
                    data.Deflate();
                }
            }

            // Process Protect Method
            byte[] dataBytes = data.ToArray();            

            if (useProtect)
            {
                if (protectMethod == 1)
                {
                    encrypt.Process(dataBytes, password);
                }
            }

            // Write Packet Data in File
            bytes.WriteBytes(dataBytes);

            return bytes.ToArray();
        }

        public void Save()
        {
            Thread saveFileDialog = new Thread(OpenSaveFileDialog);
            saveFileDialog.SetApartmentState(ApartmentState.STA);
            saveFileDialog.Start();                        
        }

        private void OpenSaveFileDialog()
        {
            SaveFileDialog saveFileDialog = new SaveFileDialog();
            //saveFileDialog.InitialDirectory = @"C:\";
            saveFileDialog.Title = "Save SEA File";
            saveFileDialog.CheckFileExists = true;
            //saveFileDialog.CheckPathExists = true;
            saveFileDialog.DefaultExt = "sea";
            saveFileDialog.Filter = "Sunag Entertainment Assets|*.sea";
            saveFileDialog.RestoreDirectory = true;
            saveFileDialog.ValidateNames = false;

            if (saveFileDialog.ShowDialog() == DialogResult.OK)
            {
                byte[] data = Build();
                bool status = ByteArrayToFile(saveFileDialog.FileName, data);

                if (!status)
                {
                    MessageBox.Show("Error saving the file.");
                }
            }
        }

        private bool ByteArrayToFile(string _FileName, byte[] _ByteArray)
        {
            try
            {
                // Open file for reading
                System.IO.FileStream _FileStream = new System.IO.FileStream(_FileName, System.IO.FileMode.Create, System.IO.FileAccess.Write);

                // Writes a block of bytes to this stream using data from a byte array.
                _FileStream.Write(_ByteArray, 0, _ByteArray.Length);

                // close file stream
                _FileStream.Close();

                return true;
            }
            catch (Exception _Exception)
            {
                // Error
                Console.WriteLine("Exception caught in process: {0}", _Exception.ToString());
            }

            // error occured, return false
            return false;
        }

        public string Password
        {
            set
            {
                password = value;
            }
            get
            {
                return password;
            }
        }

        public byte CompressMethod
        {
            set
            {
                compressMethod = value;
            }
            get
            {
                return compressMethod;
            }
        }

        public byte ProtectMethod
        {
            set
            {
                protectMethod = value;
            }
            get
            {
                return protectMethod;
            }
        }

        public void AddFile(File packet)
        {
            list.Add(packet);
        }

        public void RemoveFile(File packet)
        {
            list.Remove(packet);
        }

        public void Clear()
        {
            list.Clear();
        }

        public List<File> List
        {
            get
            {
                return list;
            }
        }

        public string Type
        {
            get
            {
                return type;
            }
            set
            {
                type = value;
            }
        }

        public string GetVersion()
        {
            return "SAF (Sunag Entertainment Assets) : " + Type;
        }
    }
}
