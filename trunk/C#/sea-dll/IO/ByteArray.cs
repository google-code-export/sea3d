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
using System.IO;
using System.IO.Compression;

namespace Sunag.IO
{
    sealed public class CompressionAlgorithm
    {
        public const string Deflate = "deflate";
        public const string Zlib = "zlib";
    }

    public class ByteArray
    {
        private MemoryStream _memoryStream;

        public ByteArray()
        {
            _memoryStream = new MemoryStream();
        }

        public void WriteUTFBytes(string value)
        {
            //Length - max 65536.
            UTF8Encoding utf8Encoding = new UTF8Encoding();
            byte[] buffer = utf8Encoding.GetBytes(value);
            if (buffer.Length > 0)
                WriteBytes(buffer);
        }

        public void WriteUTFShort(string value)
        {
            //null string is not accepted
            //in case of custom serialization leads to TypeError: Error #2007: Parameter value must be non-null.  at flash.utils::ObjectOutput/writeUTF()

            //Length - max 65536.
            UTF8Encoding utf8Encoding = new UTF8Encoding();
            int byteCount = utf8Encoding.GetByteCount(value);
            byte[] buffer = utf8Encoding.GetBytes(value);
            this.WriteShort(byteCount);
            if (buffer.Length > 0)
                WriteBytes(buffer);
        }

        public void WriteUTFLong(string value)
        {
            UTF8Encoding utf8Encoding = new UTF8Encoding();
            byte[] buffer = utf8Encoding.GetBytes(value);
            WriteUInt((uint)buffer.Length);
            WriteUTFBytes(value);
        }

        public void WriteUTFTiny(string value)
        {
            UTF8Encoding utf8Encoding = new UTF8Encoding();
            byte[] buffer = utf8Encoding.GetBytes(value);
            WriteByte((byte)buffer.Length);
            WriteUTFBytes(value);
        }

        public void WriteByte(byte value)
        {
            _memoryStream.WriteByte(value);
        }
        
        public void WriteBytes(byte[] buffer)
        {
            for (int i = 0; buffer != null && i < buffer.Length; i++)
                _memoryStream.WriteByte(buffer[i]);
        }

        public void WriteShort(int value)
        {
            byte[] bytes = BitConverter.GetBytes((ushort)value);
            WriteBigEndian(bytes);
        }

        public void WriteFloat(float value)
        {
            byte[] bytes = BitConverter.GetBytes(value);
            WriteBigEndian(bytes);
        }

        public void WriteInt(int value)
        {
            byte[] bytes = BitConverter.GetBytes(value);
            WriteBigEndian(bytes);
        }

        public void WriteUInt(uint value)
        {
            byte[] bytes = BitConverter.GetBytes(value);
            WriteBigEndian(bytes);
        }

        public void WriteNull()
        {
            WriteByte(0);
        }

        public void WriteDouble(double value)
        {
            byte[] bytes = BitConverter.GetBytes(value);
            WriteBigEndian(bytes);
        }

        public void WriteUInt24(int value)
        {
            byte[] bytes = new byte[3];
            bytes[0] = (byte)(0xFF & (value >> 16));
            bytes[1] = (byte)(0xFF & (value >> 8));
            bytes[2] = (byte)(0xFF & (value >> 0));
           _memoryStream.Write(bytes, 0, bytes.Length);
        }

        public void WriteBoolean(bool value)
        {
            _memoryStream.WriteByte(value ? ((byte)1) : ((byte)0));
        }

        public void WriteLong(long value)
        {
            byte[] bytes = BitConverter.GetBytes(value);
            WriteBigEndian(bytes);
        }

        private void WriteBigEndian(byte[] bytes)
        {
            if (bytes == null)
                return;
            for (int i = bytes.Length - 1; i >= 0; i--)
            {
                _memoryStream.WriteByte(bytes[i]);
            }
        }

        public uint Length
        {
            get
            {
                return (uint)_memoryStream.Length;
            }
        }

        public uint Position
        {
            get { return (uint)_memoryStream.Position; }
            set { _memoryStream.Position = value; }
        }

        public uint BytesAvailable
        {
            get { return Length - Position; }
        }

        public void Compress()
        {
            Compress(CompressionAlgorithm.Zlib);
        }
        
        public void Deflate()
        {
            Compress(CompressionAlgorithm.Deflate);
        }

        public byte[] ToArray()
        {
            return _memoryStream.ToArray();
        }

        public byte[] GetBuffer()
        {
            return _memoryStream.GetBuffer();
        }

        public void ReadFile(string filePath)
        {
            byte[] buffer;
            FileStream fileStream = new FileStream(filePath, FileMode.Open, FileAccess.Read);
            try
            {
                int length = (int)fileStream.Length;  // get file length
                buffer = new byte[length];            // create buffer
                int count;                            // actual number of bytes read
                int sum = 0;                          // total number of bytes read

                // read until Read method returns 0 (end of the stream has been reached)
                while ((count = fileStream.Read(buffer, sum, length - sum)) > 0)
                    sum += count;  // sum is a buffer offset for next reading
            }
            finally
            {
                fileStream.Close();
            }

            WriteBytes(buffer);
        }

        public void Compress(string algorithm)
        {
            if (algorithm == CompressionAlgorithm.Deflate)
            {
                byte[] buffer = _memoryStream.ToArray();
                MemoryStream ms = new MemoryStream();
                DeflateStream deflateStream = new DeflateStream(ms, CompressionMode.Compress, true);
                deflateStream.Write(buffer, 0, buffer.Length);
                deflateStream.Close();
                _memoryStream.Close();
                _memoryStream = ms;
            }
            if (algorithm == CompressionAlgorithm.Zlib)
            {
                byte[] buffer = _memoryStream.ToArray();
                MemoryStream ms = new MemoryStream();
                ZlibStream zlibStream = new ZlibStream(ms, CompressionMode.Compress, true);
                zlibStream.Write(buffer, 0, buffer.Length);
                zlibStream.Flush();
                zlibStream.Close();
                zlibStream.Dispose();
                _memoryStream.Close();
                _memoryStream = ms;
            }
        }
    }
}
