package tools
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filesystem.*;
    import flash.media.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;

    public class SoundManager extends MovieClip
    {
        public var vMusicVolume:int = 100;
        private var vSFXVolume:int = 100;
        public var vGlobalVolume:Boolean;
        public var vPause:Boolean;
        public var vPauseTimer:int;
        private const MAX_SFX:int = 20;
        private var vSFXTab:Array;
        private var vEnterFrameSFX:Boolean;
        private var vSFXTmp:Sound;
        private var vSFXVolumeTmp:Number;
        private var vSFXFunTmp:Function;
        private var vSFXPostWait:Number;
        private var vSFXLoop:Number;
        private var vSFXQueueList:Vector.<Object>;
        private var vMusic:Sound;
        private var vNextMusic:Sound;
        private var vMusicChannel:SoundChannel;
        private var vMusicTransform:SoundTransform;
        private var vMusicIsPlaying:Boolean;
        private var vVolume:Number;
        private var vNextVolume:Number;
        private var vFadeSpeed:Number = 0.0333333;
        private var vMusicStart:Number;
        private var vMusicEnd:Number;
        private var vMusicTimer:Timer;
        private var vFade:Boolean;
        private var vMusicLoop:int;
        private var vMusicTmp:Sound;
        private var vMusicVolumeTmp:Number;
        private var vMusicStartTmp:Number;
        private var vMusicEndTmp:Number;
        private var vMusicFadeTmp:Boolean;
        private var vMusicLoopTmp:Number;
        private var vMusicID:String;
        private var vMusicPausePosition:Number;
        private var vMusicPauseST:SoundTransform;
        static var current:SoundManager;

        public function SoundManager()
        {
            this.vGlobalVolume = true;
            this.vPause = false;
            this.vSFXTab = new Array();
            this.vEnterFrameSFX = false;
            this.vSFXQueueList = new Vector.<Object>;
            this.vMusicIsPlaying = false;
            this.vVolume = 0;
            this.vNextVolume = 1;
            this.vMusicStart = 0;
            this.vMusicEnd = 0;
            return;
        }// end function

        public function onConfigReady() : void
        {
            var _loc_1:* = SharedObject.getLocal(Global.SO_ID);
            if (_loc_1.data.sound == 0)
            {
                this.vSFXVolume = 0;
            }
            else
            {
                this.vSFXVolume = 100;
            }
            if (_loc_1.data.music == 0)
            {
                this.vMusicVolume = 0;
            }
            else
            {
                this.vMusicVolume = 100;
            }
            if (this.vMusicIsPlaying && this.vGlobalVolume)
            {
                if (this.vMusicChannel)
                {
                    this.vMusicTransform = this.vMusicChannel.soundTransform;
                    this.vMusicTransform.volume = this.vVolume * this.vMusicVolume / 100;
                    this.vMusicChannel.soundTransform = this.vMusicTransform;
                }
            }
            return;
        }// end function

        public function playSound(param1:Sound = null, param2:Number = 1, param3:int = 1, param4:Function = null, param5:Number = 0) : SoundChannel
        {
            var _loc_6:* = 0;
            var _loc_7:* = NaN;
            var _loc_8:* = null;
            if (this.vSFXVolume == 0)
            {
                return null;
            }
            if (Global.vSound.vDeactivated)
            {
                return null;
            }
            if (param1 == null)
            {
                if (this.vSFXTab && this.vSFXTab.length > 0)
                {
                    _loc_6 = 0;
                    while (_loc_6 < this.vSFXTab.length)
                    {
                        
                        this.clearSFX(_loc_6);
                        _loc_6++;
                    }
                }
                this.vSFXTab = new Array();
                removeEventListener(Event.ENTER_FRAME, this.CheckSFX);
                this.vEnterFrameSFX = false;
                return null;
            }
            if (this.vSFXTab.length >= this.MAX_SFX)
            {
                return null;
            }
            if (param1)
            {
                _loc_7 = param2 * this.vSFXVolume / 100;
                _loc_8 = new Object();
                if (this.vGlobalVolume)
                {
                    _loc_8.sndChn = param1.play(0, 1, new SoundTransform(_loc_7, 0));
                }
                else
                {
                    _loc_8.sndChn = param1.play(0, 1, new SoundTransform(0, 0));
                }
                if (_loc_8.sndChn == null)
                {
                    this.destroy();
                    return null;
                }
                _loc_8.vSound = param1;
                _loc_8.vLoop = param3;
                _loc_8.vPostWait = param5;
                _loc_8.vPauseTimer = 0;
                if (param3 == 1)
                {
                    _loc_8.sndEndTimer = getTimer() + param1.length + param5 * 1000;
                }
                else
                {
                    _loc_8.sndEndTimer = getTimer() + param1.length;
                }
                _loc_8.sndVolume = param2;
                _loc_8.vFun = param4;
                this.vSFXTab.push(_loc_8);
                if (!this.vEnterFrameSFX)
                {
                    addEventListener(Event.ENTER_FRAME, this.CheckSFX);
                    this.vEnterFrameSFX = true;
                }
                return _loc_8.sndChn;
            }
            else
            {
                return null;
            }
        }// end function

        public function playFX(param1:String, param2:Number = 1, param3:int = 1, param4:Function = null, param5:Number = 0) : Object
        {
            return this.playSFX(param1, param2, param3, param4, param5);
        }// end function

        public function stopMusic() : void
        {
            this.playMusic(null);
            return;
        }// end function

        public function pauseLoop() : void
        {
            this.pauseAll();
            return;
        }// end function

        public function resumeLoop() : void
        {
            this.resumeAll();
            return;
        }// end function

        public function onDeactivate() : void
        {
            this.pauseLoop();
            return;
        }// end function

        public function onActivate() : void
        {
            this.resumeLoop();
            return;
        }// end function

        public function onDestroyGame() : void
        {
            this.destroy();
            return;
        }// end function

        final private function pauseAll() : void
        {
            var _loc_1:* = 0;
            if (!this.vPause)
            {
                this.vPause = true;
                this.vPauseTimer = getTimer();
                if (this.vMusicTimer)
                {
                    this.vMusicTimer.stop();
                }
                if (this.vMusicChannel)
                {
                    this.vMusicChannel.removeEventListener(Event.SOUND_COMPLETE, this.musicIsComplete);
                    this.vMusicPausePosition = this.vMusicChannel.position;
                    this.vMusicPauseST = this.vMusicChannel.soundTransform;
                    this.vMusicChannel.stop();
                }
                this.playSFX(null);
            }
            return;
        }// end function

        final private function resumeAll() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = NaN;
            var _loc_3:* = 0;
            if (this.vPause)
            {
                this.vPause = false;
                _loc_3 = getTimer() - this.vPauseTimer;
                if (this.vMusicChannel)
                {
                    if (this.vMusic)
                    {
                        this.vMusicChannel = null;
                        _loc_2 = this.vVolume * this.vMusicVolume / 100;
                        if (this.vGlobalVolume)
                        {
                            this.vMusicChannel = this.vMusic.play(this.vMusicPausePosition, 1, new SoundTransform(_loc_2, 0));
                        }
                        else
                        {
                            this.vMusicChannel = this.vMusic.play(this.vMusicPausePosition, 1, new SoundTransform(0, 0));
                        }
                        if (this.vMusicChannel == null)
                        {
                            this.destroy();
                            return;
                        }
                        this.vMusicChannel.addEventListener(Event.SOUND_COMPLETE, this.musicIsComplete);
                    }
                }
                if (this.vMusicTimer)
                {
                    this.vMusicTimer.start();
                }
            }
            return;
        }// end function

        public function playSFX(param1:String = null, param2:Number = 1, param3:Number = 1, param4:Function = null, param5:Number = 0) : Object
        {
            var _loc_6:* = 0;
            var _loc_8:* = null;
            var _loc_9:* = 0;
            var _loc_10:* = null;
            var _loc_11:* = NaN;
            var _loc_12:* = null;
            var _loc_13:* = 0;
            var _loc_14:* = null;
            var _loc_15:* = null;
            if (param1 == null || param1 == "")
            {
                if (this.vSFXTab && this.vSFXTab.length > 0)
                {
                    _loc_6 = 0;
                    while (_loc_6 < this.vSFXTab.length)
                    {
                        
                        this.clearSFX(_loc_6);
                        _loc_6++;
                    }
                }
                this.vSFXTab = new Array();
                removeEventListener(Event.ENTER_FRAME, this.CheckSFX);
                this.vEnterFrameSFX = false;
                if (this.vSFXTmp != null)
                {
                    this.vSFXTmp.removeEventListener(Event.COMPLETE, this.loadSFXComplete);
                    this.vSFXTmp.removeEventListener(IOErrorEvent.IO_ERROR, this.handleSFXIOError);
                    try
                    {
                        this.vSFXTmp.close();
                    }
                    catch (err:Error)
                    {
                    }
                    this.vSFXTmp = null;
                    this.vSFXVolumeTmp = 0;
                    this.vSFXFunTmp = null;
                    this.vSFXPostWait = 0;
                    this.vSFXLoop = 0;
                }
                this.vSFXQueueList = new Vector.<Object>;
                return null;
            }
            var _loc_7:* = param1.split(",");
            if (_loc_7.length > 1)
            {
                _loc_9 = Math.floor(Math.random() * _loc_7.length);
                param1 = _loc_7[_loc_9];
            }
            if (this.vSFXTab.length >= this.MAX_SFX)
            {
                return null;
            }
            if (ApplicationDomain.currentDomain.hasDefinition(param1))
            {
                _loc_8 = Class(getDefinitionByName(param1));
            }
            if (_loc_8)
            {
                _loc_10 = new _loc_8;
                _loc_11 = param2 * this.vSFXVolume / 100;
                _loc_12 = new Object();
                if (this.vGlobalVolume)
                {
                    _loc_12.sndChn = _loc_10.play(0, 1, new SoundTransform(_loc_11, 0));
                }
                else
                {
                    _loc_12.sndChn = _loc_10.play(0, 1, new SoundTransform(0, 0));
                }
                if (_loc_12.sndChn == null)
                {
                    this.destroy();
                    return null;
                }
                _loc_12.vSound = _loc_10;
                _loc_12.vLoop = param3;
                _loc_12.vPostWait = param5;
                _loc_12.vPauseTimer = 0;
                if (param3 == 1)
                {
                    _loc_12.sndEndTimer = getTimer() + _loc_10.length + param5 * 1000;
                }
                else
                {
                    _loc_12.sndEndTimer = getTimer() + _loc_10.length;
                }
                _loc_12.sndVolume = param2;
                _loc_12.vFun = param4;
                this.vSFXTab.push(_loc_12);
                if (!this.vEnterFrameSFX)
                {
                    addEventListener(Event.ENTER_FRAME, this.CheckSFX);
                    this.vEnterFrameSFX = true;
                }
                return _loc_12;
            }
            else
            {
                if (this.vSFXTmp != null)
                {
                    _loc_13 = this.vSFXQueueList.length;
                    this.vSFXQueueList[_loc_13] = new Object();
                    this.vSFXQueueList[_loc_13].vID = param1;
                    this.vSFXQueueList[_loc_13].vSFXVolumeTmp = param2;
                    this.vSFXQueueList[_loc_13].vSFXFunTmp = param4;
                    this.vSFXQueueList[_loc_13].vSFXPostWait = param5;
                    this.vSFXQueueList[_loc_13].vSFXLoop = param3;
                    return null;
                }
                this.vSFXVolumeTmp = param2;
                this.vSFXFunTmp = param4;
                this.vSFXPostWait = param5;
                this.vSFXLoop = param3;
                _loc_14 = File.applicationDirectory.resolvePath("assets/" + param1);
                _loc_15 = new URLRequest(_loc_14.url);
                this.vSFXTmp = new Sound();
                this.vSFXTmp.addEventListener(Event.COMPLETE, this.loadSFXComplete);
                this.vSFXTmp.addEventListener(IOErrorEvent.IO_ERROR, this.handleSFXIOError);
                this.vSFXTmp.load(_loc_15);
            }
            return null;
        }// end function

        final private function handleSFXIOError(event:IOErrorEvent) : void
        {
            this.vSFXTmp = null;
            this.vSFXVolumeTmp = 0;
            this.vSFXFunTmp = null;
            this.vSFXPostWait = 0;
            this.vSFXLoop = 0;
            return;
        }// end function

        final private function loadSFXComplete(event:Event = null) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = NaN;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            if (this.vSFXTmp != null)
            {
                this.vSFXTmp.removeEventListener(Event.COMPLETE, this.loadSFXComplete);
                this.vSFXTmp.removeEventListener(IOErrorEvent.IO_ERROR, this.handleSFXIOError);
                _loc_2 = new Object();
                _loc_3 = this.vSFXVolumeTmp * this.vSFXVolume / 100;
                if (this.vGlobalVolume)
                {
                    _loc_2.sndChn = this.vSFXTmp.play(0, 1, new SoundTransform(_loc_3, 0));
                }
                else
                {
                    _loc_2.sndChn = this.vSFXTmp.play(0, 1, new SoundTransform(0, 0));
                }
                if (_loc_2.sndChn == null)
                {
                    this.destroy();
                    return;
                }
                _loc_2.vSound = this.vSFXTmp;
                _loc_2.vLoop = this.vSFXLoop;
                _loc_2.vPostWait = this.vSFXPostWait;
                _loc_2.vPauseTimer = 0;
                if (this.vSFXLoop == 1)
                {
                    _loc_2.sndEndTimer = getTimer() + this.vSFXTmp.length + this.vSFXPostWait * 1000;
                }
                else
                {
                    _loc_2.sndEndTimer = getTimer() + this.vSFXTmp.length;
                }
                _loc_2.sndVolume = this.vSFXVolumeTmp;
                _loc_2.vFun = this.vSFXFunTmp;
                this.vSFXTab.push(_loc_2);
                if (!this.vEnterFrameSFX)
                {
                    addEventListener(Event.ENTER_FRAME, this.CheckSFX);
                    this.vEnterFrameSFX = true;
                }
            }
            this.vSFXTmp = null;
            this.vSFXVolumeTmp = 0;
            this.vSFXFunTmp = null;
            this.vSFXPostWait = 0;
            this.vSFXLoop = 0;
            if (this.vSFXQueueList.length > 0)
            {
                _loc_4 = this.vSFXQueueList.shift();
                this.vSFXVolumeTmp = _loc_4.vSFXVolumeTmp;
                this.vSFXFunTmp = _loc_4.vSFXFunTmp;
                this.vSFXPostWait = _loc_4.vSFXPostWait;
                this.vSFXLoop = _loc_4.vSFXLoop;
                _loc_5 = File.applicationDirectory.resolvePath("assets/" + _loc_4.vID);
                _loc_6 = new URLRequest(_loc_5.url);
                this.vSFXTmp = new Sound();
                this.vSFXTmp.addEventListener(Event.COMPLETE, this.loadSFXComplete);
                this.vSFXTmp.addEventListener(IOErrorEvent.IO_ERROR, this.handleSFXIOError);
                this.vSFXTmp.load(_loc_6);
            }
            return;
        }// end function

        public function playMusic(param1:String = null, param2:Number = 1, param3:int = -1) : void
        {
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = null;
            var _loc_8:* = null;
            if (param1 == null)
            {
                this.vMusicID = null;
                this.vNextMusic = null;
                this.musicStop();
                return;
            }
            if (this.vPause)
            {
                return;
            }
            var _loc_4:* = param1.split(",");
            if (_loc_4.length > 1)
            {
                _loc_6 = Math.floor(Math.random() * _loc_4.length);
                param1 = _loc_4[_loc_6];
            }
            if (this.vMusicID == param1)
            {
                return;
            }
            this.vMusicID = param1;
            if (this.vMusicTmp != null)
            {
                this.vMusicTmp.removeEventListener(Event.COMPLETE, this.loadMusicComplete);
                this.vMusicTmp.removeEventListener(IOErrorEvent.IO_ERROR, this.handleMusicIOError);
                try
                {
                    this.vMusicTmp.close();
                }
                catch (err:Error)
                {
                }
                this.vMusicTmp = null;
                this.vMusicVolumeTmp = 0;
                this.vMusicLoopTmp = 0;
            }
            if (ApplicationDomain.currentDomain.hasDefinition(param1))
            {
                _loc_5 = Class(getDefinitionByName(param1));
            }
            this.vMusicVolumeTmp = param2;
            this.vMusicLoopTmp = param3;
            if (_loc_5)
            {
                this.vMusicTmp = new _loc_5 as Sound;
                this.playMusicForReal();
            }
            else
            {
                _loc_7 = File.applicationDirectory.resolvePath("assets/" + param1);
                _loc_8 = new URLRequest(_loc_7.url);
                this.vMusicTmp = new Sound();
                this.vMusicTmp.addEventListener(Event.COMPLETE, this.loadMusicComplete);
                this.vMusicTmp.addEventListener(IOErrorEvent.IO_ERROR, this.handleMusicIOError);
                this.vMusicTmp.load(_loc_8);
            }
            return;
        }// end function

        final private function handleMusicIOError(event:IOErrorEvent) : void
        {
            this.vMusicTmp = null;
            this.vMusicVolumeTmp = 0;
            this.vMusicStartTmp = 0;
            this.vMusicEndTmp = 0;
            this.vMusicFadeTmp = true;
            this.vMusicLoopTmp = 0;
            return;
        }// end function

        final private function loadMusicComplete(event:Event = null) : void
        {
            if (this.vMusicTmp != null)
            {
                this.vMusicTmp.removeEventListener(Event.COMPLETE, this.loadMusicComplete);
                this.vMusicTmp.removeEventListener(IOErrorEvent.IO_ERROR, this.handleMusicIOError);
                this.playMusicForReal();
            }
            return;
        }// end function

        final public function playMusicForReal(param1:Sound = null) : void
        {
            if (this.vMusicIsPlaying)
            {
                this.musicStop();
            }
            if (param1 == null)
            {
                this.vMusic = this.vMusicTmp;
            }
            else
            {
                this.vMusic = param1;
            }
            this.vMusicTmp = null;
            this.vNextMusic = null;
            this.vVolume = this.vMusicVolumeTmp;
            this.vNextVolume = 0;
            this.vMusicLoop = this.vMusicLoopTmp;
            var _loc_2:* = this.vVolume * this.vMusicVolume / 100;
            if (this.vGlobalVolume)
            {
                this.vMusicChannel = this.vMusic.play(0, 1, new SoundTransform(_loc_2, 0));
            }
            else
            {
                this.vMusicChannel = this.vMusic.play(0, 1, new SoundTransform(0, 0));
            }
            if (this.vMusicChannel == null)
            {
                this.destroy();
                return;
            }
            this.vMusicIsPlaying = true;
            if (this.vPause)
            {
                this.vPause = false;
                this.pauseAll();
                return;
            }
            this.vMusicChannel.addEventListener(Event.SOUND_COMPLETE, this.musicIsComplete);
            return;
        }// end function

        final private function musicIsComplete(event:Event) : void
        {
            var _loc_2:* = NaN;
            event.currentTarget.removeEventListener(event.type, this.musicIsComplete);
            if (this.vPause)
            {
                return;
            }
            if (this.vMusicLoop > 0)
            {
                var _loc_3:* = this;
                var _loc_4:* = this.vMusicLoop - 1;
                _loc_3.vMusicLoop = _loc_4;
            }
            if (this.vMusicLoop != 0)
            {
                if (this.vMusicChannel)
                {
                    this.vMusicChannel.stop();
                }
                this.vMusicChannel = null;
                _loc_2 = this.vVolume * this.vMusicVolume / 100;
                if (this.vGlobalVolume)
                {
                    this.vMusicChannel = this.vMusic.play(0, 1, new SoundTransform(_loc_2, 0));
                }
                else
                {
                    this.vMusicChannel = this.vMusic.play(0, 1, new SoundTransform(0, 0));
                }
                if (this.vMusicChannel == null)
                {
                    this.destroy();
                }
                else
                {
                    if (this.vPause)
                    {
                        this.vPause = false;
                        this.pauseAll();
                        return;
                    }
                    this.vMusicChannel.addEventListener(Event.SOUND_COMPLETE, this.musicIsComplete);
                }
            }
            return;
        }// end function

        private function CheckSFX(event:Event) : void
        {
            var _loc_3:* = null;
            var _loc_5:* = NaN;
            if (this.vSFXTab.length == 0)
            {
                removeEventListener(Event.ENTER_FRAME, this.CheckSFX);
                this.vEnterFrameSFX = false;
                return;
            }
            if (this.vPause)
            {
                return;
            }
            var _loc_2:* = 0;
            var _loc_4:* = getTimer();
            while (_loc_2 < this.vSFXTab.length)
            {
                
                if (_loc_4 >= this.vSFXTab[_loc_2].sndEndTimer || this.vSFXTab[_loc_2].sndChn.position >= this.vSFXTab[_loc_2].vSound.length)
                {
                    var _loc_6:* = this.vSFXTab[_loc_2];
                    var _loc_7:* = _loc_6.vLoop - 1;
                    _loc_6.vLoop = _loc_7;
                    if (_loc_6.vLoop > 0)
                    {
                        _loc_6.sndChn = null;
                        _loc_5 = _loc_6.sndVolume * this.vSFXVolume / 100;
                        if (this.vGlobalVolume)
                        {
                            _loc_6.sndChn = _loc_6.vSound.play(0, 1, new SoundTransform(_loc_5, 0));
                        }
                        else
                        {
                            _loc_6.sndChn = _loc_6.vSound.play(0, 1, new SoundTransform(0, 0));
                        }
                        if (_loc_6.sndChn == null)
                        {
                            if (_loc_6.vFun)
                            {
                                _loc_3 = _loc_6.vFun;
                                _loc_6.vFun = null;
                                this._loc_3();
                            }
                            this.clearSFX(_loc_2);
                            this.vSFXTab.splice(_loc_2, 1);
                        }
                        else
                        {
                            if (_loc_6.vLoop == 1)
                            {
                                _loc_6.sndEndTimer = getTimer() + _loc_6.vSound.length + _loc_6.vPostWait * 1000;
                            }
                            else
                            {
                                _loc_6.sndEndTimer = getTimer() + _loc_6.vSound.length;
                            }
                            _loc_2++;
                        }
                    }
                    else
                    {
                        if (_loc_6.vFun)
                        {
                            _loc_3 = _loc_6.vFun;
                            _loc_6.vFun = null;
                            this._loc_3();
                        }
                        this.clearSFX(_loc_2);
                        this.vSFXTab.splice(_loc_2, 1);
                    }
                    continue;
                }
                _loc_2++;
            }
            return;
        }// end function

        private function clearSFX(param1:uint) : void
        {
            if (this.vSFXTab[param1] == null)
            {
                return;
            }
            this.vSFXTab[param1].sndChn.stop();
            this.vSFXTab[param1] = null;
            return;
        }// end function

        final public function killSFX(param1:Object) : void
        {
            var _loc_2:* = 0;
            _loc_2 = 0;
            while (_loc_2 < this.vSFXTab.length)
            {
                
                if (param1 == this.vSFXTab[_loc_2])
                {
                    this.clearSFX(_loc_2);
                    this.vSFXTab.splice(_loc_2, 1);
                    break;
                }
                _loc_2++;
            }
            return;
        }// end function

        private function timerCheck(event:TimerEvent) : void
        {
            var _loc_2:* = NaN;
            if (this.vMusicChannel.position >= this.vMusicEnd)
            {
                this.vMusicChannel.stop();
                if (this.vMusicLoop <= 0)
                {
                    if (this.vFade)
                    {
                        this.playMusic(null);
                    }
                    else
                    {
                        this.musicStop();
                    }
                }
                else
                {
                    if (this.vGlobalVolume)
                    {
                        _loc_2 = this.vVolume * this.vMusicVolume / 100;
                        if (this.vMusic)
                        {
                            this.vMusicChannel = this.vMusic.play(this.vMusicStart, 1, new SoundTransform(_loc_2, 0));
                        }
                        else if (this.vNextMusic)
                        {
                            this.vMusicChannel = this.vNextMusic.play(this.vMusicStart, 1, new SoundTransform(_loc_2, 0));
                        }
                        else
                        {
                            this.vMusicTimer.stop();
                        }
                    }
                    else if (this.vMusic)
                    {
                        this.vMusicChannel = this.vMusic.play(this.vMusicStart, 1, new SoundTransform(0, 0));
                    }
                    else if (this.vNextMusic)
                    {
                        this.vMusicChannel = this.vNextMusic.play(this.vMusicStart, 1, new SoundTransform(0, 0));
                    }
                    else
                    {
                        this.vMusicTimer.stop();
                    }
                    if ((this.vMusic || this.vNextMusic) && this.vMusicChannel == null)
                    {
                        this.destroy();
                        return;
                    }
                    var _loc_3:* = this;
                    var _loc_4:* = this.vMusicLoop - 1;
                    _loc_3.vMusicLoop = _loc_4;
                }
                return;
            }
            return;
        }// end function

        private function endOfSound(event:Event) : void
        {
            var _loc_2:* = NaN;
            this.vMusicChannel.stop();
            if (this.vMusicChannel)
            {
                this.vMusicChannel.removeEventListener(Event.SOUND_COMPLETE, this.endOfSound);
            }
            if (this.vMusicLoop <= 0)
            {
                if (this.vFade)
                {
                    this.playMusic(null);
                }
                else
                {
                    this.musicStop();
                }
            }
            else
            {
                if (this.vGlobalVolume)
                {
                    _loc_2 = this.vVolume * this.vMusicVolume / 100;
                    if (this.vMusic)
                    {
                        this.vMusicChannel = this.vMusic.play(this.vMusicStart, 1, new SoundTransform(_loc_2, 0));
                        if (this.vMusicEnd >= this.vMusic.length)
                        {
                            this.vMusicChannel.addEventListener(Event.SOUND_COMPLETE, this.endOfSound);
                        }
                    }
                    else if (this.vNextMusic)
                    {
                        this.vMusicChannel = this.vNextMusic.play(this.vMusicStart, 1, new SoundTransform(_loc_2, 0));
                        if (this.vMusicEnd >= this.vMusic.length)
                        {
                            this.vMusicChannel.addEventListener(Event.SOUND_COMPLETE, this.endOfSound);
                        }
                    }
                    else
                    {
                        this.vMusicTimer.stop();
                    }
                    if ((this.vMusic || this.vNextMusic) && this.vMusicChannel == null)
                    {
                        this.destroy();
                        return;
                    }
                }
                else
                {
                    if (this.vMusic)
                    {
                        this.vMusicChannel = this.vMusic.play(this.vMusicStart, 1, new SoundTransform(0, 0));
                        if (this.vMusicEnd >= this.vMusic.length)
                        {
                            this.vMusicChannel.addEventListener(Event.SOUND_COMPLETE, this.endOfSound);
                        }
                    }
                    else if (this.vNextMusic)
                    {
                        this.vMusicChannel = this.vNextMusic.play(this.vMusicStart, 1, new SoundTransform(0, 0));
                        if (this.vMusicEnd >= this.vMusic.length)
                        {
                            this.vMusicChannel.addEventListener(Event.SOUND_COMPLETE, this.endOfSound);
                        }
                    }
                    else
                    {
                        this.vMusicTimer.stop();
                    }
                    if ((this.vMusic || this.vNextMusic) && this.vMusicChannel == null)
                    {
                        this.destroy();
                        return;
                    }
                }
                var _loc_3:* = this;
                var _loc_4:* = this.vMusicLoop - 1;
                _loc_3.vMusicLoop = _loc_4;
            }
            return;
        }// end function

        private function fadeOutMusic(event:Event) : void
        {
            if (!this.vMusicIsPlaying || this.vPause)
            {
                return;
            }
            this.vVolume = this.vVolume - this.vFadeSpeed;
            if (this.vVolume < 0)
            {
                this.vVolume = 0;
            }
            if (this.vGlobalVolume)
            {
                this.vMusicTransform.volume = this.vVolume;
                if (this.vMusicChannel != null)
                {
                    this.vMusicChannel.soundTransform = this.vMusicTransform;
                }
            }
            if (this.vVolume == 0)
            {
                if (this.vMusicStart < 0 && this.vMusicEnd < 0)
                {
                    if (this.vMusicTimer)
                    {
                        this.vMusicTimer.stop();
                        this.vMusicTimer.removeEventListener(TimerEvent.TIMER, this.timerCheck);
                        this.vMusicTimer = null;
                    }
                }
                this.vMusicChannel.stop();
                this.vMusic = null;
                if (this.vNextMusic != null)
                {
                    this.vMusicChannel = this.vNextMusic.play(0, int.MAX_VALUE, new SoundTransform(0, 0));
                    if (this.vMusicChannel == null)
                    {
                        this.destroy();
                        return;
                    }
                    addEventListener(Event.ENTER_FRAME, this.fadeInMusic);
                }
                else
                {
                    this.vMusicIsPlaying = false;
                }
                removeEventListener(Event.ENTER_FRAME, this.fadeOutMusic);
            }
            return;
        }// end function

        private function musicStop() : void
        {
            this.vVolume = 0;
            this.vNextVolume = 0;
            if (this.vMusicTimer)
            {
                this.vMusicTimer.stop();
                this.vMusicTimer.removeEventListener(TimerEvent.TIMER, this.timerCheck);
                this.vMusicTimer = null;
            }
            if (this.vMusicChannel)
            {
                this.vMusicChannel.removeEventListener(Event.SOUND_COMPLETE, this.musicIsComplete);
                this.vMusicChannel.removeEventListener(Event.SOUND_COMPLETE, this.endOfSound);
                this.vMusicChannel.stop();
                this.vMusicChannel = null;
            }
            this.vMusic = null;
            this.vNextMusic = null;
            this.vMusicIsPlaying = false;
            removeEventListener(Event.ENTER_FRAME, this.fadeOutMusic);
            removeEventListener(Event.ENTER_FRAME, this.fadeInMusic);
            return;
        }// end function

        private function fadeInMusic(event:Event) : void
        {
            if (!this.vMusicIsPlaying || this.vPause)
            {
                return;
            }
            this.vVolume = this.vVolume + this.vFadeSpeed;
            if (this.vVolume >= this.vNextVolume)
            {
                this.vVolume = this.vNextVolume;
            }
            if (this.vGlobalVolume)
            {
                this.vMusicTransform.volume = this.vVolume;
                if (this.vMusicChannel != null)
                {
                    this.vMusicChannel.soundTransform = this.vMusicTransform;
                }
            }
            if (this.vVolume == this.vNextVolume)
            {
                removeEventListener(Event.ENTER_FRAME, this.fadeInMusic);
            }
            return;
        }// end function

        final public function destroy() : void
        {
            var _loc_1:* = 0;
            this.vGlobalVolume = true;
            this.vPause = false;
            if (this.vSFXTab.length > 0)
            {
                _loc_1 = 0;
                while (_loc_1 < this.vSFXTab.length)
                {
                    
                    this.clearSFX(_loc_1);
                    _loc_1++;
                }
            }
            this.vSFXTab = new Array();
            removeEventListener(Event.ENTER_FRAME, this.CheckSFX);
            this.vEnterFrameSFX = false;
            this.vMusicIsPlaying = false;
            removeEventListener(Event.ENTER_FRAME, this.fadeInMusic);
            removeEventListener(Event.ENTER_FRAME, this.fadeOutMusic);
            if (this.vMusicTimer)
            {
                this.vMusicTimer.stop();
                this.vMusicTimer.removeEventListener(TimerEvent.TIMER, this.timerCheck);
                this.vMusicTimer = null;
            }
            if (this.vMusicChannel)
            {
                this.vMusicChannel.removeEventListener(Event.SOUND_COMPLETE, this.endOfSound);
                this.vMusicChannel.stop();
                this.vMusicChannel = null;
            }
            this.vMusic = null;
            this.vMusicTmp = null;
            this.vNextMusic = null;
            this.vMusicID = null;
            if (this.vSFXTmp != null)
            {
                this.vSFXTmp.removeEventListener(Event.COMPLETE, this.loadSFXComplete);
                this.vSFXTmp.removeEventListener(IOErrorEvent.IO_ERROR, this.handleSFXIOError);
                try
                {
                    this.vSFXTmp.close();
                }
                catch (err:Error)
                {
                }
                this.vSFXTmp = null;
                this.vSFXVolumeTmp = 0;
                this.vSFXFunTmp = null;
                this.vSFXPostWait = 0;
                this.vSFXLoop = 0;
            }
            this.vSFXQueueList = new Vector.<Object>;
            return;
        }// end function

        public static function getInstance() : SoundManager
        {
            if (current == null)
            {
                current = new SoundManager;
            }
            return current;
        }// end function

    }
}
