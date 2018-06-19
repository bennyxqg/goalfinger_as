package com.greensock.core
{

    public class SimpleTimeline extends TweenCore
    {
        protected var _firstChild:TweenCore;
        protected var _lastChild:TweenCore;
        public var autoRemoveChildren:Boolean;

        public function SimpleTimeline(param1:Object = null)
        {
            super(0, param1);
            return;
        }// end function

        public function insert(param1:TweenCore, param2 = 0) : TweenCore
        {
            var _loc_3:* = param1.timeline;
            if (!param1.cachedOrphan && _loc_3)
            {
                _loc_3.remove(param1, true);
            }
            param1.timeline = this;
            param1.cachedStartTime = Number(param2) + param1.delay;
            if (param1.gc)
            {
                param1.setEnabled(true, true);
            }
            if (param1.cachedPaused && _loc_3 != this)
            {
                param1.cachedPauseTime = param1.cachedStartTime + (this.rawTime - param1.cachedStartTime) / param1.cachedTimeScale;
            }
            if (this._lastChild)
            {
                this._lastChild.nextNode = param1;
            }
            else
            {
                this._firstChild = param1;
            }
            param1.prevNode = this._lastChild;
            this._lastChild = param1;
            param1.nextNode = null;
            param1.cachedOrphan = false;
            return param1;
        }// end function

        public function remove(param1:TweenCore, param2:Boolean = false) : void
        {
            if (param1.cachedOrphan)
            {
                return;
            }
            if (!param2)
            {
                param1.setEnabled(false, true);
            }
            if (param1.nextNode)
            {
                param1.nextNode.prevNode = param1.prevNode;
            }
            else if (this._lastChild == param1)
            {
                this._lastChild = param1.prevNode;
            }
            if (param1.prevNode)
            {
                param1.prevNode.nextNode = param1.nextNode;
            }
            else if (this._firstChild == param1)
            {
                this._firstChild = param1.nextNode;
            }
            param1.cachedOrphan = true;
            return;
        }// end function

        override public function renderTime(param1:Number, param2:Boolean = false, param3:Boolean = false) : void
        {
            var _loc_5:* = NaN;
            var _loc_6:* = null;
            var _loc_4:* = this._firstChild;
            this.cachedTotalTime = param1;
            this.cachedTime = param1;
            while (_loc_4)
            {
                
                _loc_6 = _loc_4.nextNode;
                if (_loc_4.active || param1 >= _loc_4.cachedStartTime && !_loc_4.cachedPaused && !_loc_4.gc)
                {
                    if (!_loc_4.cachedReversed)
                    {
                        _loc_4.renderTime((param1 - _loc_4.cachedStartTime) * _loc_4.cachedTimeScale, param2, false);
                    }
                    else
                    {
                        _loc_5 = _loc_4.cacheIsDirty ? (_loc_4.totalDuration) : (_loc_4.cachedTotalDuration);
                        _loc_4.renderTime(_loc_5 - (param1 - _loc_4.cachedStartTime) * _loc_4.cachedTimeScale, param2, false);
                    }
                }
                _loc_4 = _loc_6;
            }
            return;
        }// end function

        public function get rawTime() : Number
        {
            return this.cachedTotalTime;
        }// end function

    }
}
