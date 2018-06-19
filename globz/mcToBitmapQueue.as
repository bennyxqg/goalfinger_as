package globz
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.events.*;

    public class mcToBitmapQueue extends Object
    {
        private var vTrace:Boolean = false;
        public var vQueueList:Vector.<mcToBitmapAS3>;
        private var vQueueListSaved:Vector.<mcToBitmapAS3>;
        public var vTotalMemory:int;
        private var vNBFrames:int;
        private var vNBFramesList:Vector.<int>;
        private var vSprite:Sprite;
        private var vCallBack:Function;

        public function mcToBitmapQueue() : void
        {
            this.vTotalMemory = 0;
            this.vQueueList = new Vector.<mcToBitmapAS3>;
            this.vQueueListSaved = new Vector.<mcToBitmapAS3>;
            this.vNBFrames = 0;
            this.vNBFramesList = new Vector.<int>;
            return;
        }// end function

        final public function addToQueue(param1:mcToBitmapAS3) : void
        {
            this.vQueueList.push(param1);
            this.vQueueListSaved.push(param1);
            this.vNBFramesList.push(param1.vNBFrames);
            this.vNBFrames = this.vNBFrames + param1.vNBFrames;
            return;
        }// end function

        final public function startConversion(param1:Function = null, param2:int = 0) : void
        {
            var _loc_3:* = null;
            if (this.vQueueList.length > 0)
            {
                this.vCallBack = param1;
                this.vQueueList[0].startConversion(null, param2);
            }
            else
            {
                if (param1 != null)
                {
                    _loc_3 = param1;
                    param1 = null;
                    this._loc_3();
                }
                this.destroy();
            }
            return;
        }// end function

        final public function getProgress() : int
        {
            var _loc_1:* = 0;
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            if (this.vQueueList && this.vQueueList.length > 0)
            {
                _loc_1 = this.vNBFramesList.length - this.vQueueList.length;
                _loc_2 = 0;
                _loc_3 = 0;
                while (_loc_3 < _loc_1)
                {
                    
                    _loc_2 = _loc_2 + this.vNBFramesList[_loc_3];
                    _loc_3++;
                }
                _loc_2 = _loc_2 + this.vQueueList[0].vFrameStart;
                _loc_4 = _loc_2 * 100 / this.vNBFrames;
                if (_loc_4 < 0)
                {
                    _loc_4 = 0;
                }
                if (_loc_4 > 100)
                {
                    _loc_4 = 100;
                }
                return _loc_4;
            }
            else
            {
                return 100;
            }
        }// end function

        final public function destroy() : void
        {
            this.vSprite = new Sprite();
            this.vSprite.addEventListener(Event.ENTER_FRAME, this.waitAFrame);
            this.vQueueList = null;
            this.vQueueListSaved = null;
            return;
        }// end function

        final private function waitAFrame(event:Event) : void
        {
            var _loc_2:* = null;
            this.vSprite.removeEventListener(Event.ENTER_FRAME, this.waitAFrame);
            this.vSprite = null;
            if (this.vCallBack != null)
            {
                _loc_2 = this.vCallBack;
                this.vCallBack = null;
                this._loc_2();
            }
            return;
        }// end function

        final public function kill() : void
        {
            var _loc_1:* = 0;
            if (this.vQueueListSaved && this.vQueueList && this.vQueueList.length > 0)
            {
                _loc_1 = 0;
                while (_loc_1 < this.vQueueListSaved.length)
                {
                    
                    if (this.vQueueListSaved[_loc_1])
                    {
                        this.vQueueListSaved[_loc_1].destroyAll();
                    }
                    _loc_1++;
                }
            }
            this.destroy();
            return;
        }// end function

    }
}
