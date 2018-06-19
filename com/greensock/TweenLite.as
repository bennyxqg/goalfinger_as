package com.greensock
{
    import com.greensock.core.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class TweenLite extends TweenCore
    {
        public var target:Object;
        public var propTweenLookup:Object;
        public var ratio:Number = 0;
        public var cachedPT1:PropTween;
        protected var _ease:Function;
        protected var _overwrite:int;
        protected var _overwrittenProps:Object;
        protected var _hasPlugins:Boolean;
        protected var _notifyPluginsOfEnabled:Boolean;
        public static const version:Number = 11.698;
        public static var plugins:Object = {};
        public static var fastEaseLookup:Dictionary = new Dictionary(false);
        public static var onPluginEvent:Function;
        public static var killDelayedCallsTo:Function = TweenLite.killTweensOf;
        public static var defaultEase:Function = TweenLite.easeOut;
        public static var overwriteManager:Object;
        public static var rootFrame:Number;
        public static var rootTimeline:SimpleTimeline;
        public static var rootFramesTimeline:SimpleTimeline;
        public static var masterList:Dictionary = new Dictionary(false);
        private static var _shape:Shape = new Shape();
        static var _reservedProps:Object = {ease:1, delay:1, overwrite:1, onComplete:1, onCompleteParams:1, useFrames:1, runBackwards:1, startAt:1, onUpdate:1, onUpdateParams:1, onStart:1, onStartParams:1, onInit:1, onInitParams:1, onReverseComplete:1, onReverseCompleteParams:1, onRepeat:1, onRepeatParams:1, proxiedEase:1, easeParams:1, yoyo:1, onCompleteListener:1, onUpdateListener:1, onStartListener:1, onReverseCompleteListener:1, onRepeatListener:1, orientToBezier:1, timeScale:1, immediateRender:1, repeat:1, repeatDelay:1, timeline:1, data:1, paused:1, reversed:1};

        public function TweenLite(param1:Object, param2:Number, param3:Object)
        {
            var _loc_5:* = null;
            super(param2, param3);
            if (param1 == null)
            {
                throw new Error("Cannot tween a null object.");
            }
            this.target = param1;
            if (this.target is TweenCore && this.vars.timeScale)
            {
                this.cachedTimeScale = 1;
            }
            this.propTweenLookup = {};
            this._ease = defaultEase;
            this._overwrite = Number(param3.overwrite) <= -1 || !overwriteManager.enabled && param3.overwrite > 1 ? (overwriteManager.mode) : (int(param3.overwrite));
            var _loc_4:* = masterList[param1];
            if (!masterList[param1])
            {
                masterList[param1] = [this];
            }
            else if (this._overwrite == 1)
            {
                for each (_loc_5 in _loc_4)
                {
                    
                    if (!_loc_5.gc)
                    {
                        _loc_5.setEnabled(false, false);
                    }
                }
                masterList[param1] = [this];
            }
            else
            {
                _loc_4[_loc_4.length] = this;
            }
            if (this.active || this.vars.immediateRender)
            {
                this.renderTime(0, false, true);
            }
            return;
        }// end function

        protected function init() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = 0;
            var _loc_3:* = undefined;
            var _loc_4:* = false;
            var _loc_5:* = null;
            var _loc_6:* = null;
            if (this.vars.onInit)
            {
                this.vars.onInit.apply(null, this.vars.onInitParams);
            }
            if (typeof(this.vars.ease) == "function")
            {
                this._ease = this.vars.ease;
            }
            if (this.vars.easeParams)
            {
                this.vars.proxiedEase = this._ease;
                this._ease = this.easeProxy;
            }
            this.cachedPT1 = null;
            this.propTweenLookup = {};
            for (_loc_1 in this.vars)
            {
                
                if (_loc_1 in _reservedProps && !(_loc_1 == "timeScale" && this.target is TweenCore))
                {
                    continue;
                }
                var _loc_9:* = new (plugins[_loc_1] as Class)();
                _loc_3 = new (plugins[_loc_1] as Class)();
                if (_loc_1 in plugins && _loc_9.onInitTween(this.target, _loc_8[_loc_1], this))
                {
                    this.cachedPT1 = new PropTween(_loc_3, "changeFactor", 0, 1, _loc_3.overwriteProps.length == 1 ? (_loc_3.overwriteProps[0]) : ("_MULTIPLE_"), true, this.cachedPT1);
                    if (this.cachedPT1.name == "_MULTIPLE_")
                    {
                        _loc_2 = _loc_3.overwriteProps.length;
                        while (--_loc_2 > -1)
                        {
                            
                            this.propTweenLookup[_loc_3.overwriteProps[_loc_2]] = this.cachedPT1;
                        }
                    }
                    else
                    {
                        this.propTweenLookup[this.cachedPT1.name] = this.cachedPT1;
                    }
                    if (_loc_3.priority)
                    {
                        this.cachedPT1.priority = _loc_3.priority;
                        _loc_4 = true;
                    }
                    if (_loc_3.onDisable || _loc_3.onEnable)
                    {
                        this._notifyPluginsOfEnabled = true;
                    }
                    this._hasPlugins = true;
                    continue;
                }
                this.cachedPT1 = new PropTween(this.target, _loc_1, Number(this.target[_loc_1]), typeof(_loc_8[_loc_1]) == "number" ? (Number(_loc_8[_loc_1]) - this.target[_loc_1]) : (Number(_loc_8[_loc_1])), _loc_1, false, this.cachedPT1);
                this.propTweenLookup[_loc_1] = this.cachedPT1;
            }
            if (_loc_4)
            {
                onPluginEvent("onInitAllProps", this);
            }
            if (_loc_8.runBackwards)
            {
                _loc_6 = this.cachedPT1;
                while (_loc_6)
                {
                    
                    _loc_6.start = _loc_6.start + _loc_6.change;
                    _loc_6.change = -_loc_6.change;
                    _loc_6 = _loc_6.nextNode;
                }
            }
            _hasUpdate = Boolean(_loc_8.onUpdate != null);
            if (this._overwrittenProps)
            {
                this.killVars(this._overwrittenProps);
                if (this.cachedPT1 == null)
                {
                    this.setEnabled(false, false);
                }
            }
            var _loc_7:* = masterList[this.target];
            _loc_5 = masterList[this.target];
            if (this._overwrite > 1 && this.cachedPT1 && _loc_7 && _loc_5.length > 1)
            {
                if (overwriteManager.manageOverwrites(this, this.propTweenLookup, _loc_5, this._overwrite))
                {
                    this.init();
                }
            }
            this.initted = true;
            return;
        }// end function

        override public function renderTime(param1:Number, param2:Boolean = false, param3:Boolean = false) : void
        {
            var _loc_4:* = false;
            var _loc_5:* = this.cachedTime;
            if (param1 >= this.cachedDuration)
            {
                var _loc_7:* = this.cachedDuration;
                this.cachedTime = this.cachedDuration;
                this.cachedTotalTime = _loc_7;
                this.ratio = 1;
                _loc_4 = !this.cachedReversed;
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
                var _loc_7:* = 0;
                this.ratio = 0;
                this.cachedTime = _loc_7;
                this.cachedTotalTime = _loc_7;
                if (param1 < 0)
                {
                    this.active = false;
                    if (this.cachedDuration == 0)
                    {
                        if (_rawPrevTime >= 0)
                        {
                            param3 = true;
                            _loc_4 = _rawPrevTime > 0;
                        }
                        _rawPrevTime = param1;
                    }
                }
                if (this.cachedReversed && _loc_5 != 0)
                {
                    _loc_4 = true;
                }
            }
            else
            {
                var _loc_7:* = param1;
                this.cachedTime = param1;
                this.cachedTotalTime = _loc_7;
                this.ratio = this._ease(param1, 0, 1, this.cachedDuration);
            }
            if (this.cachedTime == _loc_5 && !param3)
            {
                return;
            }
            if (!this.initted)
            {
                this.init();
                if (!_loc_4 && this.cachedTime)
                {
                    this.ratio = this._ease(this.cachedTime, 0, 1, this.cachedDuration);
                }
            }
            if (!this.active && !this.cachedPaused)
            {
                this.active = true;
            }
            if (_loc_5 == 0 && this.vars.onStart && (this.cachedTime != 0 || this.cachedDuration == 0) && !param2)
            {
                this.vars.onStart.apply(null, this.vars.onStartParams);
            }
            var _loc_6:* = this.cachedPT1;
            while (_loc_6)
            {
                
                _loc_6.target[_loc_6.property] = _loc_6.start + this.ratio * _loc_6.change;
                _loc_6 = _loc_6.nextNode;
            }
            if (_hasUpdate && !param2)
            {
                this.vars.onUpdate.apply(null, this.vars.onUpdateParams);
            }
            if (_loc_4 && !this.gc)
            {
                if (this._hasPlugins && this.cachedPT1)
                {
                    onPluginEvent("onComplete", this);
                }
                complete(true, param2);
            }
            return;
        }// end function

        public function killVars(param1:Object, param2:Boolean = true) : Boolean
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = false;
            if (this._overwrittenProps == null)
            {
                this._overwrittenProps = {};
            }
            for (_loc_3 in param1)
            {
                
                if (_loc_3 in this.propTweenLookup)
                {
                    _loc_4 = this.propTweenLookup[_loc_3];
                    if (_loc_4.isPlugin && _loc_4.name == "_MULTIPLE_")
                    {
                        _loc_4.target.killProps(param1);
                        if (_loc_4.target.overwriteProps.length == 0)
                        {
                            _loc_4.name = "";
                        }
                        if (_loc_3 != _loc_4.target.propName || _loc_4.name == "")
                        {
                            delete this.propTweenLookup[_loc_3];
                        }
                    }
                    if (_loc_4.name != "_MULTIPLE_")
                    {
                        if (_loc_4.nextNode)
                        {
                            _loc_4.nextNode.prevNode = _loc_4.prevNode;
                        }
                        if (_loc_4.prevNode)
                        {
                            _loc_4.prevNode.nextNode = _loc_4.nextNode;
                        }
                        else if (this.cachedPT1 == _loc_4)
                        {
                            this.cachedPT1 = _loc_4.nextNode;
                        }
                        if (_loc_4.isPlugin && _loc_4.target.onDisable)
                        {
                            _loc_4.target.onDisable();
                            if (_loc_4.target.activeDisable)
                            {
                                _loc_5 = true;
                            }
                        }
                        delete this.propTweenLookup[_loc_3];
                    }
                }
                if (param2 && param1 != this._overwrittenProps)
                {
                    this._overwrittenProps[_loc_3] = 1;
                }
            }
            return _loc_5;
        }// end function

        override public function invalidate() : void
        {
            if (this._notifyPluginsOfEnabled && this.cachedPT1)
            {
                onPluginEvent("onDisable", this);
            }
            this.cachedPT1 = null;
            this._overwrittenProps = null;
            var _loc_1:* = false;
            this._notifyPluginsOfEnabled = false;
            this.active = _loc_1;
            this.initted = _loc_1;
            _hasUpdate = _loc_1;
            this.propTweenLookup = {};
            return;
        }// end function

        override public function setEnabled(param1:Boolean, param2:Boolean = false) : Boolean
        {
            var _loc_3:* = null;
            if (param1)
            {
                _loc_3 = TweenLite.masterList[this.target];
                if (!_loc_3)
                {
                    TweenLite.masterList[this.target] = [this];
                }
                else if (_loc_3.indexOf(this) == -1)
                {
                    _loc_3[_loc_3.length] = this;
                }
            }
            super.setEnabled(param1, param2);
            if (this._notifyPluginsOfEnabled && this.cachedPT1)
            {
                return onPluginEvent(param1 ? ("onEnable") : ("onDisable"), this);
            }
            return false;
        }// end function

        protected function easeProxy(param1:Number, param2:Number, param3:Number, param4:Number) : Number
        {
            return this.vars.proxiedEase.apply(null, arguments.concat(this.vars.easeParams));
        }// end function

        public static function initClass() : void
        {
            rootFrame = 0;
            rootTimeline = new SimpleTimeline(null);
            rootFramesTimeline = new SimpleTimeline(null);
            rootTimeline.cachedStartTime = getTimer() * 0.001;
            rootFramesTimeline.cachedStartTime = rootFrame;
            rootTimeline.autoRemoveChildren = true;
            rootFramesTimeline.autoRemoveChildren = true;
            _shape.addEventListener(Event.ENTER_FRAME, updateAll, false, 0, true);
            if (overwriteManager == null)
            {
                overwriteManager = {mode:1, enabled:false};
            }
            return;
        }// end function

        public static function to(param1:Object, param2:Number, param3:Object) : TweenLite
        {
            return new TweenLite(param1, param2, param3);
        }// end function

        public static function from(param1:Object, param2:Number, param3:Object) : TweenLite
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
            return new TweenLite(param1, param2, param3);
        }// end function

        public static function delayedCall(param1:Number, param2:Function, param3:Array = null, param4:Boolean = false) : TweenLite
        {
            return new TweenLite(param2, 0, {delay:param1, onComplete:param2, onCompleteParams:param3, immediateRender:false, useFrames:param4, overwrite:0});
        }// end function

        static function updateAll(event:Event = null) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = 0;
            rootTimeline.renderTime((getTimer() * 0.001 - rootTimeline.cachedStartTime) * rootTimeline.cachedTimeScale, false, false);
            (rootFrame + 1);
            rootFramesTimeline.renderTime((rootFrame - rootFramesTimeline.cachedStartTime) * rootFramesTimeline.cachedTimeScale, false, false);
            if (!(rootFrame % 60))
            {
                _loc_2 = masterList;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_4 = _loc_2[_loc_3];
                    _loc_5 = _loc_4.length;
                    while (--_loc_5 > -1)
                    {
                        
                        if (TweenLite.TweenLite(_loc_4[_loc_5]).gc)
                        {
                            _loc_4.splice(_loc_5, 1);
                        }
                    }
                    if (_loc_4.length == 0)
                    {
                        delete _loc_2[_loc_3];
                    }
                }
            }
            return;
        }// end function

        public static function killTweensOf(param1:Object, param2:Boolean = false, param3:Object = null) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = null;
            if (param1 in masterList)
            {
                _loc_4 = masterList[param1];
                _loc_5 = _loc_4.length;
                while (--_loc_5 > -1)
                {
                    
                    _loc_6 = _loc_4[_loc_5];
                    if (!_loc_6.gc)
                    {
                        if (param2)
                        {
                            _loc_6.complete(false, false);
                        }
                        if (param3 != null)
                        {
                            _loc_6.killVars(param3);
                        }
                        if (param3 == null || _loc_6.cachedPT1 == null && _loc_6.initted)
                        {
                            _loc_6.setEnabled(false, false);
                        }
                    }
                }
                if (param3 == null)
                {
                    delete masterList[param1];
                }
            }
            return;
        }// end function

        static function easeOut(param1:Number, param2:Number, param3:Number, param4:Number) : Number
        {
            var _loc_5:* = 1 - param1 / param4;
            param1 = 1 - param1 / param4;
            return 1 - _loc_5 * param1;
        }// end function

    }
}
