package globz
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    dynamic public class bitmapClip extends Sprite
    {
        private var vTrace:Boolean = false;
        public var vBitmap:Bitmap;
        private var vIndex:Number;
        private var vStartIndex:int;
        private var vEndIndex:int;
        private var vIndexType:String;
        private var vAutoPlay:String;
        private var vLoop:Boolean;
        private var vPivotX:Number;
        private var vPivotY:Number;
        private var vAutoClean:Boolean;
        public var vSmoothing:Boolean = true;
        private var vFun:Function;
        private var vFunParams:Array;
        private var vPause:Boolean;
        private var vReady:Boolean;
        private var vBitmapObject:mcToBitmapAS3;
        public var vPuppet:Boolean;
        private var vPuppetObject:puppetObject;
        private var vPuppetRoot:bitmapClip;
        public var totalFrames:int;
        public var vName:String;
        public var vBitmapClipList:Vector.<bitmapClip>;
        private var vNBTimes:int;
        private var vAnimTab:Array;
        private var vWaitMin:Number;
        private var vWaitMax:Number;
        private var vTimer:Timer;
        public var vChangeIndex:Boolean;
        public var vCurrentAnim:String;
        public var vCurrentIndex:int = -1;
        private var vTimerDT:int;
        private var vFPS:Number;
        private var vFPSCoefElastic:Number;
        private var vFPSCoef:Number;

        public function bitmapClip(param1:mcToBitmapAS3 = null, param2:String = "stop", param3:Boolean = true, param4:puppetObject = null) : void
        {
            if (!param1)
            {
                trace("Attention bitmapClip vide!");
                return;
            }
            this.vReady = false;
            this.vBitmapObject = param1;
            this.vPuppet = param1.vPuppet;
            this.vAutoPlay = param2;
            this.vAutoClean = param3;
            if (this.vAutoClean)
            {
                this.addEventListener(Event.REMOVED_FROM_STAGE, this.destroy);
            }
            this.vLoop = false;
            this.vPivotX = 0;
            this.vPivotY = 0;
            this.vSmoothing = this.vBitmapObject.vSmoothing;
            this.doubleClickEnabled = false;
            this.tabEnabled = false;
            this.mouseEnabled = false;
            this.mouseChildren = false;
            this.vIndex = 0;
            this.vPause = false;
            this.vNBTimes = 0;
            this.vChangeIndex = false;
            if (this.vPuppet)
            {
                if (this.vBitmapObject && this.vBitmapObject.vConversion)
                {
                    if (param4)
                    {
                        this.vPuppetObject = param4;
                        if (this.vIndex == -1)
                        {
                            this.vIndex = 0;
                        }
                    }
                    else
                    {
                        if (this.vIndex == -1)
                        {
                            this.vIndex = 0;
                        }
                        this.vPuppetObject = this.vBitmapObject.vPuppetObject;
                        this.vPuppetRoot = this;
                        this.vBitmapClipList = new Vector.<bitmapClip>(this.vPuppetObject.vIDTotal);
                        this.makePuppet(this.vPuppetObject, this, this.vPuppetRoot);
                        this.totalFrames = this.vPuppetObject.vNBFrames;
                    }
                }
                else
                {
                    this.checkPuppetObject();
                    if (!this.vReady)
                    {
                        this.addEventListener(Event.ENTER_FRAME, this.checkPuppetObject);
                    }
                }
                this.x = 0;
                this.y = 0;
            }
            else
            {
                this.x = this.vBitmapObject.vVectoX;
                this.y = this.vBitmapObject.vVectoY;
                this.vBitmap = new Bitmap(null, "auto", true);
                this.checkBitmapObject();
                if (!this.vReady)
                {
                    this.addEventListener(Event.ENTER_FRAME, this.checkBitmapObject);
                }
            }
            this.vFPS = -1;
            this.vTimerDT = 0;
            this.vFPSCoefElastic = 0;
            this.vFPSCoef = 1;
            return;
        }// end function

        public function setFPS(param1:Number = 25) : void
        {
            this.vFPS = param1;
            return;
        }// end function

        final public function changePivotXY(param1:Number = 0, param2:Number = 0) : void
        {
            this.vPivotX = param1;
            this.vPivotY = param2;
            this.updateBitmap();
            return;
        }// end function

        final public function pause() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            if (!this.vPause)
            {
                if (this.vTimer)
                {
                    this.vTimer.stop();
                }
                this.vPause = true;
                if (this.vLoop)
                {
                    this.removeEventListener(Event.ENTER_FRAME, this.loop);
                }
                if (this.vPuppet)
                {
                    _loc_3 = 0;
                    while (_loc_3 < this.vPuppetObject.vPuppetList.length)
                    {
                        
                        _loc_2 = this.vPuppetObject.vPuppetList[_loc_3].vID;
                        _loc_1 = this.vPuppetRoot.vBitmapClipList[_loc_2];
                        if (_loc_1)
                        {
                            _loc_1.pause();
                        }
                        _loc_3++;
                    }
                }
            }
            return;
        }// end function

        final public function resume() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            if (this.vPause)
            {
                if (this.vTimer)
                {
                    this.vTimer.start();
                }
                this.vPause = false;
                if (this.vLoop)
                {
                    this.addEventListener(Event.ENTER_FRAME, this.loop);
                }
                if (this.vPuppet)
                {
                    _loc_3 = 0;
                    while (_loc_3 < this.vPuppetObject.vPuppetList.length)
                    {
                        
                        _loc_2 = this.vPuppetObject.vPuppetList[_loc_3].vID;
                        _loc_1 = this.vPuppetRoot.vBitmapClipList[_loc_2];
                        if (_loc_1)
                        {
                            _loc_1.resume();
                        }
                        _loc_3++;
                    }
                }
            }
            return;
        }// end function

        final private function makePuppet(param1:Object, param2:bitmapClip = null, param3:bitmapClip = null) : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = null;
            var _loc_8:* = null;
            this.vPuppetRoot = param3;
            var _loc_7:* = param1.vPuppetList.length;
            _loc_4 = 0;
            while (_loc_4 < _loc_7)
            {
                
                _loc_8 = param1.vPuppetList[_loc_4];
                if (_loc_8.vMatrixTab[0] != null)
                {
                    if (_loc_8.vBitmap)
                    {
                        _loc_5 = _loc_8.vBitmapIndex;
                        _loc_6 = new bitmapClip(this.vBitmapObject.vBitmapAS3Tab[_loc_5], this.vAutoPlay, false);
                    }
                    else
                    {
                        _loc_6 = new bitmapClip(this.vBitmapObject, this.vAutoPlay, false, _loc_8);
                        this.makePuppet(_loc_8, _loc_6, this.vPuppetRoot);
                    }
                    _loc_6.vPuppetRoot = this.vPuppetRoot;
                    this.vPuppetRoot.vBitmapClipList[_loc_8.vID] = _loc_6;
                    param2[_loc_8.vName] = _loc_6;
                    _loc_6.totalFrames = _loc_8.vNBFrames;
                    _loc_6.name = _loc_8.vName;
                    _loc_6.transform.matrix = _loc_8.vMatrixTab[0];
                    _loc_6.alpha = _loc_8.vAlphaTab[0];
                    param2.addChild(_loc_6);
                }
                _loc_4++;
            }
            return;
        }// end function

        final private function checkBitmapObject(event:Event = null) : void
        {
            var _loc_2:* = null;
            if (!this.vReady && this.vBitmapObject && this.vBitmapObject.vConversion)
            {
                this.removeEventListener(Event.ENTER_FRAME, this.checkBitmapObject);
                this.vReady = true;
                if (this.vIndex == -1)
                {
                    this.vIndex = 0;
                }
                this.updateBitmap();
                this.addChild(this.vBitmap);
                _loc_2 = this.vAutoPlay.split(",");
                if (_loc_2.length == 3)
                {
                    this.gotoAndPlay(this.vAutoPlay);
                }
                else if (this.vAutoPlay == "play")
                {
                    this.play();
                }
            }
            return;
        }// end function

        final private function checkPuppetObject(event:Event = null) : void
        {
            if (!this.vBitmapObject.vPuppet)
            {
                this.removeEventListener(Event.ENTER_FRAME, this.checkPuppetObject);
                this.vReady = false;
                this.vPuppet = false;
                this.vBitmap = new Bitmap(null, "auto", true);
                this.checkBitmapObject();
                if (!this.vReady)
                {
                    this.addEventListener(Event.ENTER_FRAME, this.checkBitmapObject);
                }
                return;
            }
            if (!this.vReady && this.vBitmapObject && this.vBitmapObject.vConversion)
            {
                this.removeEventListener(Event.ENTER_FRAME, this.checkPuppetObject);
                this.vReady = true;
                if (this.vIndex == -1)
                {
                    this.vIndex = 0;
                }
                this.vPuppetObject = this.vBitmapObject.vPuppetObject;
                this.vPuppetRoot = this;
                this.vBitmapClipList = new Vector.<bitmapClip>(this.vPuppetObject.vIDTotal);
                this.makePuppet(this.vPuppetObject, this, this.vPuppetRoot);
                this.totalFrames = this.vPuppetObject.vNBFrames;
            }
            return;
        }// end function

        final public function gotoAndStop(param1:Object) : void
        {
            var _loc_2:* = null;
            this.vFun = null;
            this.vFunParams = null;
            if (this.vTimer)
            {
                this.deleteTimer();
            }
            if (this.vLoop)
            {
                this.vLoop = false;
                this.removeEventListener(Event.ENTER_FRAME, this.loop);
            }
            if (this.vPuppet && this.vPuppetObject != null)
            {
                if (this.vCurrentAnim != param1)
                {
                    this.vPuppetObject.vAnimsOnceListTemp = this.vPuppetObject.vAnimsOnceList.concat();
                }
                if (param1 is String)
                {
                    if (!isNaN(Number(param1)))
                    {
                        this.vIndex = Number(param1) - 1;
                    }
                    else
                    {
                        _loc_2 = param1.split(",");
                        if (this.vPuppetObject.vLabelsDictionary && this.vPuppetObject.vLabelsDictionary[_loc_2[0]] != undefined)
                        {
                            this.vIndex = this.vPuppetObject.vLabelsDictionary[_loc_2[0]];
                        }
                        else
                        {
                            if (this.vTrace)
                            {
                                if (this.vPuppetObject.vName)
                                {
                                    trace("label \'" + _loc_2[0] + "\' does not exist in " + this.vPuppetObject.vName);
                                }
                                else
                                {
                                    trace("label " + _loc_2[0] + "\' does not exist in " + this.name);
                                }
                            }
                            return;
                        }
                    }
                }
                else if (param1 is int)
                {
                    this.vIndex = int(param1) - 1;
                }
                if (this.vIndex < 0)
                {
                    this.vIndex = 0;
                }
                else if (this.vIndex >= this.vPuppetObject.vNBFrames)
                {
                    this.vIndex = this.vPuppetObject.vNBFrames - 1;
                }
                this.updateBitmapClips();
            }
            else
            {
                if (!this.vBitmapObject || this.vBitmapObject.vBDTab == null)
                {
                    return;
                }
                if (param1 is String)
                {
                    if (!isNaN(Number(param1)))
                    {
                        this.vIndex = Number(param1) - 1;
                    }
                    else
                    {
                        _loc_2 = param1.split(",");
                        if (this.vBitmapObject.vLabelsDictionary && this.vBitmapObject.vLabelsDictionary[_loc_2[0]] != undefined)
                        {
                            this.vIndex = this.vBitmapObject.vLabelsDictionary[_loc_2[0]];
                        }
                        else
                        {
                            if (this.vTrace)
                            {
                                trace("label \'" + _loc_2[0] + "\' does not exist in " + this.name);
                            }
                            return;
                        }
                    }
                }
                else if (param1 is int)
                {
                    this.vIndex = int(param1) - 1;
                }
                if (this.vIndex < 0)
                {
                    this.vIndex = 0;
                }
                else if (this.vIndex >= this.vBitmapObject.vOrderTab.length)
                {
                    this.vIndex = this.vBitmapObject.vOrderTab.length - 1;
                }
                this.updateBitmap();
            }
            this.vEndIndex = this.vIndex;
            this.vIndexType = "stop";
            this.vCurrentAnim = param1 as String;
            return;
        }// end function

        final private function gotoAnims(param1:String) : void
        {
            var i:int;
            var j:int;
            var lBitmapClip:bitmapClip;
            var lTab:Array;
            var lTab2:Array;
            var lAction:String;
            var lString:String;
            var lRandomAnims:String;
            var lNBTimes:String;
            var lTimeMin:Number;
            var lTimeMax:Number;
            var lParams:Array;
            var lFrame:String;
            var pAnims:* = param1;
            if (pAnims)
            {
                lTab = pAnims.split(";");
                i;
                while (i < lTab.length)
                {
                    
                    if (lTab[i])
                    {
                        lBitmapClip = bitmapClip(this);
                        lTab2 = lTab[i].slice(0, lTab[i].indexOf("(")).split(".");
                        lAction = lTab2[(lTab2.length - 1)].toLowerCase();
                        lTab2[(lTab2.length - 1)] = lTab[i].slice((lTab[i].indexOf("(") + 1), lTab[i].indexOf(")"));
                        if (lTab2.length > 1)
                        {
                            if (this.vPuppetObject)
                            {
                                try
                                {
                                    j;
                                    while (j < (lTab2.length - 1))
                                    {
                                        
                                        lBitmapClip = bitmapClip(lBitmapClip[lTab2[j]]);
                                        j = (j + 1);
                                    }
                                }
                                catch (e:Error)
                                {
                                    break;
                                }
                            }
                            else
                            {
                                break;
                            }
                        }
                        lString = lTab2[(lTab2.length - 1)];
                        if (lAction == "gotoandplayrandom")
                        {
                            lRandomAnims = lString.slice((lString.indexOf("[") + 1), lString.indexOf("]"));
                            lRandomAnims = lRandomAnims.split("\",\"").join("\".\"");
                            lRandomAnims = lRandomAnims.split("\"").join("");
                            lNBTimes;
                            lTimeMin;
                            lTimeMax;
                            lString = lString.slice((lString.indexOf("]") + 1));
                            if (lString.length > 0)
                            {
                                lParams = lString.split(",");
                                lParams.shift();
                                if (lParams[0])
                                {
                                    lNBTimes = lParams[0].split("\"").join("");
                                }
                                if (lParams[1])
                                {
                                    lTimeMin = Number(lParams[1]);
                                }
                                if (lParams[2])
                                {
                                    lTimeMax = Number(lParams[2]);
                                }
                            }
                            lBitmapClip.gotoAndPlayRandom(lRandomAnims.split("."), lNBTimes, lTimeMin, lTimeMax);
                        }
                        else
                        {
                            lFrame = lString.split("\"").join("");
                            switch(lAction)
                            {
                                case "stop":
                                default:
                                {
                                    lBitmapClip.stop();
                                    break;
                                }
                                case "gotoandstop":
                                {
                                    lBitmapClip.play();
                                    break;
                                }
                                case "gotoandplay":
                                {
                                    lBitmapClip.gotoAndStop(lFrame);
                                    break;
                                }
                                case "prevframe":
                                {
                                    lBitmapClip.gotoAndPlay(lFrame);
                                    break;
                                }
                                case "nextframe":
                                {
                                    lBitmapClip.prevFrame();
                                    break;
                                }
                                case :
                                {
                                    lBitmapClip.nextFrame();
                                    break;
                                    break;
                                }
                            }
                        }
                    }
                    i = (i + 1);
                }
            }
            return;
        }// end function

        final public function gotoAndPlay(param1:Object, param2:Function = null, param3 = null) : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = null;
            if (this.vTimer)
            {
                this.deleteTimer();
            }
            if (this.stage && this.vFPS == -1)
            {
                this.vFPS = this.stage.frameRate;
            }
            this.vTimerDT = getTimer();
            this.vFun = param2;
            if (param3 != null)
            {
                this.vFunParams = new Array();
                if (param3 is Array)
                {
                    _loc_4 = 0;
                    while (_loc_4 < param3.length)
                    {
                        
                        this.vFunParams[_loc_4] = param3[_loc_4];
                        _loc_4++;
                    }
                }
                else
                {
                    this.vFunParams[0] = param3;
                }
            }
            else
            {
                this.vFunParams = null;
            }
            if (this.vLoop)
            {
                this.vLoop = false;
                this.removeEventListener(Event.ENTER_FRAME, this.loop);
            }
            if (this.vPuppet && this.vPuppetObject != null)
            {
                if (this.vCurrentAnim != param1)
                {
                    this.vPuppetObject.vAnimsOnceListTemp = this.vPuppetObject.vAnimsOnceList.concat();
                }
                if (this.vPuppetObject.vNBFrames <= 1)
                {
                    if (this.vLoop)
                    {
                        this.vLoop = false;
                        this.removeEventListener(Event.ENTER_FRAME, this.loop);
                    }
                    return;
                }
                if (param1 is String)
                {
                    _loc_5 = param1.split(",");
                    if (_loc_5.length > 1)
                    {
                        if (!isNaN(Number(_loc_5[0])))
                        {
                            Number(_loc_5[0]) = (Number(_loc_5[0]) - 1);
                            this.vStartIndex = Number(_loc_5[0]) - 1;
                            this.vIndex = Number(_loc_5[0]) - 1;
                        }
                        else if (this.vPuppetObject.vLabelsDictionary[_loc_5[0]] != undefined)
                        {
                            var _loc_6:* = this.vPuppetObject.vLabelsDictionary[_loc_5[0]];
                            this.vStartIndex = this.vPuppetObject.vLabelsDictionary[_loc_5[0]];
                            this.vIndex = _loc_6;
                        }
                        else
                        {
                            if (this.vTrace)
                            {
                                if (this.vPuppetObject.vName)
                                {
                                    trace("label \'" + _loc_5[0] + "\' does not exist in " + this.vPuppetObject.vName);
                                }
                                else
                                {
                                    trace("label \'" + _loc_5[0] + "\' does not exist in " + this.name);
                                }
                            }
                            return;
                        }
                        if (!isNaN(Number(_loc_5[1])))
                        {
                            this.vEndIndex = Number(_loc_5[1]) - 1;
                        }
                        else if (this.vPuppetObject.vLabelsDictionary[_loc_5[1]] != undefined)
                        {
                            this.vEndIndex = this.vPuppetObject.vLabelsDictionary[_loc_5[1]];
                        }
                        else
                        {
                            if (this.vTrace)
                            {
                                if (this.vPuppetObject.vName)
                                {
                                    trace("label \'" + _loc_5[1] + "\' does not exist in " + this.vPuppetObject.vName);
                                }
                                else
                                {
                                    trace("label \'" + _loc_5[1] + "\' does not exist in " + this.name);
                                }
                            }
                            return;
                        }
                        if (_loc_5.length >= 3)
                        {
                            this.vIndexType = _loc_5[2];
                        }
                        else
                        {
                            this.vIndexType = "stop";
                        }
                        if (_loc_5.length == 4)
                        {
                            this.vFPS = Number(_loc_5[3]);
                        }
                        if (this.vIndexType == "loop")
                        {
                            var _loc_6:* = this;
                            var _loc_7:* = this.vEndIndex - 1;
                            _loc_6.vEndIndex = _loc_7;
                        }
                    }
                    else if (this.vPuppetObject.vLabelsDictionary[_loc_5[0]] != undefined)
                    {
                        this.vIndex = this.vPuppetObject.vLabelsDictionary[_loc_5[0]];
                        this.vStartIndex = 0;
                        this.vEndIndex = this.vPuppetObject.vNBFrames - 1;
                        this.vIndexType = "loop";
                    }
                    else
                    {
                        if (this.vTrace)
                        {
                            if (this.vPuppetObject.vName)
                            {
                                trace("label \'" + _loc_5[0] + "\' does not exist in " + this.vPuppetObject.vName);
                            }
                            else
                            {
                                trace("label \'" + _loc_5[0] + "\' does not exist in " + this.name);
                            }
                        }
                        return;
                    }
                }
                else if (param1 is int)
                {
                    this.vIndex = int(param1) - 1;
                    this.vStartIndex = 0;
                    this.vEndIndex = this.vPuppetObject.vNBFrames - 1;
                    this.vIndexType = "loop";
                }
                if (this.vIndex < 0)
                {
                    var _loc_6:* = 0;
                    this.vStartIndex = 0;
                    this.vIndex = _loc_6;
                }
                else if (this.vIndex >= this.vPuppetObject.vNBFrames)
                {
                    this.vPuppetObject.vNBFrames = (this.vPuppetObject.vNBFrames - 1);
                    this.vStartIndex = this.vPuppetObject.vNBFrames - 1;
                    this.vIndex = this.vPuppetObject.vNBFrames - 1;
                }
                this.updateBitmapClips();
            }
            else
            {
                if (!this.vBitmapObject || this.vBitmapObject.vBDTab == null)
                {
                    return;
                }
                if (this.vBitmapObject.vOrderTab.length <= 1)
                {
                    if (this.vLoop)
                    {
                        this.vLoop = false;
                        this.removeEventListener(Event.ENTER_FRAME, this.loop);
                    }
                    return;
                }
                if (param1 is String)
                {
                    _loc_5 = param1.split(",");
                    if (_loc_5.length > 1)
                    {
                        if (!isNaN(Number(_loc_5[0])))
                        {
                            Number(_loc_5[0]) = (Number(_loc_5[0]) - 1);
                            this.vStartIndex = Number(_loc_5[0]) - 1;
                            this.vIndex = Number(_loc_5[0]) - 1;
                        }
                        else if (this.vBitmapObject.vLabelsDictionary[_loc_5[0]] != undefined)
                        {
                            var _loc_6:* = this.vBitmapObject.vLabelsDictionary[_loc_5[0]];
                            this.vStartIndex = this.vBitmapObject.vLabelsDictionary[_loc_5[0]];
                            this.vIndex = _loc_6;
                        }
                        else
                        {
                            if (this.vTrace)
                            {
                                trace("label \'" + _loc_5[0] + "\' does not exist in " + this.name);
                            }
                            return;
                        }
                        if (!isNaN(Number(_loc_5[1])))
                        {
                            this.vEndIndex = Number(_loc_5[1]) - 1;
                        }
                        else if (this.vBitmapObject.vLabelsDictionary[_loc_5[1]] != undefined)
                        {
                            this.vEndIndex = this.vBitmapObject.vLabelsDictionary[_loc_5[1]];
                        }
                        else
                        {
                            if (this.vTrace)
                            {
                                trace("label \'" + _loc_5[1] + "\' does not exist in " + this.name);
                            }
                            return;
                        }
                        if (_loc_5.length >= 3)
                        {
                            this.vIndexType = _loc_5[2];
                        }
                        else
                        {
                            this.vIndexType = "stop";
                        }
                        if (_loc_5.length == 4)
                        {
                            this.vFPS = Number(_loc_5[3]);
                        }
                        if (this.vIndexType == "loop")
                        {
                            var _loc_6:* = this;
                            var _loc_7:* = this.vEndIndex - 1;
                            _loc_6.vEndIndex = _loc_7;
                        }
                    }
                    else if (this.vBitmapObject.vLabelsDictionary[_loc_5[0]] != undefined)
                    {
                        this.vIndex = this.vBitmapObject.vLabelsDictionary[_loc_5[0]];
                        this.vStartIndex = 0;
                        this.vEndIndex = this.vBitmapObject.vOrderTab.length - 1;
                        this.vIndexType = "loop";
                    }
                    else
                    {
                        if (this.vTrace)
                        {
                            trace("label \'" + _loc_5[1] + "\' does not exist in " + this.name);
                        }
                        return;
                    }
                }
                else if (param1 is int)
                {
                    this.vIndex = int(param1) - 1;
                    this.vStartIndex = 0;
                    this.vEndIndex = this.vBitmapObject.vOrderTab.length - 1;
                    this.vIndexType = "loop";
                }
                if (this.vIndex < 0)
                {
                    var _loc_6:* = 0;
                    this.vStartIndex = 0;
                    this.vIndex = _loc_6;
                }
                else if (this.vIndex >= this.vBitmapObject.vOrderTab.length)
                {
                    this.vBitmapObject.vOrderTab.length = (this.vBitmapObject.vOrderTab.length - 1);
                    this.vStartIndex = this.vBitmapObject.vOrderTab.length - 1;
                    this.vIndex = this.vBitmapObject.vOrderTab.length - 1;
                }
                this.updateBitmap();
            }
            if (!this.vLoop)
            {
                this.vLoop = true;
                this.addEventListener(Event.ENTER_FRAME, this.loop);
            }
            this.vCurrentAnim = param1 as String;
            return;
        }// end function

        final public function prevFrame() : void
        {
            this.vFun = null;
            this.vFunParams = null;
            if (this.vLoop)
            {
                this.vLoop = false;
                this.removeEventListener(Event.ENTER_FRAME, this.loop);
            }
            if (this.vTimer)
            {
                this.deleteTimer();
            }
            var _loc_1:* = this;
            var _loc_2:* = this.vIndex - 1;
            _loc_1.vIndex = _loc_2;
            if (this.vIndex < 0)
            {
                this.vIndex = 0;
            }
            if (this.vPuppet)
            {
                this.vPuppetObject.vAnimsOnceListTemp = this.vPuppetObject.vAnimsOnceList.concat();
                this.updateBitmapClips();
            }
            else
            {
                if (!this.vBitmapObject || this.vBitmapObject.vBDTab == null)
                {
                    return;
                }
                this.updateBitmap();
            }
            return;
        }// end function

        final public function nextFrame() : void
        {
            this.vFun = null;
            this.vFunParams = null;
            if (this.vTimer)
            {
                this.deleteTimer();
            }
            if (this.vLoop)
            {
                this.vLoop = false;
                this.removeEventListener(Event.ENTER_FRAME, this.loop);
            }
            if (this.vPuppet && this.vPuppetObject != null)
            {
                this.vPuppetObject.vAnimsOnceListTemp = this.vPuppetObject.vAnimsOnceList.concat();
                var _loc_1:* = this;
                var _loc_2:* = this.vIndex + 1;
                _loc_1.vIndex = _loc_2;
                if (this.vIndex >= this.vPuppetObject.vNBFrames)
                {
                    this.vIndex = this.vPuppetObject.vNBFrames - 1;
                }
                this.updateBitmapClips();
            }
            else
            {
                if (!this.vBitmapObject || this.vBitmapObject.vBDTab == null)
                {
                    return;
                }
                var _loc_1:* = this;
                var _loc_2:* = this.vIndex + 1;
                _loc_1.vIndex = _loc_2;
                if (this.vIndex >= this.vBitmapObject.vOrderTab.length)
                {
                    this.vIndex = this.vBitmapObject.vOrderTab.length - 1;
                }
                this.updateBitmap();
            }
            return;
        }// end function

        final public function stop() : void
        {
            this.vFun = null;
            this.vFunParams = null;
            if (this.vTimer)
            {
                this.deleteTimer();
            }
            if (this.vLoop)
            {
                this.vLoop = false;
                this.removeEventListener(Event.ENTER_FRAME, this.loop);
            }
            return;
        }// end function

        final public function play(param1:int = -1) : void
        {
            if (param1 > -1)
            {
                this.vFPS = param1;
            }
            this.vFun = null;
            this.vFunParams = null;
            if (this.stage && this.vFPS == -1)
            {
                this.vFPS = this.stage.frameRate;
            }
            this.vTimerDT = getTimer();
            if (this.vTimer)
            {
                this.deleteTimer();
            }
            if (this.vLoop)
            {
                this.vLoop = false;
                this.removeEventListener(Event.ENTER_FRAME, this.loop);
            }
            if (this.vPuppet && this.vPuppetObject != null)
            {
                this.vPuppetObject.vAnimsOnceListTemp = this.vPuppetObject.vAnimsOnceList.concat();
                this.vStartIndex = 0;
                this.vEndIndex = this.vPuppetObject.vNBFrames - 1;
                this.vIndexType = "loop";
            }
            else
            {
                if (!this.vBitmapObject || this.vBitmapObject.vBDTab == null)
                {
                    return;
                }
                this.vStartIndex = 0;
                this.vEndIndex = this.vBitmapObject.vOrderTab.length - 1;
                this.vIndexType = "loop";
            }
            if (!this.vLoop)
            {
                this.vLoop = true;
                this.addEventListener(Event.ENTER_FRAME, this.loop);
            }
            return;
        }// end function

        final public function get currentFrame() : int
        {
            return (this.vIndex + 1);
        }// end function

        final public function gotoAndPlayRandom(param1:Array, param2 = "loop", param3:Number = 0, param4:Number = 1) : void
        {
            var _loc_5:* = 0;
            this.vFun = null;
            this.vFunParams = null;
            if (param2 == "loop" || param2 < 0 || isNaN(Number(param2)))
            {
                this.vNBTimes = -1;
            }
            else
            {
                this.vNBTimes = Number(param2);
            }
            this.vAnimTab = param1;
            this.vWaitMin = param3;
            this.vWaitMax = param4;
            if (this.vPuppet)
            {
                this.vPuppetObject.vAnimsOnceListTemp = this.vPuppetObject.vAnimsOnceList.concat();
            }
            this.launchRandomAnim();
            return;
        }// end function

        final private function launchRandomAnim(event:TimerEvent = null) : void
        {
            if (this.vTimer)
            {
                this.deleteTimer();
            }
            var _loc_2:* = int(Math.random() * this.vAnimTab.length);
            this.gotoAndPlay(this.vAnimTab[_loc_2] + ",random", this.setRandomTimer);
            return;
        }// end function

        final private function setRandomTimer() : void
        {
            if (this.vNBTimes > 0)
            {
                var _loc_1:* = this;
                var _loc_2:* = this.vNBTimes - 1;
                _loc_1.vNBTimes = _loc_2;
            }
            if (this.vNBTimes != 0)
            {
                this.vTimer = new Timer(this.vWaitMin * 1000 + int(Math.random() * (this.vWaitMax * 1000)), 1);
                this.vTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.launchRandomAnim);
                this.vTimer.start();
            }
            return;
        }// end function

        final private function deleteTimer() : void
        {
            if (this.vTimer)
            {
                this.vTimer.stop();
                this.vTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.launchRandomAnim);
                this.vTimer = null;
            }
            return;
        }// end function

        final private function loop(event:Event) : void
        {
            var _loc_2:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = null;
            var _loc_8:* = null;
            event.stopPropagation();
            if (this.vBitmapObject.vBDTab == null)
            {
                this.stop();
                return;
            }
            if (this.vPause)
            {
                this.removeEventListener(Event.ENTER_FRAME, this.loop);
                return;
            }
            if (!this.vLoop || this.vPuppet && this.vPuppetObject.vNBFrames <= 1 || !this.vPuppet && !this.vBitmapObject)
            {
                this.vLoop = false;
                this.removeEventListener(Event.ENTER_FRAME, this.loop);
                return;
            }
            var _loc_3:* = 1;
            if (this.vFPS != -1)
            {
                _loc_5 = getTimer();
                _loc_3 = (_loc_5 - this.vTimerDT) * 0.001;
                this.vFPSCoefElastic = (_loc_3 / (1 / this.vFPS) - this.vFPSCoef) * 0.5;
                this.vFPSCoef = this.vFPSCoef + this.vFPSCoefElastic;
                this.vTimerDT = _loc_5;
            }
            else if (this.stage)
            {
                this.vFPS = this.stage.frameRate;
            }
            var _loc_4:* = int((this.vIndex + 1));
            this.vIndex = this.vIndex + this.vFPSCoef;
            if (_loc_4 <= this.vEndIndex)
            {
                _loc_6 = int(this.vIndex);
                if (_loc_6 > this.vEndIndex)
                {
                    _loc_6 = this.vEndIndex;
                }
                _loc_2 = _loc_4;
                while (_loc_2 <= _loc_6)
                {
                    
                    if (this.vPuppet)
                    {
                        if (this.vPuppetObject.vAnimsList && this.vPuppetObject.vAnimsList[_loc_2] || this.vPuppetObject.vAnimsOnceListTemp && this.vPuppetObject.vAnimsOnceListTemp[_loc_2])
                        {
                            this.vIndex = _loc_2;
                            break;
                        }
                    }
                    else if (this.vBitmapObject.vAnimsList && this.vBitmapObject.vAnimsList[_loc_2])
                    {
                        this.vIndex = _loc_2;
                        break;
                    }
                    _loc_2++;
                }
            }
            if (this.vIndex > this.vEndIndex || this.vPuppet && this.vIndex >= this.vPuppetObject.vNBFrames || !this.vPuppet && this.vIndex >= this.vBitmapObject.vOrderTab.length)
            {
                switch(this.vIndexType)
                {
                    case "random":
                    case "stop":
                    default:
                    {
                        this.vIndex = this.vEndIndex;
                        this.vLoop = false;
                        this.removeEventListener(Event.ENTER_FRAME, this.loop);
                        if (this.vFun != null)
                        {
                            _loc_7 = this.vFun;
                            this.vFun = null;
                            if (this.vFunParams == null)
                            {
                                this._loc_7();
                            }
                            else
                            {
                                _loc_8 = this.vFunParams.concat();
                                this.vFunParams = null;
                                _loc_7.apply(null, _loc_8);
                            }
                        }
                        break;
                    }
                    case :
                    {
                        this.vIndex = this.vIndex - (this.vEndIndex - this.vStartIndex);
                        if (this.vIndex > this.vEndIndex || this.vIndex < this.vStartIndex)
                        {
                            this.vIndex = this.vStartIndex;
                        }
                        _loc_2 = this.vStartIndex;
                        while (_loc_2 <= int(this.vIndex))
                        {
                            
                            if (this.vPuppet)
                            {
                                if (this.vPuppetObject.vAnimsList && this.vPuppetObject.vAnimsList[_loc_2] || this.vPuppetObject.vAnimsOnceListTemp && this.vPuppetObject.vAnimsOnceListTemp[_loc_2])
                                {
                                    this.vIndex = _loc_2;
                                    break;
                                }
                            }
                            else if (this.vBitmapObject.vAnimsList && this.vBitmapObject.vAnimsList[_loc_2])
                            {
                                this.vIndex = _loc_2;
                                break;
                            }
                            _loc_2++;
                        }
                        if (this.vFun != null)
                        {
                            _loc_7 = this.vFun;
                            this.vFun = null;
                            if (this.vFunParams == null)
                            {
                                this._loc_7();
                            }
                            else
                            {
                                _loc_8 = this.vFunParams.concat();
                                this.vFunParams = null;
                                _loc_7.apply(null, _loc_8);
                            }
                        }
                        break;
                        break;
                    }
                }
            }
            if (this.vPuppet)
            {
                this.updateBitmapClips();
            }
            else
            {
                this.updateBitmap();
            }
            return;
        }// end function

        final private function updateBitmap() : void
        {
            if (this.vBitmapObject == null || (this.vBitmapObject && this.vBitmapObject.vBDTab) == null)
            {
                this.stop();
                return;
            }
            if (this.vCurrentIndex == int(this.vIndex))
            {
                return;
            }
            this.vCurrentIndex = int(this.vIndex);
            var _loc_1:* = this.vBitmapObject.vBDTab[this.vBitmapObject.vOrderTab[this.vCurrentIndex]];
            this.vBitmap.bitmapData = _loc_1.vBD;
            this.vBitmap.x = _loc_1.vX - this.vPivotX;
            this.vBitmap.y = _loc_1.vY - this.vPivotY;
            this.vBitmap.scaleX = _loc_1.vScaleX;
            this.vBitmap.scaleY = _loc_1.vScaleY;
            this.vBitmap.smoothing = this.vSmoothing;
            if (this.vBitmapObject.vAnimsList && this.vBitmapObject.vAnimsList[this.vCurrentIndex])
            {
                this.gotoAnims(this.vBitmapObject.vAnimsList[this.vCurrentIndex]);
            }
            return;
        }// end function

        final private function updateBitmapClips() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = null;
            var _loc_3:* = null;
            if (this.vCurrentIndex == int(this.vIndex))
            {
                return;
            }
            this.vCurrentIndex = int(this.vIndex);
            var _loc_4:* = this.vPuppetObject.vPuppetList.length;
            var _loc_5:* = this.vPuppetRoot.vBitmapClipList;
            var _loc_6:* = false;
            _loc_1 = 0;
            while (_loc_1 < _loc_4)
            {
                
                _loc_2 = this.vPuppetObject.vPuppetList[_loc_1];
                _loc_3 = _loc_5[_loc_2.vID];
                if (_loc_2.vStayAllFrames)
                {
                    _loc_3.transform.matrix = _loc_2.vMatrixTab[this.vCurrentIndex];
                    _loc_3.alpha = _loc_2.vAlphaTab[this.vCurrentIndex];
                }
                else if (_loc_2.vMatrixTab[this.vCurrentIndex] == null)
                {
                    if (_loc_3 && this.contains(_loc_3))
                    {
                        this.removeChild(_loc_3);
                        _loc_3.stopChildren();
                    }
                }
                else
                {
                    if (_loc_3 == null)
                    {
                        if (_loc_2.vBitmap)
                        {
                            _loc_3 = new bitmapClip(this.vBitmapObject.vBitmapAS3Tab[_loc_2.vBitmapIndex], this.vAutoPlay, false);
                        }
                        else
                        {
                            _loc_3 = new bitmapClip(this.vBitmapObject, this.vAutoPlay, false, _loc_2);
                            this.makePuppet(_loc_2, _loc_3, this.vPuppetRoot);
                        }
                        _loc_3.vPuppetRoot = this.vPuppetRoot;
                        _loc_5[_loc_2.vID] = _loc_3;
                        this[_loc_2.vName] = _loc_3;
                        _loc_3.totalFrames = _loc_2.vNBFrames;
                        _loc_3.name = _loc_2.vName;
                    }
                    _loc_3.transform.matrix = _loc_2.vMatrixTab[this.vCurrentIndex];
                    _loc_3.alpha = _loc_2.vAlphaTab[this.vCurrentIndex];
                    if (!this.contains(_loc_3))
                    {
                        this.addChild(_loc_3);
                        _loc_3.vChangeIndex = true;
                        _loc_6 = true;
                    }
                }
                _loc_1++;
            }
            if (_loc_6)
            {
                _loc_1 = 0;
                while (_loc_1 < _loc_4)
                {
                    
                    _loc_2 = this.vPuppetObject.vPuppetList[_loc_1];
                    _loc_3 = _loc_5[_loc_2.vID];
                    if (_loc_3 && _loc_3.vChangeIndex)
                    {
                        _loc_3.vChangeIndex = false;
                        this.setChildIndex(_loc_3, _loc_2.vIndexTab[this.vCurrentIndex]);
                    }
                    _loc_1++;
                }
            }
            if (this.vPuppetObject.vAnimsList[this.vCurrentIndex])
            {
                this.gotoAnims(this.vPuppetObject.vAnimsList[this.vCurrentIndex]);
            }
            if (this.vPuppetObject.vAnimsOnceListTemp[this.vCurrentIndex])
            {
                this.gotoAnims(this.vPuppetObject.vAnimsOnceListTemp[this.vCurrentIndex]);
                this.vPuppetObject.vAnimsOnceListTemp[this.vCurrentIndex] = null;
            }
            return;
        }// end function

        final public function stopChildren() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            this.stop();
            if (this.vPuppetObject && this.vPuppetObject.vPuppetList)
            {
                while (_loc_2 < this.vPuppetObject.vPuppetList.length)
                {
                    
                    _loc_3 = this.vPuppetObject.vPuppetList[_loc_2].vID;
                    _loc_1 = this.vPuppetRoot.vBitmapClipList[_loc_3];
                    if (_loc_1)
                    {
                        _loc_1.stopChildren();
                    }
                    _loc_2++;
                }
            }
            return;
        }// end function

        final public function destroy(event:Event = null) : void
        {
            var e:* = event;
            if (this.vTrace)
            {
                trace("bitmapclip removed from stage");
            }
            this.vLoop = false;
            this.removeEventListener(Event.ENTER_FRAME, this.loop);
            this.removeEventListener(Event.ENTER_FRAME, this.checkBitmapObject);
            this.removeEventListener(Event.ENTER_FRAME, this.checkPuppetObject);
            if (this.vAutoClean)
            {
                this.removeEventListener(Event.REMOVED_FROM_STAGE, this.destroy);
            }
            if (this.vBitmap)
            {
                try
                {
                    if (this.contains(this.vBitmap))
                    {
                        this.removeChild(this.vBitmap);
                    }
                    this.vBitmap.bitmapData = null;
                }
                catch (e:ArgumentError)
                {
                    if (vTrace)
                    {
                        trace("pas de removeChild possible");
                    }
                }
                this.vBitmap = null;
            }
            if (this.vPuppet)
            {
                while (this.numChildren > 0)
                {
                    
                    this.removeChildAt(0);
                }
            }
            this.destroyChildren();
            this.vBitmapClipList = null;
            this.vBitmapObject = null;
            this.vPuppetObject = null;
            this.vPuppetRoot = null;
            this.vFun = null;
            this.vFunParams = null;
            if (this.vTimer)
            {
                this.deleteTimer();
            }
            return;
        }// end function

        final private function destroyChildren() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            if (this.vPuppetObject)
            {
                if (this.vPuppetObject.vPuppetList)
                {
                    while (_loc_2 < this.vPuppetObject.vPuppetList.length)
                    {
                        
                        if (this[this.vPuppetObject.vPuppetList[_loc_2].vName])
                        {
                            delete this[this.vPuppetObject.vPuppetList[_loc_2].vName];
                        }
                        _loc_3 = this.vPuppetObject.vPuppetList[_loc_2].vID;
                        if (this.vPuppetRoot && this.vPuppetRoot.vBitmapClipList && this.vPuppetRoot.vBitmapClipList[_loc_3])
                        {
                            _loc_1 = this.vPuppetRoot.vBitmapClipList[_loc_3];
                            if (_loc_1)
                            {
                                _loc_1.destroy();
                            }
                        }
                        _loc_2++;
                    }
                }
            }
            return;
        }// end function

    }
}
