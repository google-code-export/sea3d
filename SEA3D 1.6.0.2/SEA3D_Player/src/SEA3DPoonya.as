/* Copyright (c) 2013 Sunag Entertainment
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:

* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.

* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE. */

package
{
	[SWF(width="1024", height="632", backgroundColor="0x2f3032", frameRate="60")]
	public class SEA3DPoonya extends SEA3DPlayer
	{
		private var params:Object;
		
		public function SEA3DPoonya()
		{
			super();
			
			autoPlay = true;
						
			player.status = false;
			player.upload.visible = false;
			player.updatePanel();
			
			params = loaderInfo.parameters;
			
			if (params.watchID)
			{
				loadSEA3D(params.watchID, params.watch);
			}
		}	
				
		protected function loadSEA3D(id:String, name:String):void
		{
			//load("http://localhost/poonya/files/" + id + "." + name + ".sea");
			load("http://www.poonya.com/files/" + id + "." + name + ".sea");
		}
	}
}