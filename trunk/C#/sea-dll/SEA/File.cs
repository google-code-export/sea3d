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
using System.IO;
using Sunag.IO;

namespace Sunag.SEA
{
    public class File
    {
        private ByteArray data = new ByteArray();

        private string name = "packet";
        private string type = "bin";

        public string Filename
        {
            set
            {
                if (value == null || value.Length == 0)
                    throw new Exception("Invalid name.");

                int start = value.LastIndexOf('/');
                if (start > 0)
                    value = value.Substring(start + 1);

                int end = value.LastIndexOf('.');

                if (end > 0)
                {
                    this.type = value.Substring(end + 1);
                    this.name = value.Substring(0, end);
                }
                else
                {
                    this.type = "bin";
                    this.name = value;
                }
            }
            get
            {
                return name + "." + type;
            }
        }

        public string Name
        {
            get
            {
                return name;
            }
            set
            {
                name = value;
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

        public ByteArray Data
        {
            get
            {
                return data;
            }
        }
    }
}
