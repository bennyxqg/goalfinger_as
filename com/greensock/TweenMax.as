package com.greensock
{
    import com.greensock.core.*;
    import com.greensock.events.*;
    import com.greensock.plugins.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class TweenMax extends TweenLite implements IEventDispatcher
    {
        protected var _dispatcher:EventDispatcher;
        protected var _hasUpdateListener:Boolean;
        protected var _repeat:int = 0;
        protected var _repeatDelay:Number = 0;
        protected var _cyclesComplete:int = 0;
        protected var _easePower:int;
        protected var _easeType:int;
        public var yoyo:Boolean;
        public static const version:Number = 11.698;
        private static var _overwriteMode:int = OverwriteManager.enabled ? (OverwriteManager.mode) : (OverwriteManager.init(2));
        public static var killTweensOf:Function = TweenLite.killTweensOf;
        public static var killDelayedCallsTo:Function = TweenLite.killTweensOf;

        public function TweenMax(param1:Object, param2:Number, param3:Object)
        {
            super(param1, param2, param3);
            if (TweenLite.version < 11.2)
            {
                throw new Error("TweenMax error! Please update your TweenLite class or try deleting your ASO files. TweenMax requires a more recent version. Download updates at http://www.TweenMax.com.");
            }
            this.yoyo = Boolean(this.vars.yoyo);
            this._repeat = uint(this.vars.repeat);
            this._repeatDelay = this.vars.repeatDelay ? (Number(this.vars.repeatDelay)) : (0);
            this.cacheIsDirty = true;
            if (this.vars.onCompleteListener || this.vars.onInitListener || this.vars.onUpdateListener || this.vars.onStartListener || this.vars.onRepeatListener || this.vars.onReverseCompleteListener)
            {
                this.initDispatcher();
                if (param2 == 0 && _delay == 0)
                {
                    this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.UPDATE));
                    this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.COMPLETE));
                }
            }
            if (this.vars.timeScale && !(this.target is TweenCore))
            {
                this.cachedTimeScale = this.vars.timeScale;
            }
            return;
        }// end function

        override protected function init() : void
        {
            var _loc_1:* = null;
            if (this.vars.startAt)
            {
                this.vars.startAt.overwrite = 0;
                this.vars.startAt.immediateRender = true;
                _loc_1 = new TweenMax(this.target, 0, this.vars.startAt);
            }
            if (this._dispatcher)
            {
                this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.INIT));
            }
            super.init();
            if (_ease in fastEaseLookup)
            {
                this._easeType = fastEaseLookup[_ease][0];
                this._easePower = fastEaseLookup[_ease][1];
            }
            return;
        }// end function

        override public function invalidate() : void
        {
            this.yoyo = Boolean(this.vars.yoyo == true);
            this._repeat = this.vars.repeat ? (Number(this.vars.repeat)) : (0);
            this._repeatDelay = this.vars.repeatDelay ? (Number(this.vars.repeatDelay)) : (0);
            this._hasUpdateListener = false;
            if (this.vars.onCompleteListener != null || this.vars.onUpdateListener != null || this.vars.onStartListener != null)
            {
                this.initDispatcher();
            }
            setDirtyCache(true);
            super.invalidate();
            return;
        }// end function

        public function updateTo(param1:Object, param2:Boolean = false) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = NaN;
            var _loc_6:* = NaN;
            var _loc_7:* = null;
            var _loc_8:* = NaN;
            var _loc_3:* = this.ratio;
            if (param2 && this.timeline != null && this.cachedStartTime < this.timeline.cachedTime)
            {
                this.cachedStartTime = this.timeline.cachedTime;
                this.setDirtyCache(false);
                if (this.gc)
                {
                    this.setEnabled(true, false);
                }
                else
                {
                    this.timeline.insert(this, this.cachedStartTime - _delay);
                }
            }
            for (_loc_4 in param1)
            {
                
                this.vars[_loc_4] = _loc_10[_loc_4];
            }
            if (this.initted)
            {
                if (param2)
                {
                    this.initted = false;
                }
                else
                {
                    if (_notifyPluginsOfEnabled && this.cachedPT1)
                    {
                        onPluginEvent("onDisable", this);
                    }
                    if (this.cachedTime / this.cachedDuration > 0.998)
                    {
                        _loc_5 = this.cachedTime;
                        this.renderTime(0, true, false);
                        this.initted = false;
                        this.renderTime(_loc_5, true, false);
                    }
                    else if (this.cachedTime > 0)
                    {
                        this.initted = false;
                        this.init();
                        _loc_6 = 1 / (1 - _loc_3);
                        _loc_7 = this.cachedPT1;
                        while (_loc_7)
                        {
                            
                            _loc_8 = _loc_7.start + _loc_7.change;
                            _loc_7.change = _loc_7.change * _loc_6;
                            _loc_7.start = _loc_8 - _loc_7.change;
                            _loc_7 = _loc_7.nextNode;
                        }
                    }
                }
            }
            return;
        }// end function

        public function setDestination(param1:String, param2, param3:Boolean = true) : void
        {
            var _loc_4:* = {};
            _loc_4[param1] = param2;
            this.updateTo(_loc_4, !param3);
            return;
        }// end function

        public function killProperties(param1:Array) : void
        {
            var _loc_2:* = {};
            var _loc_3:* = param1.length;
            while (--_loc_3 > -1)
            {
                
                _loc_2[param1[_loc_3]] = true;
            }
            killVars(_loc_2);
            return;
        }// end function

        override public function renderTime(param1:Number, param2:Boolean = false, param3:Boolean = false) : void
        {
            var _loc_7:* = false;
            var _loc_8:* = false;
            var _loc_9:* = false;
            var _loc_11:* = NaN;
            var _loc_12:* = 0;
            var _loc_13:* = 0;
            var _loc_14:* = NaN;
            var _loc_4:* = this.cacheIsDirty ? (this.totalDuration) : (this.cachedTotalDuration);
            var _loc_5:* = this.cachedTime;
            var _loc_6:* = this.cachedTotalTime;
            if (param1 >= _loc_4)
            {
                this.cachedTotalTime = _loc_4;
                this.cachedTime = this.cachedDuration;
                this.ratio = 1;
                _loc_7 = !this.cachedReversed;
                if (this.cachedDuration == 0)
                {
                    if ((param1 == 0 || _rawPrevTime < 0) && _rawPrevTime != param1)
                    {
                        param3 = true;
                    }
                    _rawPrevTime = param1;
                }
            }
            else if (param1 <= 0)
            {
                if (param1 < 0)
                {
                    this.active = false;
                    if (this.cachedDuration == 0)
                    {
                        if (_rawPrevTime >= 0)
                        {
                            param3 = true;
                            _loc_7 = _rawPrevTime > 0;
                        }
                        _rawPrevTime = param1;
                    }
                }
                else if (param1 == 0 && !this.initted)
                {
                    param3 = true;
                }
                var _loc_15:* = 0;
                this.ratio = 0;
                this.cachedTime = _loc_15;
                this.cachedTotalTime = _loc_15;
                if (this.cachedReversed && _loc_6 != 0)
                {
                    _loc_7 = true;
                }
            }
            else
            {
                var _loc_15:* = param1;
                this.cachedTime = param1;
                this.cachedTotalTime = _loc_15;
                _loc_9 = true;
            }
            if (this._repeat != 0)
            {
                _loc_11 = this.cachedDuration + this._repeatDelay;
                _loc_12 = this._cyclesComplete;
                var _loc_15:* = this.cachedTotalTime / _loc_11 >> 0;
                this._cyclesComplete = this.cachedTotalTime / _loc_11 >> 0;
                if (_loc_15 == this.cachedTotalTime / _loc_11 && this._cyclesComplete != 0)
                {
                    var _loc_15:* = this;
                    var _loc_16:* = this._cyclesComplete - 1;
                    _loc_15._cyclesComplete = _loc_16;
                }
                _loc_8 = Boolean(_loc_12 != this._cyclesComplete);
                if (_loc_7)
                {
                    if (this.yoyo && this._repeat % 2)
                    {
                        var _loc_15:* = 0;
                        this.ratio = 0;
                        this.cachedTime = _loc_15;
                    }
                }
                else if (param1 > 0)
                {
                    this.cachedTime = this.cachedTotalTime - this._cyclesComplete * _loc_11;
                    if (this.yoyo && this._cyclesComplete % 2)
                    {
                        this.cachedTime = this.cachedDuration - this.cachedTime;
                    }
                    else if (this.cachedTime >= this.cachedDuration)
                    {
                        this.cachedTime = this.cachedDuration;
                        this.ratio = 1;
                        _loc_9 = false;
                    }
                    if (this.cachedTime <= 0)
                    {
                        var _loc_15:* = 0;
                        this.ratio = 0;
                        this.cachedTime = _loc_15;
                        _loc_9 = false;
                    }
                }
                else
                {
                    this._cyclesComplete = 0;
                }
            }
            if (_loc_5 == this.cachedTime && !param3)
            {
                return;
            }
            if (!this.initted)
            {
                this.init();
            }
            if (!this.active && !this.cachedPaused)
            {
                this.active = true;
            }
            if (_loc_9)
            {
                if (this._easeType)
                {
                    _loc_13 = this._easePower;
                    _loc_14 = this.cachedTime / this.cachedDuration;
                    if (this._easeType == 2)
                    {
                        var _loc_15:* = 1 - _loc_14;
                        _loc_14 = 1 - _loc_14;
                        this.ratio = _loc_15;
                        while (--_loc_13 > -1)
                        {
                            
                            this.ratio = _loc_14 * this.ratio;
                        }
                        this.ratio = 1 - this.ratio;
                    }
                    else if (this._easeType == 1)
                    {
                        this.ratio = _loc_14;
                        do
                        {
                            
                            this.ratio = _loc_14 * this.ratio;
                            _loc_13 = --_loc_13 - 1;
                        }while (--_loc_13 - 1 > -1)
                    }
                    else if (_loc_14 < 0.5)
                    {
                        var _loc_15:* = _loc_14 * 2;
                        _loc_14 = _loc_14 * 2;
                        this.ratio = _loc_15;
                        while (--_loc_13 > -1)
                        {
                            
                            this.ratio = _loc_14 * this.ratio;
                        }
                        this.ratio = this.ratio * 0.5;
                    }
                    else
                    {
                        var _loc_15:* = (1 - _loc_14) * 2;
                        _loc_14 = (1 - _loc_14) * 2;
                        this.ratio = _loc_15;
                        do
                        {
                            
                            this.ratio = _loc_14 * this.ratio;
                            _loc_13 = --_loc_13 - 1;
                        }while (--_loc_13 - 1 > -1)
                        this.ratio = 1 - 0.5 * this.ratio;
                    }
                }
                else
                {
                    this.ratio = _ease(this.cachedTime, 0, 1, this.cachedDuration);
                }
            }
            if (_loc_6 == 0 && (this.cachedTotalTime != 0 || this.cachedDuration == 0) && !param2)
            {
                if (this.vars.onStart)
                {
                    this.vars.onStart.apply(null, this.vars.onStartParams);
                }
                if (this._dispatcher)
                {
                    this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.START));
                }
            }
            var _loc_10:* = this.cachedPT1;
            while (_loc_10)
            {
                
                _loc_10.target[_loc_10.property] = _loc_10.start + this.ratio * _loc_10.change;
                _loc_10 = _loc_10.nextNode;
            }
            if (_hasUpdate && !param2)
            {
                this.vars.onUpdate.apply(null, this.vars.onUpdateParams);
            }
            if (this._hasUpdateListener && !param2)
            {
                this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.UPDATE));
            }
            if (_loc_8 && !param2 && !this.gc)
            {
                if (this.vars.onRepeat)
                {
                    this.vars.onRepeat.apply(null, this.vars.onRepeatParams);
                }
                if (this._dispatcher)
                {
                    this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.REPEAT));
                }
            }
            if (_loc_7 && !this.gc)
            {
                if (_hasPlugins && this.cachedPT1)
                {
                    onPluginEvent("onComplete", this);
                }
                this.complete(true, param2);
            }
            return;
        }// end function

        override public function complete(param1:Boolean = false, param2:Boolean = false) : void
        {
            super.complete(param1, param2);
            if (!param2 && this._dispatcher)
            {
                if (this.cachedTotalTime == this.cachedTotalDuration && !this.cachedReversed)
                {
                    this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.COMPLETE));
                }
                else if (this.cachedReversed && this.cachedTotalTime == 0)
                {
                    this._dispatcher.dispatchEvent(new TweenEvent(TweenEvent.REVERSE_COMPLETE));
                }
            }
            return;
        }// end function

        protected function initDispatcher() : void
        {
            if (this._dispatcher == null)
            {
                this._dispatcher = new EventDispatcher(this);
            }
            if (this.vars.onInitListener is Function)
            {
                this._dispatcher.addEventListener(TweenEvent.INIT, this.vars.onInitListener, false, 0, true);
            }
            if (this.vars.onStartListener is Function)
            {
                this._dispatcher.addEventListener(TweenEvent.START, this.vars.onStartListener, false, 0, true);
            }
            if (this.vars.onUpdateListener is Function)
            {
                this._dispatcher.addEventListener(TweenEvent.UPDATE, this.vars.onUpdateListener, false, 0, true);
                this._hasUpdateListener = true;
            }
            if (this.vars.onCompleteListener is Function)
            {
                this._dispatcher.addEventListener(TweenEvent.COMPLETE, this.vars.onCompleteListener, false, 0, true);
            }
            if (this.vars.onRepeatListener is Function)
            {
                this._dispatcher.addEventListener(TweenEvent.REPEAT, this.vars.onRepeatListener, false, 0, true);
            }
            if (this.vars.onReverseCompleteListener is Function)
            {
                this._dispatcher.addEventListener(TweenEvent.REVERSE_COMPLETE, this.vars.onReverseCompleteListener, false, 0, true);
            }
            return;
        }// end function

        public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
        {
            if (this._dispatcher == null)
            {
                this.initDispatcher();
            }
            if (param1 == TweenEvent.UPDATE)
            {
                this._hasUpdateListener = true;
            }
            this._dispatcher.addEventListener(param1, param2, param3, param4, param5);
            return;
        }// end function

        public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
        {
            if (this._dispatcher)
            {
                this._dispatcher.removeEventListener(param1, param2, param3);
            }
            return;
        }// end function

        public function hasEventListener(param1:String) : Boolean
        {
            return this._dispatcher == null ? (false) : (this._dispatcher.hasEventListener(param1));
        }// end function

        public function willTrigger(param1:String) : Boolean
        {
            return this._dispatcher == null ? (false) : (this._dispatcher.willTrigger(param1));
        }// end function

        public function dispatchEvent(event:Event) : Boolean
        {
            return this._dispatcher == null ? (false) : (this._dispatcher.dispatchEvent(event));
        }// end function

        public function get currentProgress() : Number
        {
            return this.cachedTime / this.duration;
        }// end function

        public function set currentProgress(param1:Number) : void
        {
            if (this._cyclesComplete == 0)
            {
                setTotalTime(this.duration * param1, false);
            }
            else
            {
                setTotalTime(this.duration * param1 + this._cyclesComplete * this.cachedDuration, false);
            }
            return;
        }// end function

        public function get totalProgress() : Number
        {
            return this.cachedTotalTime / this.totalDuration;
        }// end function

        public function set totalProgress(param1:Number) : void
        {
            setTotalTime(this.totalDuration * param1, false);
            return;
        }// end function

        override public function set currentTime(param1:Number) : void
        {
            if (this._cyclesComplete == 0)
            {
            }
            else if (this.yoyo && this._cyclesComplete % 2 == 1)
            {
                param1 = this.duration - param1 + this._cyclesComplete * (this.cachedDuration + this._repeatDelay);
            }
            else
            {
                param1 = param1 + this._cyclesComplete * (this.duration + this._repeatDelay);
            }
            setTotalTime(param1, false);
            return;
        }// end function

        override public function get totalDuration() : Number
        {
            if (this.cacheIsDirty)
            {
                this.cachedTotalDuration = this._repeat == -1 ? (999999999999) : (this.cachedDuration * (this._repeat + 1) + this._repeatDelay * this._repeat);
                this.cacheIsDirty = false;
            }
            return this.cachedTotalDuration;
        }// end function

        override public function set totalDuration(param1:Number) : void
        {
            if (this._repeat == -1)
            {
                return;
            }
            this.duration = (param1 - this._repeat * this._repeatDelay) / (this._repeat + 1);
            return;
        }// end function

        public function get timeScale() : Number
        {
            return this.cachedTimeScale;
        }// end function

        public function set timeScale(param1:Number) : void
        {
            if (param1 == 0)
            {
                param1 = 0.0001;
            }
            var _loc_2:* = this.cachedPauseTime || this.cachedPauseTime == 0 ? (this.cachedPauseTime) : (this.timeline.cachedTotalTime);
            this.cachedStartTime = _loc_2 - (_loc_2 - this.cachedStartTime) * this.cachedTimeScale / param1;
            this.cachedTimeScale = param1;
            setDirtyCache(false);
            return;
        }// end function

        public function get repeat() : int
        {
            return this._repeat;
        }// end function

        public function set repeat(param1:int) : void
        {
            this._repeat = param1;
            setDirtyCache(true);
            return;
        }// end function

        public function get repeatDelay() : Number
        {
            return this._repeatDelay;
        }// end function

        public function set repeatDelay(param1:Number) : void
        {
            this._repeatDelay = param1;
            setDirtyCache(true);
            return;
        }// end function

        public static function to(param1:Object, param2:Number, param3:Object) : TweenMax
        {
            return new TweenMax(param1, param2, param3);
        }// end function

        public static function from(param1:Object, param2:Number, param3:Object) : TweenMax
        {
            if (param3.isGSVars)
            {
                param3 = param3.vars;
            }
            param3.runBackwards = true;
            if (!("immediateRender" in param3))
            {
                param3.immediateRender = true;
            }
            return new TweenMax(param1, param2, param3);
        }// end function

        public static function fromTo(param1:Object, param2:Number, param3:Object, param4:Object) : TweenMax
        {
            if (param4.isGSVars)
            {
                param4 = param4.vars;
            }
            if (param3.isGSVars)
            {
                param3 = param3.vars;
            }
            param4.startAt = param3;
            if (param3.immediateRender)
            {
                param4.immediateRender = true;
            }
            return new TweenMax(param1, param2, param4);
        }// end function

        public static function allTo(param1:Array, param2:Number, param3:Object, param4:Number = 0, param5:Function = null, param6:Array = null) : Array
        {
            var i:int;
            var varsDup:Object;
            var p:String;
            var onCompleteProxy:Function;
            var onCompleteParamsProxy:Array;
            var targets:* = param1;
            var duration:* = param2;
            var vars:* = param3;
            var stagger:* = param4;
            var onCompleteAll:* = param5;
            var onCompleteAllParams:* = param6;
            var l:* = targets.length;
            var a:Array;
            if (vars.isGSVars)
            {
                vars = vars.vars;
            }
            var curDelay:* = "delay" in vars ? (Number(vars.delay)) : (0);
            onCompleteProxy = vars.onComplete;
            onCompleteParamsProxy = vars.onCompleteParams;
            var lastIndex:* = (l - 1);
            i;
            while (i < l)
            {
                
                varsDup;
                var _loc_8:* = 0;
                var _loc_9:* = vars;
                while (_loc_9 in _loc_8)
                {
                    
                    p = _loc_9[_loc_8];
                    varsDup[p] = _loc_9[p];
                }
                varsDup.delay = curDelay;
                if (i == lastIndex && onCompleteAll != null)
                {
                    varsDup.onComplete = function () : void
            {
                if (onCompleteProxy != null)
                {
                    onCompleteProxy.apply(null, onCompleteParamsProxy);
                }
                onCompleteAll.apply(null, onCompleteAllParams);
                return;
            }// end function
            ;
                }
                a[i] = new TweenMax(targets[i], duration, varsDup);
                curDelay = curDelay + stagger;
                i = (i + 1);
            }
            return a;
        }// end function

        public static function allFrom(param1:Array, param2:Number, param3:Object, param4:Number = 0, param5:Function = null, param6:Array = null) : Array
        {
            if (param3.isGSVars)
            {
                param3 = param3.vars;
            }
            param3.runBackwards = true;
            if (!("immediateRender" in param3))
            {
                param3.immediateRender = true;
            }
            return allTo(param1, param2, param3, param4, param5, param6);
        }// end function

        public static function allFromTo(param1:Array, param2:Number, param3:Object, param4:Object, param5:Number = 0, param6:Function = null, param7:Array = null) : Array
        {
            if (param4.isGSVars)
            {
                param4 = param4.vars;
            }
            if (param3.isGSVars)
            {
                param3 = param3.vars;
            }
            param4.startAt = param3;
            if (param3.immediateRender)
            {
                param4.immediateRender = true;
            }
            return allTo(param1, param2, param4, param5, param6, param7);
        }// end function

        public static function delayedCall(param1:Number, param2:Function, param3:Array = null, param4:Boolean = false) : TweenMax
        {
            return new TweenMax(param2, 0, {delay:param1, onComplete:param2, onCompleteParams:param3, immediateRender:false, useFrames:param4, overwrite:0});
        }// end function

        public static function getTweensOf(param1:Object) : Array
        {
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_2:* = masterList[param1];
            var _loc_3:* = [];
            if (_loc_2)
            {
                _loc_4 = _loc_2.length;
                _loc_5 = 0;
                while (--_loc_4 > -1)
                {
                    
                    if (!TweenLite(_loc_2[_loc_4]).gc)
                    {
                        _loc_3[++_loc_5] = _loc_2[_loc_4];
                    }
                }
            }
            return _loc_3;
        }// end function

        public static function isTweening(param1:Object) : Boolean
        {
            var _loc_4:* = null;
            var _loc_2:* = getTweensOf(param1);
            var _loc_3:* = _loc_2.length;
            while (--_loc_3 > -1)
            {
                
                _loc_4 = _loc_2[_loc_3];
                if (_loc_4.active || _loc_4.cachedStartTime == _loc_4.timeline.cachedTime && _loc_4.timeline.active)
                {
                    return true;
                }
            }
            return false;
        }// end function

        public static function getAllTweens() : Array
        {
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_1:* = masterList;
            var _loc_2:* = 0;
            var _loc_3:* = [];
            for each (_loc_4 in _loc_1)
            {
                
                _loc_5 = _loc_4.length;
                while (--_loc_5 > -1)
                {
                    
                    if (!TweenLite(_loc_4[_loc_5]).gc)
                    {
                        _loc_3[++_loc_2] = _loc_4[_loc_5];
                    }
                }
            }
            return _loc_3;
        }// end function

        public static function killAll(param1:Boolean = false, param2:Boolean = true, param3:Boolean = true) : void
        {
            var _loc_5:* = false;
            var _loc_4:* = getAllTweens();
            var _loc_6:* = _loc_4.length;
            while (--_loc_6 > -1)
            {
                
                _loc_5 = _loc_4[_loc_6].target == _loc_4[_loc_6].vars.onComplete;
                if (_loc_5 == param3 || _loc_5 != param2)
                {
                    if (param1)
                    {
                        _loc_4[_loc_6].complete(false);
                        continue;
                    }
                    _loc_4[_loc_6].setEnabled(false, false);
                }
            }
            return;
        }// end function

        public static function killChildTweensOf(param1:DisplayObjectContainer, param2:Boolean = false) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_3:* = getAllTweens();
            var _loc_6:* = _loc_3.length;
            while (--_loc_6 > -1)
            {
                
                _loc_4 = _loc_3[_loc_6].target;
                if (_loc_4 is DisplayObject)
                {
                    _loc_5 = _loc_4.parent;
                    while (_loc_5)
                    {
                        
                        if (_loc_5 == param1)
                        {
                            if (param2)
                            {
                                _loc_3[_loc_6].complete(false);
                            }
                            else
                            {
                                _loc_3[_loc_6].setEnabled(false, false);
                            }
                        }
                        _loc_5 = _loc_5.parent;
                    }
                }
            }
            return;
        }// end function

        public static function pauseAll(param1:Boolean = true, param2:Boolean = true) : void
        {
            changePause(true, param1, param2);
            return;
        }// end function

        public static function resumeAll(param1:Boolean = true, param2:Boolean = true) : void
        {
            changePause(false, param1, param2);
            return;
        }// end function

        private static function changePause(param1:Boolean, param2:Boolean = true, param3:Boolean = false) : void
        {
            var _loc_5:* = false;
            var _loc_4:* = getAllTweens();
            var _loc_6:* = _loc_4.length;
            while (--_loc_6 > -1)
            {
                
                _loc_5 = TweenLite(_loc_4[_loc_6]).target == TweenLite(_loc_4[_loc_6]).vars.onComplete;
                if (_loc_5 == param3 || _loc_5 != param2)
                {
                    TweenCore(_loc_4[_loc_6]).paused = param1;
                }
            }
            return;
        }// end function

        public static function get globalTimeScale() : Number
        {
            return TweenLite.rootTimeline == null ? (1) : (TweenLite.rootTimeline.cachedTimeScale);
        }// end function

        public static function set globalTimeScale(param1:Number) : void
        {
            if (param1 == 0)
            {
                param1 = 0.0001;
            }
            if (TweenLite.rootTimeline == null)
            {
                TweenLite.to({}, 0, {});
            }
            var _loc_2:* = TweenLite.rootTimeline;
            var _loc_3:* = getTimer() * 0.001;
            _loc_2.cachedStartTime = _loc_3 - (_loc_3 - _loc_2.cachedStartTime) * _loc_2.cachedTimeScale / param1;
            _loc_2 = TweenLite.rootFramesTimeline;
            _loc_3 = TweenLite.rootFrame;
            _loc_2.cachedStartTime = _loc_3 - (_loc_3 - _loc_2.cachedStartTime) * _loc_2.cachedTimeScale / param1;
            var _loc_4:* = param1;
            TweenLite.rootTimeline.cachedTimeScale = param1;
            _loc_2.cachedTimeScale = _loc_4;
            return;
        }// end function

        TweenPlugin.activate([AutoAlphaPlugin, EndArrayPlugin, FramePlugin, RemoveTintPlugin, TintPlugin, VisiblePlugin, VolumePlugin, BevelFilterPlugin, BezierPlugin, BezierThroughPlugin, BlurFilterPlugin, ColorMatrixFilterPlugin, ColorTransformPlugin, DropShadowFilterPlugin, FrameLabelPlugin, GlowFilterPlugin, HexColorsPlugin, RoundPropsPlugin, ShortRotationPlugin, {}]);
    }
}
