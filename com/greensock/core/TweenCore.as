package com.greensock.core
{
    import com.greensock.*;

    public class TweenCore extends Object
    {
        protected var _delay:Number;
        protected var _hasUpdate:Boolean;
        protected var _rawPrevTime:Number = -1;
        public var vars:Object;
        public var active:Boolean;
        public var gc:Boolean;
        public var initted:Boolean;
        public var timeline:SimpleTimeline;
        public var cachedStartTime:Number;
        public var cachedTime:Number;
        public var cachedTotalTime:Number;
        public var cachedDuration:Number;
        public var cachedTotalDuration:Number;
        public var cachedTimeScale:Number;
        public var cachedPauseTime:Number;
        public var cachedReversed:Boolean;
        public var nextNode:TweenCore;
        public var prevNode:TweenCore;
        public var cachedOrphan:Boolean;
        public var cacheIsDirty:Boolean;
        public var cachedPaused:Boolean;
        public var data:Object;
        public static const version:Number = 1.693;
        static var _classInitted:Boolean;

        public function TweenCore(param1:Number = 0, param2:Object = null)
        {
            this.vars = param2 != null ? (param2) : ({});
            if (this.vars.isGSVars)
            {
                this.vars = this.vars.vars;
            }
            var _loc_4:* = param1;
            this.cachedTotalDuration = param1;
            this.cachedDuration = _loc_4;
            this._delay = this.vars.delay ? (Number(this.vars.delay)) : (0);
            this.cachedTimeScale = this.vars.timeScale ? (Number(this.vars.timeScale)) : (1);
            this.active = Boolean(param1 == 0 && this._delay == 0 && this.vars.immediateRender != false);
            var _loc_4:* = 0;
            this.cachedTime = 0;
            this.cachedTotalTime = _loc_4;
            this.data = this.vars.data;
            if (!_classInitted)
            {
                if (isNaN(TweenLite.rootFrame))
                {
                    TweenLite.initClass();
                    _classInitted = true;
                }
                else
                {
                    return;
                }
            }
            var _loc_3:* = this.vars.timeline is SimpleTimeline ? (this.vars.timeline) : (this.vars.useFrames ? (TweenLite.rootFramesTimeline) : (TweenLite.rootTimeline));
            _loc_3.insert(this, _loc_3.cachedTotalTime);
            if (this.vars.reversed)
            {
                this.cachedReversed = true;
            }
            if (this.vars.paused)
            {
                this.paused = true;
            }
            return;
        }// end function

        public function play() : void
        {
            this.reversed = false;
            this.paused = false;
            return;
        }// end function

        public function pause() : void
        {
            this.paused = true;
            return;
        }// end function

        public function resume() : void
        {
            this.paused = false;
            return;
        }// end function

        public function restart(param1:Boolean = false, param2:Boolean = true) : void
        {
            this.reversed = false;
            this.paused = false;
            this.setTotalTime(param1 ? (-this._delay) : (0), param2);
            return;
        }// end function

        public function reverse(param1:Boolean = true) : void
        {
            this.reversed = true;
            if (param1)
            {
                this.paused = false;
            }
            else if (this.gc)
            {
                this.setEnabled(true, false);
            }
            return;
        }// end function

        public function renderTime(param1:Number, param2:Boolean = false, param3:Boolean = false) : void
        {
            return;
        }// end function

        public function complete(param1:Boolean = false, param2:Boolean = false) : void
        {
            if (!param1)
            {
                this.renderTime(this.totalDuration, param2, false);
                return;
            }
            if (this.timeline.autoRemoveChildren)
            {
                this.setEnabled(false, false);
            }
            else
            {
                this.active = false;
            }
            if (!param2)
            {
                if (this.vars.onComplete && this.cachedTotalTime >= this.cachedTotalDuration && !this.cachedReversed)
                {
                    this.vars.onComplete.apply(null, this.vars.onCompleteParams);
                }
                else if (this.cachedReversed && this.cachedTotalTime == 0 && this.vars.onReverseComplete)
                {
                    this.vars.onReverseComplete.apply(null, this.vars.onReverseCompleteParams);
                }
            }
            return;
        }// end function

        public function invalidate() : void
        {
            return;
        }// end function

        public function setEnabled(param1:Boolean, param2:Boolean = false) : Boolean
        {
            this.gc = !param1;
            if (param1)
            {
                this.active = Boolean(!this.cachedPaused && this.cachedTotalTime > 0 && this.cachedTotalTime < this.cachedTotalDuration);
                if (!param2 && this.cachedOrphan)
                {
                    this.timeline.insert(this, this.cachedStartTime - this._delay);
                }
            }
            else
            {
                this.active = false;
                if (!param2 && !this.cachedOrphan)
                {
                    this.timeline.remove(this, true);
                }
            }
            return false;
        }// end function

        public function kill() : void
        {
            this.setEnabled(false, false);
            return;
        }// end function

        protected function setDirtyCache(param1:Boolean = true) : void
        {
            var _loc_2:* = param1 ? (this) : (this.timeline);
            while (_loc_2)
            {
                
                _loc_2.cacheIsDirty = true;
                _loc_2 = _loc_2.timeline;
            }
            return;
        }// end function

        protected function setTotalTime(param1:Number, param2:Boolean = false) : void
        {
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            if (this.timeline)
            {
                _loc_3 = this.cachedPaused ? (this.cachedPauseTime) : (this.timeline.cachedTotalTime);
                if (this.cachedReversed)
                {
                    _loc_4 = this.cacheIsDirty ? (this.totalDuration) : (this.cachedTotalDuration);
                    this.cachedStartTime = _loc_3 - (_loc_4 - param1) / this.cachedTimeScale;
                }
                else
                {
                    this.cachedStartTime = _loc_3 - param1 / this.cachedTimeScale;
                }
                if (!this.timeline.cacheIsDirty)
                {
                    this.setDirtyCache(false);
                }
                if (this.cachedTotalTime != param1)
                {
                    this.renderTime(param1, param2, false);
                }
            }
            return;
        }// end function

        public function get delay() : Number
        {
            return this._delay;
        }// end function

        public function set delay(param1:Number) : void
        {
            this.startTime = this.startTime + (param1 - this._delay);
            this._delay = param1;
            return;
        }// end function

        public function get duration() : Number
        {
            return this.cachedDuration;
        }// end function

        public function set duration(param1:Number) : void
        {
            var _loc_2:* = param1 / this.cachedDuration;
            var _loc_3:* = param1;
            this.cachedTotalDuration = param1;
            this.cachedDuration = _loc_3;
            this.setDirtyCache(true);
            if (this.active && !this.cachedPaused && param1 != 0)
            {
                this.setTotalTime(this.cachedTotalTime * _loc_2, true);
            }
            return;
        }// end function

        public function get totalDuration() : Number
        {
            return this.cachedTotalDuration;
        }// end function

        public function set totalDuration(param1:Number) : void
        {
            this.duration = param1;
            return;
        }// end function

        public function get currentTime() : Number
        {
            return this.cachedTime;
        }// end function

        public function set currentTime(param1:Number) : void
        {
            this.setTotalTime(param1, false);
            return;
        }// end function

        public function get totalTime() : Number
        {
            return this.cachedTotalTime;
        }// end function

        public function set totalTime(param1:Number) : void
        {
            this.setTotalTime(param1, false);
            return;
        }// end function

        public function get startTime() : Number
        {
            return this.cachedStartTime;
        }// end function

        public function set startTime(param1:Number) : void
        {
            if (this.timeline != null && (param1 != this.cachedStartTime || this.gc))
            {
                this.timeline.insert(this, param1 - this._delay);
            }
            else
            {
                this.cachedStartTime = param1;
            }
            return;
        }// end function

        public function get reversed() : Boolean
        {
            return this.cachedReversed;
        }// end function

        public function set reversed(param1:Boolean) : void
        {
            if (param1 != this.cachedReversed)
            {
                this.cachedReversed = param1;
                this.setTotalTime(this.cachedTotalTime, true);
            }
            return;
        }// end function

        public function get paused() : Boolean
        {
            return this.cachedPaused;
        }// end function

        public function set paused(param1:Boolean) : void
        {
            if (param1 != this.cachedPaused && this.timeline)
            {
                if (param1)
                {
                    this.cachedPauseTime = this.timeline.rawTime;
                }
                else
                {
                    this.cachedStartTime = this.cachedStartTime + (this.timeline.rawTime - this.cachedPauseTime);
                    this.cachedPauseTime = NaN;
                    this.setDirtyCache(false);
                }
                this.cachedPaused = param1;
                this.active = Boolean(!this.cachedPaused && this.cachedTotalTime > 0 && this.cachedTotalTime < this.cachedTotalDuration);
            }
            if (!param1 && this.gc)
            {
                this.setEnabled(true, false);
            }
            return;
        }// end function

    }
}
