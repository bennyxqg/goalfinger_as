package globz
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.system.*;
    import flash.text.*;
    import flash.utils.*;

    public class mcToBitmapAS3 extends Sprite
    {
        private var vBitmapMemoryList:Array;
        public var vBDTab:Vector.<bitmapObject>;
        public var vOrderTab:Vector.<int>;
        public var vBitmapResolutionX:Number;
        public var vBitmapResolutionY:Number;
        public var vConversion:Boolean;
        public var vLabelsDictionary:Dictionary;
        public var vAnimsList:Vector.<String>;
        private var vMatrix:Matrix;
        private var vColorTransform:ColorTransform;
        public var vFrameStart:int;
        private var vIndex:int;
        private var vStartIndex:int;
        private var vEndIndex:int;
        private var vIndexType:String;
        private var vLimitRectangle:Rectangle;
        private const vMaxSize:uint = 2048;
        private const vMinSize:uint = 4;
        private var vSizeTab:Vector.<int>;
        private var vStageScale:Number;
        private var vMCVecto:MovieClip;
        public var vNBFrames:int;
        public var vNBFramesSaved:Object;
        public var vBitmapCut:Boolean;
        private var vFirstFrame:int;
        private var vLastFrame:int;
        private var vFirstScan:Boolean;
        private var vBitmapResolution:Number;
        private var vTransparent:Boolean;
        private var vLimitZone:Boolean;
        private var vDownscale:Number;
        private var vMCLoader:MovieClip;
        private var vBitmapIndex:int;
        private var vQueue:mcToBitmapQueue;
        private var vConversionCallBack:Function;
        private const vMaxTimerConversion:int = 1000;
        public var vVectoX:Number;
        public var vVectoY:Number;
        public var vSmoothing:Boolean = true;
        private var vMarge:Number;
        private var vStageQuality:String;
        public var vPuppet:Boolean;
        private var vMCPuppetTab:Array;
        public var vPuppetObject:puppetObject;
        public var vBitmapAS3Tab:Vector.<mcToBitmapAS3>;
        public var vSameID:Vector.<int>;
        public var vRealBitmap:Vector.<Boolean>;
        private var vIDScan:int;
        private var vWaitAFrame:Boolean = false;
        public var vResetFilters:Boolean;
        public var vLoader:Loader;
        public var vMCPath:String;
        private var vCallBack:Object;
        private var vPassInit:Boolean;
        private var vSavedResolution:Number;
        private var vTimerTMP:int = 0;
        private var vDelayedConversion:Boolean = false;
        private var vLoaderCallBack:Function;
        public static var vTrace:Boolean = false;

        public function mcToBitmapAS3(param1:MovieClip = null, param2 = 0, param3:Number = 1, param4:Boolean = false, param5:Rectangle = null, param6:Number = 8, param7 = null, param8:Number = 0, param9:Boolean = false, param10:String = "best", param11:Boolean = true, param12:Boolean = true, param13:Boolean = false) : void
        {
            if (param1 == null)
            {
                trace("pas de clip à bitmapiser");
                return;
            }
            this.vMCVecto = param1;
            this.vNBFramesSaved = param2;
            var _loc_15:* = param3;
            this.vBitmapResolution = param3;
            this.vSavedResolution = _loc_15;
            this.vTransparent = param4;
            this.vLimitRectangle = param5;
            this.vDownscale = param6;
            this.vCallBack = param7;
            this.vStageQuality = param10;
            this.vSmoothing = param11;
            this.vMarge = param8;
            this.vPuppet = param9;
            this.vWaitAFrame = param12;
            this.vResetFilters = param13;
            if (param7 is mcToBitmapQueue)
            {
                this.vWaitAFrame = false;
                this.vQueue = param7;
                this.vQueue.addToQueue(this);
            }
            var _loc_14:* = this.testLoader(param1);
            if (this.testLoader(param1) != null)
            {
                this.vMCPath = this.getMCPath(param1);
                this.vLoader = this.copyLoader(_loc_14.contentLoaderInfo, this.loaderCloned);
                this.vPassInit = false;
            }
            else
            {
                this.vPassInit = true;
                this.delayedMCToBitmapAS3(param1, param2, param3, param4, param5, param6, param7, param8, param9, param10, param11, param12, param13);
            }
            return;
        }// end function

        private function delayedMCToBitmapAS3(param1:MovieClip = null, param2 = 0, param3:Number = 1, param4:Boolean = false, param5:Rectangle = null, param6:Number = 8, param7 = null, param8:Number = 0, param9:Boolean = false, param10:String = "best", param11:Boolean = true, param12:Boolean = true, param13:Boolean = false) : void
        {
            var _loc_14:* = 0;
            var _loc_17:* = null;
            var _loc_18:* = null;
            if (!param1)
            {
                return;
            }
            this.vCallBack = null;
            this.vMCVecto = param1;
            if (this.vMCVecto.hasOwnProperty("vNBFrames"))
            {
                param2 = this.vMCVecto.vNBFrames;
            }
            this.vNBFramesSaved = param2;
            this.vBitmapResolution = param3;
            this.vTransparent = param4;
            this.vLimitRectangle = param5;
            if (this.vLimitRectangle)
            {
                this.vLimitZone = true;
            }
            else
            {
                this.vLimitZone = false;
            }
            this.vWaitAFrame = param12;
            this.vMCLoader = null;
            this.vConversionCallBack = null;
            this.vQueue = null;
            if (param7 != null)
            {
                if (param7 is MovieClip)
                {
                    this.vMCLoader = param7;
                }
                else if (param7 is Function)
                {
                    this.vConversionCallBack = param7;
                }
                else if (param7 is mcToBitmapQueue)
                {
                    this.vQueue = param7;
                    this.vWaitAFrame = false;
                }
            }
            this.vStageQuality = param10;
            this.vSmoothing = param11;
            this.vMarge = param8;
            this.vPuppet = param9;
            this.vResetFilters = param13;
            if (this.vLoader != null)
            {
                this.vBitmapResolution = this.vBitmapResolution * this.getResolutionFromScales(this.vMCVecto);
                this.vMCVecto.transform.matrix = new Matrix();
                this.vMCVecto.transform.colorTransform = new ColorTransform();
                this.vMCPath = this.getMCPath(param1);
            }
            this.vDownscale = param6 * param3;
            var _loc_15:* = this.vMCVecto.currentLabels;
            if (_loc_15.length > 0)
            {
                this.vLabelsDictionary = new Dictionary();
                _loc_14 = 0;
                while (_loc_14 < _loc_15.length)
                {
                    
                    _loc_17 = _loc_15[_loc_14];
                    this.vLabelsDictionary[_loc_17.name] = _loc_17.frame - 1;
                    _loc_14++;
                }
            }
            this.vAnimsList = new Vector.<String>(this.vMCVecto.totalFrames, true);
            _loc_14 = 0;
            while (_loc_14 < this.vMCVecto.totalFrames)
            {
                
                this.vAnimsList[_loc_14] = null;
                _loc_14++;
            }
            this.vBitmapCut = false;
            if (param2 is String)
            {
                _loc_18 = param2.split(",");
                if (_loc_18.length == 3)
                {
                    if (!isNaN(Number(_loc_18[0])))
                    {
                        this.vFirstFrame = Number(_loc_18[0]);
                    }
                    else
                    {
                        this.vFirstFrame = this.vLabelsDictionary[_loc_18[0]] + 1;
                    }
                    if (!isNaN(Number(_loc_18[1])))
                    {
                        this.vLastFrame = Number(_loc_18[1]);
                    }
                    else
                    {
                        this.vLastFrame = this.vLabelsDictionary[_loc_18[1]] + 1;
                    }
                    if (String(_loc_18[2]).toLowerCase() == "bitmap")
                    {
                        this.vBitmapCut = true;
                    }
                    this.vNBFrames = this.vLastFrame;
                }
                else if (_loc_18.length == 2)
                {
                    if (!isNaN(Number(_loc_18[0])))
                    {
                        this.vFirstFrame = Number(_loc_18[0]);
                    }
                    else
                    {
                        this.vFirstFrame = this.vLabelsDictionary[_loc_18[0]] + 1;
                    }
                    if (String(_loc_18[1]).toLowerCase() == "bitmap")
                    {
                        this.vBitmapCut = true;
                        this.vLastFrame = this.vFirstFrame;
                        this.vNBFrames = this.vLastFrame;
                    }
                    else
                    {
                        if (!isNaN(Number(_loc_18[1])))
                        {
                            this.vLastFrame = Number(_loc_18[1]);
                        }
                        else
                        {
                            this.vLastFrame = this.vLabelsDictionary[_loc_18[1]] + 1;
                        }
                        this.vNBFrames = this.vLastFrame;
                    }
                }
                else
                {
                    if (!isNaN(Number(_loc_18[0])))
                    {
                        this.vFirstFrame = Number(_loc_18[0]);
                    }
                    else
                    {
                        this.vFirstFrame = this.vLabelsDictionary[_loc_18[0]] + 1;
                    }
                    this.vLastFrame = this.vFirstFrame;
                    this.vNBFrames = this.vLastFrame;
                }
            }
            else if (param2 is int)
            {
                this.vNBFrames = int(param2);
                this.vFirstFrame = 1;
                this.vLastFrame = this.vNBFrames;
            }
            if (this.vPuppet && this.vBitmapCut)
            {
                this.vMCVecto.gotoAndStop(1);
                if (!this.convertToBitmapTest(this.vMCVecto))
                {
                    this.vNBFrames = 0;
                    this.vFirstFrame = 1;
                    this.vLastFrame = this.vNBFrames;
                }
            }
            if (this.vFirstFrame == 0)
            {
                this.vMCVecto.gotoAndStop(1);
            }
            else
            {
                this.vMCVecto.gotoAndStop(this.vFirstFrame);
            }
            this.vFirstScan = false;
            if (!this.vPuppet && this.vMCVecto.hasOwnProperty("vResolution"))
            {
                this.vBitmapResolution = this.vBitmapResolution * this.vMCVecto.vResolution;
            }
            else
            {
                this.vMCVecto.vResolution = 1;
            }
            if (!this.vLoader)
            {
                this.vSavedResolution = this.vBitmapResolution;
            }
            if (this.vPuppet)
            {
                this.vMCPuppetTab = new Array();
                this.vIDScan = 0;
            }
            this.vVectoX = this.vMCVecto.x;
            this.vVectoY = this.vMCVecto.y;
            this.vMCVecto.filters = this.resizeFilters(this.vMCVecto, this.vBitmapResolution);
            this.vConversion = false;
            var _loc_16:* = this.vMinSize;
            this.vSizeTab = new Vector.<int>;
            while (_loc_16 <= this.vMaxSize)
            {
                
                this.vSizeTab.push(_loc_16);
                _loc_16 = _loc_16 * 2;
            }
            this.vBitmapMemoryList = new Array();
            this.vStageScale = 1;
            this.vBitmapResolutionX = this.vBitmapResolution;
            this.vBitmapResolutionY = this.vBitmapResolution;
            this.vMatrix = this.vMCVecto.transform.matrix;
            this.vColorTransform = this.vMCVecto.transform.colorTransform;
            if (this.vNBFrames <= 0)
            {
                this.vFrameStart = 1;
                this.vNBFrames = this.vMCVecto.totalFrames;
            }
            else
            {
                this.vFrameStart = this.vFirstFrame;
            }
            this.vBDTab = new Vector.<bitmapObject>(this.vNBFrames, true);
            this.vOrderTab = new Vector.<int>(this.vNBFrames, true);
            this.vBitmapIndex = 0;
            this.vSameID = new Vector.<int>;
            this.vRealBitmap = new Vector.<Boolean>;
            if (this.vMCLoader != null)
            {
                if (this.vMCLoader.vNBFrames == null || this.vMCLoader.vNBFrames == undefined)
                {
                    this.vMCLoader.vNBFrames = this.vMCLoader.totalFrames;
                    this.vMCLoader.vNBFramesToConvert = this.vNBFrames;
                    this.vMCLoader.vNBConvertedFrames = 0;
                    this.vMCLoader.vTotalMemory = 0;
                    this.vMCLoader.vConversionList = new Array();
                    this.vMCLoader.vConversionList.push(this);
                    if (!this.vPuppet)
                    {
                        this.conversionLoop();
                    }
                    else
                    {
                        this.vPuppetObject = this.scanPuppet(this.vMCVecto);
                        this.vPuppetObject.vIDTotal = this.vIDScan;
                        this.vBitmapAS3Tab = new Vector.<mcToBitmapAS3>(this.vMCPuppetTab.length);
                        this.bitmapPuppetConversion();
                    }
                }
                else
                {
                    this.vMCLoader.vNBFramesToConvert = this.vMCLoader.vNBFramesToConvert + this.vNBFrames;
                    this.vMCLoader.vConversionList.push(this);
                }
            }
            else if (this.vQueue != null)
            {
            }
            else if (!this.vPuppet)
            {
                this.conversionLoop();
            }
            else
            {
                this.vPuppetObject = this.scanPuppet(this.vMCVecto);
                this.vPuppetObject.vIDTotal = this.vIDScan;
                this.vBitmapAS3Tab = new Vector.<mcToBitmapAS3>(this.vMCPuppetTab.length);
                this.bitmapPuppetConversion();
            }
            return;
        }// end function

        final private function testLoader(param1:MovieClip) : Loader
        {
            var _loc_2:* = param1;
            while (_loc_2.parent != null)
            {
                
                _loc_2 = _loc_2.parent;
            }
            if (_loc_2 is Loader)
            {
                return _loc_2 as Loader;
            }
            return null;
        }// end function

        final private function loaderCloned() : void
        {
            this.vPassInit = true;
            if (this.vMCPath != "")
            {
                this.vMCVecto = this.path(this.vLoader.content as MovieClip, this.vMCPath);
                if (this.vMCVecto == null)
                {
                    trace("ERROR : a MovieClip inside \'" + this.vLoader.content.name + "\' must be named : " + this.vMCPath);
                }
            }
            else
            {
                this.vMCVecto = this.vLoader.content as MovieClip;
            }
            this.delayedMCToBitmapAS3(this.vMCVecto, this.vNBFramesSaved, this.vBitmapResolution, this.vTransparent, this.vLimitRectangle, this.vDownscale, this.vCallBack, this.vMarge, this.vPuppet, this.vStageQuality, this.vSmoothing, this.vWaitAFrame, this.vResetFilters);
            if (this.vDelayedConversion)
            {
                this.startConversion(this.vConversionCallBack, this.vTimerTMP);
            }
            this.vDelayedConversion = false;
            return;
        }// end function

        final private function getResolutionFromScales(param1:MovieClip) : Number
        {
            var _loc_2:* = (param1.scaleX + param1.scaleY) * 0.5;
            var _loc_3:* = param1;
            while (_loc_3.parent != null)
            {
                
                _loc_3 = _loc_3.parent;
                _loc_2 = _loc_2 * ((_loc_3.scaleX + _loc_3.scaleY) * 0.5);
            }
            return _loc_2;
        }// end function

        private function path(param1:MovieClip, param2:String, param3:String = ".") : MovieClip
        {
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_4:* = param2.split(param3);
            var _loc_5:* = param1.getChildByName(_loc_4[0]);
            if (_loc_4.length > 1 && _loc_5 is MovieClip)
            {
                _loc_4.shift();
                _loc_6 = _loc_4.join(param3);
                _loc_7 = _loc_5 as MovieClip;
                return this.path(_loc_7, _loc_6, param3);
            }
            param1.gotoAndStop(1);
            while (param1.currentFrame < param1.totalFrames)
            {
                
                param1.nextFrame();
                _loc_5 = param1.getChildByName(_loc_4[0]);
                if (_loc_4.length > 1 && _loc_5 is MovieClip)
                {
                    _loc_4.shift();
                    _loc_6 = _loc_4.join(param3);
                    _loc_7 = _loc_5 as MovieClip;
                    return this.path(_loc_7, _loc_6, param3);
                }
                if (_loc_5 != null)
                {
                    break;
                }
            }
            return _loc_5 as MovieClip;
        }// end function

        final public function startConversion(param1:Function = null, param2:int = 0) : void
        {
            this.vConversionCallBack = param1;
            if (!this.vPuppet)
            {
                this.vTimerTMP = param2;
            }
            if (this.vPassInit)
            {
                if (!this.vPuppet)
                {
                    this.vTimerTMP = param2;
                    this.conversionLoop();
                }
                else
                {
                    this.vPuppetObject = this.scanPuppet(this.vMCVecto);
                    this.vPuppetObject.vIDTotal = this.vIDScan;
                    this.vBitmapAS3Tab = new Vector.<mcToBitmapAS3>(this.vMCPuppetTab.length);
                    this.bitmapPuppetConversion();
                }
            }
            else
            {
                this.vDelayedConversion = true;
            }
            return;
        }// end function

        final private function bitmapPuppetConversion() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            if (this.vPuppetObject.vBitmap)
            {
                this.vBitmapAS3Tab = null;
                this.vPuppet = false;
                this.vPuppetObject = null;
                this.conversionLoop();
                return;
            }
            if (this.vMCPuppetTab.length > 0)
            {
                if (this.vLoader)
                {
                    _loc_3 = this.vMCPuppetTab.shift();
                    _loc_1 = this.path(this.vLoader.content as MovieClip, _loc_3.vPath);
                    _loc_2 = _loc_3.vBitmapIndex;
                }
                else
                {
                    _loc_1 = this.vMCPuppetTab.shift();
                    _loc_2 = _loc_1.vBitmapIndex;
                }
                if (this.vBitmapCut)
                {
                    this.vBitmapAS3Tab[_loc_2] = new mcToBitmapAS3(_loc_1, this.vNBFramesSaved, this.vSavedResolution, this.vTransparent, null, this.vDownscale, this.bitmapPuppetConversion, this.vMarge, false, this.vStageQuality, this.vSmoothing, false);
                }
                else if (this.vFirstScan)
                {
                    this.vBitmapAS3Tab[_loc_2] = new mcToBitmapAS3(_loc_1, 0, this.vSavedResolution, this.vTransparent, null, this.vDownscale, this.bitmapPuppetConversion, this.vMarge, false, this.vStageQuality, this.vSmoothing, false);
                }
                else
                {
                    this.vBitmapAS3Tab[_loc_2] = new mcToBitmapAS3(_loc_1, this.vNBFramesSaved, this.vSavedResolution, this.vTransparent, null, this.vDownscale, this.bitmapPuppetConversion, this.vMarge, false, this.vStageQuality, this.vSmoothing, false);
                }
            }
            else
            {
                this.vMCVecto = null;
                this.vMCPuppetTab = null;
                if (this.vLoader)
                {
                    this.vLoader.unloadAndStop(false);
                }
                this.vLoader = null;
                this.vConversion = true;
                _loc_4 = 0;
                while (_loc_4 < this.vBitmapAS3Tab.length)
                {
                    
                    _loc_7 = this.vBitmapAS3Tab[_loc_4];
                    this.vSameID[_loc_4] = _loc_4;
                    this.vRealBitmap[_loc_4] = true;
                    if (_loc_7)
                    {
                        _loc_5 = 0;
                        while (_loc_5 < this.vBitmapAS3Tab.length)
                        {
                            
                            if (_loc_4 != _loc_5)
                            {
                                _loc_8 = this.vBitmapAS3Tab[_loc_5];
                                if (_loc_8 && _loc_8 != _loc_7 && _loc_7.vBDTab.length == _loc_8.vBDTab.length)
                                {
                                    if (this.compareBitmapAs3(_loc_7, _loc_8))
                                    {
                                        _loc_8.destroyAll();
                                        _loc_8 = _loc_7;
                                        this.vBitmapAS3Tab[_loc_5] = _loc_7;
                                        this.vSameID[_loc_4] = _loc_5;
                                        this.vRealBitmap[_loc_4] = false;
                                    }
                                }
                            }
                            _loc_5++;
                        }
                    }
                    _loc_4++;
                }
                if (this.vMCLoader != null)
                {
                    this.vMCLoader.vConversionList.shift();
                    if (this.vMCLoader.vConversionList.length > 0)
                    {
                        this.vMCLoader.vConversionList[0].startConversion();
                    }
                    this.updateLoader();
                }
                else if (this.vQueue != null)
                {
                    this.vQueue.vQueueList.shift();
                    if (this.vQueue.vQueueList.length == 0)
                    {
                        this.vQueue.destroy();
                        if (this.vConversionCallBack != null)
                        {
                            _loc_6 = this.vConversionCallBack;
                            this.vConversionCallBack = null;
                            this._loc_6();
                        }
                    }
                    else
                    {
                        this.vQueue.vQueueList[0].startConversion(this.vConversionCallBack);
                    }
                }
                else if (this.vConversionCallBack != null)
                {
                    if (this.vWaitAFrame)
                    {
                        this.addEventListener(Event.ENTER_FRAME, this.waitAFrameToFinish);
                    }
                    else
                    {
                        _loc_6 = this.vConversionCallBack;
                        this.vConversionCallBack = null;
                        this._loc_6();
                    }
                }
            }
            return;
        }// end function

        final private function compareBitmapAs3(param1:mcToBitmapAS3, param2:mcToBitmapAS3) : Boolean
        {
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_3:* = true;
            _loc_4 = 0;
            while (_loc_4 < param1.vBDTab.length)
            {
                
                if (param1.vBDTab && param1.vBDTab[_loc_4])
                {
                    _loc_5 = param1.vBDTab[_loc_4].vBD;
                }
                if (param2.vBDTab && param2.vBDTab[_loc_4])
                {
                    _loc_6 = param2.vBDTab[_loc_4].vBD;
                }
                if (_loc_5 == null || _loc_6 == null)
                {
                    return false;
                }
                if (_loc_5.compare(_loc_6) != 0)
                {
                    return false;
                }
                _loc_4++;
            }
            return _loc_3;
        }// end function

        final private function scanPuppet(param1:MovieClip) : puppetObject
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_12:* = null;
            var _loc_13:* = null;
            var _loc_14:* = 0;
            var _loc_15:* = 0;
            var _loc_16:* = 0;
            var _loc_17:* = null;
            var _loc_18:* = null;
            var _loc_19:* = 0;
            var _loc_20:* = false;
            var _loc_7:* = new puppetObject();
            var _loc_10:* = false;
            var _loc_11:* = new Vector.<puppetObject>;
            if (!this.vFirstScan)
            {
                param1.gotoAndStop(this.vFirstFrame);
            }
            else
            {
                param1.gotoAndStop(1);
            }
            _loc_10 = this.convertToBitmapTest(param1);
            if (!param1.vResolution)
            {
                param1.vResolution = 1;
            }
            if (_loc_7.vID < 0)
            {
                _loc_7.vID = this.vIDScan;
                var _loc_21:* = this;
                var _loc_22:* = this.vIDScan + 1;
                _loc_21.vIDScan = _loc_22;
            }
            if (_loc_10)
            {
                _loc_7.vBitmap = true;
                if (!this.vFirstScan)
                {
                    _loc_7.vNBFrames = this.vNBFrames;
                }
                else
                {
                    _loc_7.vNBFrames = param1.totalFrames;
                }
                _loc_7.vBitmapIndex = this.vMCPuppetTab.length;
                if (this.vLoader == null)
                {
                    _loc_12 = this.cloneMC(param1);
                    _loc_12.vBitmapIndex = _loc_7.vBitmapIndex;
                    this.vMCPuppetTab[_loc_7.vBitmapIndex] = _loc_12;
                    _loc_7.vName = param1.name;
                    if (_loc_7.vID < 0)
                    {
                        _loc_7.vID = this.vIDScan;
                        var _loc_21:* = this;
                        var _loc_22:* = this.vIDScan + 1;
                        _loc_21.vIDScan = _loc_22;
                    }
                    if (param1.vResolution)
                    {
                        _loc_12.vResolution = param1.vResolution;
                    }
                }
                else
                {
                    _loc_12 = param1;
                    _loc_12.vBitmapIndex = _loc_7.vBitmapIndex;
                    this.vMCPuppetTab[_loc_7.vBitmapIndex] = new Object();
                    this.vMCPuppetTab[_loc_7.vBitmapIndex].vBitmapIndex = _loc_7.vBitmapIndex;
                    this.vMCPuppetTab[_loc_7.vBitmapIndex].vPath = this.getMCPath(param1);
                    _loc_7.vName = _loc_12.name;
                    if (_loc_7.vID < 0)
                    {
                        _loc_7.vID = this.vIDScan;
                        var _loc_21:* = this;
                        var _loc_22:* = this.vIDScan + 1;
                        _loc_21.vIDScan = _loc_22;
                    }
                }
            }
            else
            {
                _loc_13 = _loc_12.currentLabels;
                if (_loc_13.length > 0)
                {
                    _loc_7.vLabelsDictionary = new Dictionary();
                    _loc_2 = 0;
                    while (_loc_2 < _loc_13.length)
                    {
                        
                        _loc_17 = _loc_13[_loc_2];
                        _loc_7.vLabelsDictionary[_loc_17.name] = _loc_17.frame - 1;
                        _loc_2++;
                    }
                }
                _loc_7.vAnimsList = new Vector.<String>(_loc_12.totalFrames, true);
                _loc_2 = 0;
                while (_loc_2 < _loc_12.totalFrames)
                {
                    
                    _loc_7.vAnimsList[_loc_2] = null;
                    _loc_2++;
                }
                _loc_7.vAnimsOnceList = new Vector.<String>(_loc_12.totalFrames, true);
                _loc_2 = 0;
                while (_loc_2 < _loc_12.totalFrames)
                {
                    
                    _loc_7.vAnimsOnceList[_loc_2] = null;
                    _loc_2++;
                }
                _loc_7.vBitmap = false;
                if (!this.vFirstScan)
                {
                    this.vFirstScan = true;
                    _loc_14 = this.vNBFrames;
                    var _loc_21:* = this.vFirstFrame;
                    _loc_15 = this.vFirstFrame;
                    _loc_16 = _loc_21;
                }
                else
                {
                    _loc_14 = _loc_12.totalFrames;
                    var _loc_21:* = 1;
                    _loc_15 = 1;
                    _loc_16 = _loc_21;
                }
                _loc_7.vNBFrames = _loc_14;
                _loc_5 = _loc_15;
                while (_loc_5 <= _loc_14)
                {
                    
                    _loc_12.gotoAndStop(_loc_5);
                    if (_loc_12.vAnims)
                    {
                        _loc_6 = _loc_12.vAnims.split(" ").join("");
                        _loc_12.vAnims = null;
                        _loc_18 = _loc_6.split(";");
                        _loc_2 = 0;
                        while (_loc_2 < _loc_18.length)
                        {
                            
                            if (_loc_18[_loc_2])
                            {
                                _loc_18[_loc_2] = _loc_18[_loc_2].split("\'").join("\"") + ";";
                                if (_loc_18[_loc_2].indexOf("once;") > -1)
                                {
                                    if (_loc_7.vAnimsOnceList[(_loc_5 - 1)] == null)
                                    {
                                        _loc_7.vAnimsOnceList[(_loc_5 - 1)] = _loc_18[_loc_2].split("once;").join(";");
                                    }
                                    else
                                    {
                                        _loc_7.vAnimsOnceList[(_loc_5 - 1)] = _loc_7.vAnimsOnceList[(_loc_5 - 1)] + _loc_18[_loc_2].split("once;").join(";");
                                    }
                                }
                                else if (_loc_7.vAnimsList[(_loc_5 - 1)] == null)
                                {
                                    _loc_7.vAnimsList[(_loc_5 - 1)] = _loc_18[_loc_2];
                                }
                                else
                                {
                                    _loc_7.vAnimsList[(_loc_5 - 1)] = _loc_7.vAnimsList[(_loc_5 - 1)] + _loc_18[_loc_2];
                                }
                            }
                            _loc_2++;
                        }
                    }
                    _loc_2 = 0;
                    while (_loc_2 < _loc_12.numChildren)
                    {
                        
                        _loc_9 = _loc_12.getChildAt(_loc_2);
                        _loc_19 = _loc_11.length;
                        if (_loc_9 is MovieClip)
                        {
                            if (!MovieClip(_loc_9).vAdded)
                            {
                                _loc_8 = this.scanPuppet(MovieClip(_loc_9));
                                _loc_11[_loc_19] = _loc_8;
                                _loc_8.vMatrixTab = new Vector.<Matrix>(_loc_14);
                                _loc_8.vAlphaTab = new Vector.<Number>(_loc_14);
                                _loc_8.vIndexTab = new Vector.<int>(_loc_14);
                                _loc_8.vName = MovieClip(_loc_9).name;
                                MovieClip(_loc_9).vAdded = true;
                                MovieClip(_loc_9).vIndex = _loc_19;
                                if (_loc_7.vID < 0)
                                {
                                    _loc_7.vID = this.vIDScan;
                                    var _loc_21:* = this;
                                    var _loc_22:* = this.vIDScan + 1;
                                    _loc_21.vIDScan = _loc_22;
                                }
                            }
                            else
                            {
                                _loc_19 = MovieClip(_loc_9).vIndex;
                                _loc_8 = _loc_11[_loc_19];
                            }
                            _loc_8.vMatrixTab[(_loc_5 - 1)] = _loc_9.transform.matrix;
                            _loc_8.vAlphaTab[(_loc_5 - 1)] = _loc_9.alpha;
                            _loc_8.vIndexTab[(_loc_5 - 1)] = _loc_12.getChildIndex(_loc_9);
                        }
                        _loc_2++;
                    }
                    _loc_5++;
                }
                _loc_7.vPuppetList = _loc_11.concat();
                if (_loc_16 > 1)
                {
                    _loc_4 = _loc_7.vPuppetList.length;
                    _loc_2 = 0;
                    while (_loc_2 < _loc_4)
                    {
                        
                        _loc_8 = _loc_7.vPuppetList[_loc_2];
                        _loc_3 = 0;
                        while (_loc_3 < (_loc_16 - 1))
                        {
                            
                            _loc_8.vMatrixTab[_loc_3] = _loc_8.vMatrixTab[(_loc_16 - 1)];
                            _loc_8.vAlphaTab[_loc_3] = _loc_8.vAlphaTab[(_loc_16 - 1)];
                            _loc_8.vIndexTab[_loc_3] = _loc_8.vIndexTab[(_loc_16 - 1)];
                            _loc_3++;
                        }
                        _loc_2++;
                    }
                }
            }
            if (_loc_7.vPuppetList)
            {
                _loc_4 = _loc_7.vPuppetList.length;
                _loc_20 = true;
                _loc_2 = 0;
                while (_loc_2 < _loc_4)
                {
                    
                    _loc_8 = _loc_7.vPuppetList[_loc_2];
                    _loc_3 = 0;
                    while (_loc_3 < _loc_8.vMatrixTab.length)
                    {
                        
                        if (_loc_8.vMatrixTab[_loc_3] == null)
                        {
                            _loc_20 = false;
                            break;
                        }
                        _loc_3++;
                    }
                    _loc_8.vStayAllFrames = _loc_20;
                    _loc_2++;
                }
            }
            return _loc_7;
        }// end function

        final private function convertToBitmapTest(param1:MovieClip) : Boolean
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = false;
            _loc_2 = 0;
            while (_loc_2 < param1.numChildren)
            {
                
                _loc_3 = param1.getChildAt(_loc_2);
                if (!(_loc_3 is MovieClip))
                {
                    _loc_4 = true;
                    break;
                }
                _loc_2++;
            }
            return _loc_4;
        }// end function

        final private function cloneMC(param1:MovieClip) : MovieClip
        {
            var _loc_4:* = null;
            var _loc_6:* = null;
            var _loc_2:* = Object(param1).constructor;
            var _loc_3:* = new _loc_2;
            if (param1.parent && param1.parent != param1.stage && param1.parent is MovieClip)
            {
                _loc_4 = MovieClip(param1.parent);
            }
            else
            {
                _loc_4 = null;
            }
            if (_loc_4 != null)
            {
                _loc_6 = param1.transform.colorTransform;
                _loc_6.concat(_loc_4.transform.colorTransform);
                if (_loc_4.parent && _loc_4.parent != _loc_4.stage && _loc_4.parent is MovieClip)
                {
                    _loc_4 = MovieClip(_loc_4.parent);
                }
                else
                {
                    _loc_4 = null;
                }
                while (_loc_4 != null)
                {
                    
                    _loc_6.concat(_loc_4.transform.colorTransform);
                    if (_loc_4.parent && _loc_4.parent != _loc_4.stage && _loc_4.parent is MovieClip)
                    {
                        _loc_4 = MovieClip(_loc_4.parent);
                        continue;
                    }
                    _loc_4 = null;
                }
                _loc_3.transform.colorTransform = _loc_6;
                _loc_3.alpha = 1;
            }
            else
            {
                _loc_3.transform.colorTransform = param1.transform.colorTransform;
                _loc_3.alpha = 1;
            }
            var _loc_5:* = param1;
            while (_loc_5.parent)
            {
                
                if (_loc_5.parent && _loc_5.parent != _loc_5.stage && _loc_5.parent is MovieClip && MovieClip(_loc_5.parent).vResolution)
                {
                    _loc_5 = MovieClip(_loc_5.parent);
                    continue;
                }
                break;
            }
            if (_loc_5 != param1 && _loc_5.filters)
            {
                _loc_3.filters = _loc_5.filters;
            }
            else
            {
                _loc_3.filters = param1.filters;
            }
            _loc_3.cacheAsBitmap = param1.cacheAsBitmap;
            _loc_3.opaqueBackground = param1.opaqueBackground;
            return _loc_3;
        }// end function

        final private function getMCPath(param1:MovieClip) : String
        {
            var _loc_2:* = new Array();
            _loc_2[0] = param1.name;
            while (param1.parent && param1.parent is MovieClip)
            {
                
                param1 = param1.parent as MovieClip;
                _loc_2.unshift(param1.name);
            }
            var _loc_3:* = "";
            var _loc_4:* = 0;
            while (_loc_4 < _loc_2.length)
            {
                
                if (_loc_4 == (_loc_2.length - 1) && _loc_4 > 0)
                {
                    _loc_3 = _loc_3 + _loc_2[_loc_4];
                }
                else if (_loc_4 > 0)
                {
                    _loc_3 = _loc_3 + (_loc_2[_loc_4] + ".");
                }
                _loc_4++;
            }
            return _loc_3;
        }// end function

        final public function resizeFilters(param1:DisplayObject, param2:Number) : Array
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = 0;
            var _loc_9:* = 0;
            var _loc_10:* = null;
            if (this.vResetFilters)
            {
            }
            if (param1 is MovieClip)
            {
                _loc_3 = param1 as MovieClip;
                if (this.vResetFilters)
                {
                    _loc_6 = _loc_3.parent;
                    while (_loc_6 != null)
                    {
                        
                        param2 = param2 * ((_loc_6.scaleX + _loc_6.scaleY) * 0.5);
                        _loc_6 = _loc_6.parent;
                    }
                }
            }
            else if (param1 is TextField)
            {
                _loc_4 = param1 as TextField;
            }
            var _loc_5:* = new Array();
            if (_loc_3 && _loc_3.filters && _loc_3.filters.length > 0 || _loc_4 && _loc_4.filters && _loc_4.filters.length > 0)
            {
                if (_loc_3)
                {
                    _loc_8 = _loc_3.filters.length;
                }
                else
                {
                    _loc_8 = _loc_4.filters.length;
                }
                _loc_9 = 0;
                while (_loc_9 < _loc_8)
                {
                    
                    if (_loc_3)
                    {
                        _loc_7 = _loc_3.filters[_loc_9];
                    }
                    else
                    {
                        _loc_7 = _loc_4.filters[_loc_9];
                    }
                    _loc_10 = getQualifiedClassName(_loc_7);
                    switch(_loc_10)
                    {
                        case "flash.filters::ColorMatrixFilter":
                        case "flash.filters::ConvolutionFilter":
                        {
                            break;
                        }
                        case "flash.filters::BlurFilter":
                        case "flash.filters::GlowFilter":
                        {
                            _loc_7.blurX = _loc_7.blurX * param2;
                            _loc_7.blurY = _loc_7.blurY * param2;
                            break;
                        }
                        case "flash.filters::BevelFilter":
                        case "flash.filters::DropShadowFilter":
                        case "flash.filters::GradientBevelFilter":
                        case "flash.filters::GradientGlowFilter":
                        {
                            _loc_7.distance = _loc_7.distance * param2;
                            _loc_7.blurX = _loc_7.blurX * param2;
                            _loc_7.blurY = _loc_7.blurY * param2;
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    _loc_5.push(_loc_7);
                    _loc_9++;
                }
            }
            return _loc_5;
        }// end function

        final private function scanForFilters(param1:MovieClip = null, param2:MovieClip = null) : MovieClip
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            if (this.vLoader)
            {
                return null;
            }
            if (param2 == null)
            {
                param2 = param1;
            }
            _loc_3 = 0;
            while (_loc_3 < param2.numChildren)
            {
                
                _loc_9 = param2.getChildAt(_loc_3);
                if (_loc_9 is MovieClip)
                {
                    _loc_7 = _loc_9 as MovieClip;
                    _loc_6 = this.scanForFilters(param1, _loc_7);
                    if (_loc_5 == null && _loc_6 != null)
                    {
                        _loc_5 = _loc_6;
                    }
                    if (_loc_7.filters.length > 0)
                    {
                        _loc_7.filters = this.resizeFilters(_loc_7, this.vBitmapResolution);
                        if (_loc_5 == null)
                        {
                            _loc_5 = this.cloneMC(param1);
                        }
                    }
                }
                else if (_loc_9 is TextField)
                {
                    _loc_8 = _loc_9 as TextField;
                    if (_loc_8.filters.length > 0)
                    {
                        _loc_8.filters = this.resizeFilters(_loc_8, this.vBitmapResolution);
                    }
                }
                _loc_3++;
            }
            return _loc_5;
        }// end function

        final private function updateLoader() : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            if (!this.vMCLoader)
            {
                return;
            }
            var _loc_1:* = int(this.vMCLoader.vNBFrames * (this.vMCLoader.vNBConvertedFrames / this.vMCLoader.vNBFramesToConvert));
            if (_loc_1 <= 0)
            {
                _loc_1 = 1;
            }
            if (_loc_1 > this.vMCLoader.vNBFrames)
            {
                _loc_1 = this.vMCLoader.vNBFrames;
            }
            this.vMCLoader.gotoAndStop(_loc_1);
            if (_loc_1 == this.vMCLoader.vNBFrames && this.vMCLoader.vConversionList.length == 0)
            {
                if (vTrace)
                {
                    trace("total memory used " + this.vMCLoader.vTotalMemory / 1024 + " ko ");
                    trace("");
                    _loc_2 = new TextField();
                    this.vMCLoader.addChild(_loc_2);
                    _loc_2.text = "total memory used " + this.vMCLoader.vTotalMemory / 1024 + " ko ";
                    _loc_2.selectable = false;
                    _loc_2.border = true;
                    _loc_2.autoSize = TextFieldAutoSize.LEFT;
                    _loc_3 = new TextFormat();
                    _loc_3.color = 11141120;
                    _loc_3.size = 24;
                    _loc_2.setTextFormat(_loc_3);
                    _loc_2.x = (-_loc_2.width) / 2;
                    _loc_2.y = (-_loc_2.height) / 2;
                }
                this.vMCLoader.vNBFrames = null;
                this.vMCLoader.vNBFramesToConvert = null;
                this.vMCLoader.vNBConvertedFrames = null;
                this.vMCLoader.vConversionList = null;
                this.vMCLoader = null;
            }
            return;
        }// end function

        final private function conversionLoop() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = getTimer();
            var _loc_5:* = getTimer() - _loc_4 + this.vTimerTMP;
            while (_loc_5 < this.vMaxTimerConversion)
            {
                
                if (this.vMCLoader)
                {
                    this.vConversion = this.vMCLoader.vConversionList[0].convertBitmaps();
                    if (this.vConversion)
                    {
                        this.vMCLoader.vConversionList.shift();
                        if (this.vMCLoader.vConversionList.length > 0)
                        {
                            this.vMCLoader.vConversionList[0].startConversion();
                        }
                        this.updateLoader();
                        break;
                    }
                }
                else if (this.vQueue)
                {
                    this.vConversion = this.vQueue.vQueueList[0].convertBitmaps();
                    if (this.vConversion)
                    {
                        this.vQueue.vQueueList.shift();
                        if (this.vQueue.vQueueList.length == 0)
                        {
                            this.vQueue.destroy();
                            if (this.vConversionCallBack != null)
                            {
                                _loc_3 = this.vConversionCallBack;
                                this.vConversionCallBack = null;
                                this._loc_3();
                            }
                            if (vTrace)
                            {
                                trace("total memory used " + this.vQueue.vTotalMemory / 1024 + " ko ");
                                trace("");
                            }
                            break;
                        }
                        else
                        {
                            this.vQueue.vQueueList[0].startConversion(this.vConversionCallBack, _loc_5);
                        }
                        break;
                    }
                }
                else
                {
                    this.vConversion = this.convertBitmaps();
                    if (this.vConversion)
                    {
                        if (this.vConversionCallBack != null)
                        {
                            if (this.vWaitAFrame)
                            {
                                this.addEventListener(Event.ENTER_FRAME, this.waitAFrameToFinish);
                            }
                            else
                            {
                                _loc_3 = this.vConversionCallBack;
                                this.vConversionCallBack = null;
                                this._loc_3();
                            }
                        }
                        break;
                    }
                }
                _loc_5 = getTimer() - _loc_4 + this.vTimerTMP;
            }
            this.vTimerTMP = 0;
            if (!this.vConversion)
            {
                this.addEventListener(Event.ENTER_FRAME, this.waitAFrame);
            }
            return;
        }// end function

        final private function waitAFrame(event:Event) : void
        {
            this.removeEventListener(Event.ENTER_FRAME, this.waitAFrame);
            this.conversionLoop();
            return;
        }// end function

        final private function waitAFrameToFinish(event:Event) : void
        {
            var _loc_2:* = null;
            this.removeEventListener(Event.ENTER_FRAME, this.waitAFrameToFinish);
            if (this.vConversionCallBack != null)
            {
                _loc_2 = this.vConversionCallBack;
                this.vConversionCallBack = null;
                this._loc_2();
            }
            return;
        }// end function

        final public function convertBitmaps() : Boolean
        {
            var _loc_1:* = 0;
            var _loc_2:* = 0;
            var _loc_5:* = null;
            var _loc_12:* = null;
            var _loc_15:* = null;
            var _loc_16:* = null;
            var _loc_18:* = null;
            var _loc_19:* = null;
            var _loc_20:* = null;
            var _loc_21:* = 0;
            var _loc_22:* = 0;
            var _loc_23:* = null;
            var _loc_24:* = null;
            var _loc_25:* = null;
            var _loc_26:* = NaN;
            var _loc_27:* = NaN;
            var _loc_28:* = 0;
            this.vMCVecto.gotoAndStop(this.vFrameStart);
            if (this.vMCVecto.hasOwnProperty("vTransparent"))
            {
                this.vTransparent = this.vMCVecto.vTransparent;
            }
            if (this.vMCVecto.hasOwnProperty("vAnims") && this.vMCVecto.vAnims != null)
            {
                _loc_18 = this.vMCVecto.vAnims.split(" ").join("");
                _loc_19 = _loc_18.split(";");
                _loc_1 = 0;
                while (_loc_1 < _loc_19.length)
                {
                    
                    if (_loc_19[_loc_1])
                    {
                        _loc_19[_loc_1] = _loc_19[_loc_1] + ";";
                        if (_loc_19[_loc_1].indexOf("once;") == -1)
                        {
                            _loc_19[_loc_1] = _loc_19[_loc_1].split("\'").join("\"");
                            _loc_20 = _loc_19[_loc_1].slice(0, _loc_19[_loc_1].indexOf("(")).split(".");
                            if (_loc_20.length == 1)
                            {
                                if (this.vAnimsList[(this.vFrameStart - 1)] == null)
                                {
                                    this.vAnimsList[(this.vFrameStart - 1)] = _loc_19[_loc_1];
                                }
                                else
                                {
                                    this.vAnimsList[(this.vFrameStart - 1)] = this.vAnimsList[(this.vFrameStart - 1)] + _loc_19[_loc_1];
                                }
                            }
                        }
                    }
                    _loc_1++;
                }
                this.vMCVecto.vAnims = null;
            }
            var _loc_3:* = this.vBitmapResolutionX;
            var _loc_4:* = this.vBitmapResolutionY;
            if (this.vLimitZone)
            {
                _loc_5 = this.vLimitRectangle;
                _loc_5.x = int(_loc_5.x);
                _loc_5.y = int(_loc_5.y);
                _loc_5.width = Math.ceil(_loc_5.width);
                _loc_5.height = Math.ceil(_loc_5.height);
            }
            else
            {
                _loc_5 = this.vMCVecto.getBounds(this.vMCVecto.parent);
                _loc_5.x = int(_loc_5.x - this.vMarge) - 1;
                _loc_5.y = int(_loc_5.y - this.vMarge) - 1;
                _loc_5.width = Math.ceil(_loc_5.width + this.vMarge * 2) + 2;
                _loc_5.height = Math.ceil(_loc_5.height + this.vMarge * 2) + 2;
            }
            var _loc_6:* = Math.ceil(_loc_5.width * _loc_3);
            var _loc_7:* = Math.ceil(_loc_5.height * _loc_4);
            var _loc_8:* = 1;
            var _loc_9:* = 1;
            if (_loc_6 > this.vMaxSize)
            {
                _loc_8 = this.vMaxSize / _loc_6;
                _loc_6 = this.vMaxSize;
            }
            else
            {
                _loc_21 = this.vMinSize;
                _loc_2 = 0;
                while (_loc_2 < this.vSizeTab.length)
                {
                    
                    if (_loc_6 <= this.vSizeTab[_loc_2])
                    {
                        break;
                    }
                    else
                    {
                        _loc_21 = this.vSizeTab[_loc_2];
                    }
                    _loc_2++;
                }
                if (_loc_6 - this.vDownscale <= _loc_21 && _loc_6 > _loc_21)
                {
                    _loc_8 = _loc_21 / _loc_6;
                    _loc_6 = _loc_21;
                }
            }
            if (_loc_7 > this.vMaxSize)
            {
                _loc_9 = this.vMaxSize / _loc_7;
                _loc_7 = this.vMaxSize;
            }
            else
            {
                _loc_22 = this.vMinSize;
                _loc_2 = 0;
                while (_loc_2 < this.vSizeTab.length)
                {
                    
                    if (_loc_7 <= this.vSizeTab[_loc_2])
                    {
                        break;
                    }
                    else
                    {
                        _loc_22 = this.vSizeTab[_loc_2];
                    }
                    _loc_2++;
                }
                if (_loc_7 - this.vDownscale <= _loc_22 && _loc_7 > _loc_22)
                {
                    _loc_9 = _loc_22 / _loc_7;
                    _loc_7 = _loc_22;
                }
            }
            var _loc_10:* = this.scanForFilters(this.vMCVecto);
            var _loc_11:* = 0;
            if (!this.vTransparent && this.vLimitZone)
            {
                if (_loc_5.width > 1 && _loc_5.height > 1)
                {
                    _loc_23 = new BitmapData(1, 1, false, 0);
                    _loc_24 = new Matrix();
                    _loc_24.scale(_loc_3 * _loc_8, _loc_4 * _loc_9);
                    _loc_24.tx = (this.vMCVecto.x - (_loc_5.x + 1)) * (_loc_3 * _loc_8);
                    _loc_24.ty = (this.vMCVecto.y - (_loc_5.y + 1)) * (_loc_4 * _loc_9);
                    if (_loc_23.hasOwnProperty("drawWithQuality"))
                    {
                        Object(_loc_23).drawWithQuality(this.vMCVecto, _loc_24, this.vColorTransform, null, null, this.vSmoothing, this.vStageQuality);
                    }
                    else
                    {
                        _loc_23.draw(this.vMCVecto, _loc_24, this.vColorTransform, null, null, this.vSmoothing);
                    }
                    _loc_11 = _loc_23.getPixel(0, 0);
                    _loc_23.dispose();
                }
            }
            if (_loc_6 < 1)
            {
                _loc_6 = 1;
            }
            if (_loc_7 < 1)
            {
                _loc_7 = 1;
            }
            if (this.vLimitZone)
            {
                _loc_12 = new BitmapData(_loc_6, _loc_7, this.vTransparent, _loc_11);
            }
            else
            {
                _loc_12 = new BitmapData(_loc_6, _loc_7, true, _loc_11);
            }
            var _loc_13:* = this.vMatrix.clone();
            _loc_13.scale(_loc_3 * _loc_8, _loc_4 * _loc_9);
            _loc_13.tx = (this.vMCVecto.x - _loc_5.x) * (_loc_3 * _loc_8);
            _loc_13.ty = (this.vMCVecto.y - _loc_5.y) * (_loc_4 * _loc_9);
            if (_loc_12.hasOwnProperty("drawWithQuality"))
            {
                Object(_loc_12).drawWithQuality(this.vMCVecto, _loc_13, this.vColorTransform, null, null, this.vSmoothing, this.vStageQuality);
            }
            else
            {
                _loc_12.draw(this.vMCVecto, _loc_13, this.vColorTransform, null, null, this.vSmoothing);
            }
            var _loc_14:* = false;
            if (!this.vLimitZone)
            {
                _loc_16 = _loc_12.getColorBoundsRect(4294967295, 0, false);
                if (_loc_16.width < _loc_6 || _loc_16.height < _loc_7)
                {
                    _loc_14 = true;
                    _loc_6 = _loc_16.width;
                    _loc_7 = _loc_16.height;
                    if (_loc_6 == 0)
                    {
                        _loc_6 = 1;
                    }
                    if (_loc_7 == 0)
                    {
                        _loc_7 = 1;
                    }
                    _loc_11 = 0;
                    if (!this.vTransparent)
                    {
                        _loc_11 = _loc_12.getPixel(_loc_16.x, _loc_16.y);
                    }
                    _loc_15 = new BitmapData(_loc_6, _loc_7, this.vTransparent, _loc_11);
                    _loc_15.copyPixels(_loc_12, _loc_16, new Point());
                }
                else if (!this.vTransparent)
                {
                    _loc_15 = new BitmapData(_loc_6, _loc_7, this.vTransparent, _loc_11);
                    _loc_15.copyPixels(_loc_12, _loc_12.rect, new Point());
                }
            }
            var _loc_17:* = false;
            if (this.vBDTab.length > 0 && this.vBitmapIndex > 0 && this.vBDTab[(this.vBitmapIndex - 1)] != null)
            {
                if (_loc_14 || _loc_15)
                {
                    if (_loc_15.compare(this.vBDTab[(this.vBitmapIndex - 1)].vBD) == 0)
                    {
                        _loc_17 = true;
                    }
                }
                else if (_loc_12.compare(this.vBDTab[(this.vBitmapIndex - 1)].vBD) == 0)
                {
                    _loc_17 = true;
                }
            }
            if (!_loc_17)
            {
                _loc_25 = new bitmapObject();
                if (_loc_14)
                {
                    _loc_25.vBD = _loc_15.clone();
                    _loc_25.vX = _loc_5.x + _loc_16.x * (1 / (this.vBitmapResolutionX * _loc_8)) - this.vMCVecto.x;
                    _loc_25.vY = _loc_5.y + _loc_16.y * (1 / (this.vBitmapResolutionY * _loc_9)) - this.vMCVecto.y;
                }
                else if (_loc_15)
                {
                    _loc_25.vBD = _loc_15.clone();
                    _loc_25.vX = _loc_5.x - this.vMCVecto.x;
                    _loc_25.vY = _loc_5.y - this.vMCVecto.y;
                }
                else
                {
                    _loc_25.vBD = _loc_12.clone();
                    _loc_25.vX = _loc_5.x - this.vMCVecto.x;
                    _loc_25.vY = _loc_5.y - this.vMCVecto.y;
                }
                _loc_25.vScaleX = 1 / (this.vBitmapResolutionX * _loc_8);
                _loc_25.vScaleY = 1 / (this.vBitmapResolutionY * _loc_9);
                this.vBDTab[this.vBitmapIndex] = _loc_25;
                var _loc_29:* = this;
                var _loc_30:* = this.vBitmapIndex + 1;
                _loc_29.vBitmapIndex = _loc_30;
            }
            if (_loc_12)
            {
                _loc_12.dispose();
            }
            if (_loc_15)
            {
                _loc_15.dispose();
            }
            _loc_12 = null;
            _loc_15 = null;
            this.vOrderTab[(this.vFrameStart - 1)] = this.vBitmapIndex - 1;
            var _loc_29:* = this;
            var _loc_30:* = this.vFrameStart + 1;
            _loc_29.vFrameStart = _loc_30;
            if (this.vMCLoader)
            {
                var _loc_29:* = this.vMCLoader;
                var _loc_30:* = _loc_29.vNBConvertedFrames + 1;
                _loc_29.vNBConvertedFrames = _loc_30;
            }
            if (vTrace && !_loc_17)
            {
                _loc_26 = _loc_6;
                _loc_21 = this.vMinSize;
                _loc_2 = 0;
                while (_loc_2 < this.vSizeTab.length)
                {
                    
                    _loc_21 = this.vSizeTab[_loc_2];
                    if (_loc_26 <= this.vSizeTab[_loc_2])
                    {
                        break;
                    }
                    _loc_2++;
                }
                _loc_27 = _loc_7;
                _loc_22 = this.vMinSize;
                _loc_2 = 0;
                while (_loc_2 < this.vSizeTab.length)
                {
                    
                    _loc_22 = this.vSizeTab[_loc_2];
                    if (_loc_7 <= this.vSizeTab[_loc_2])
                    {
                        break;
                    }
                    _loc_2++;
                }
                if (this.vTransparent)
                {
                    this.vBitmapMemoryList.push(_loc_21 * _loc_22 * 4);
                }
                else
                {
                    this.vBitmapMemoryList.push(_loc_21 * _loc_22 * 3);
                }
            }
            if (_loc_10 && this.vLoader == null)
            {
                this.vMCVecto = null;
                this.vMCVecto = _loc_10;
            }
            if (this.vFrameStart > this.vNBFrames)
            {
                if (this.vBDTab && this.vBDTab.length > 0)
                {
                    _loc_1 = 0;
                    while (_loc_1 < this.vBDTab.length)
                    {
                        
                        if (this.vBDTab[_loc_1] && this.vBDTab[_loc_1].vBD is BitmapData)
                        {
                            this.vBDTab[_loc_1].vBD.getPixel(0, 0);
                        }
                        _loc_1++;
                    }
                }
                if (this.vFirstFrame > 1)
                {
                    _loc_1 = 0;
                    while (_loc_1 < (this.vFirstFrame - 1))
                    {
                        
                        this.vOrderTab[_loc_1] = 0;
                        _loc_1++;
                    }
                }
                this.vFrameStart = this.vNBFrames;
                if (vTrace)
                {
                    _loc_28 = 0;
                    _loc_1 = 0;
                    while (_loc_1 < this.vBitmapMemoryList.length)
                    {
                        
                        _loc_28 = _loc_28 + this.vBitmapMemoryList[_loc_1];
                        _loc_1++;
                    }
                    if (this.vMCLoader)
                    {
                        _loc_29.vTotalMemory = _loc_29.vTotalMemory + _loc_28;
                    }
                    else if (this.vQueue)
                    {
                        this.vQueue.vTotalMemory = this.vQueue.vTotalMemory + _loc_28;
                    }
                    trace(" " + _loc_28 / 1024 + " ko ------> " + getQualifiedClassName(this.vMCVecto));
                }
                if (this.vMCVecto)
                {
                    this.vMCVecto = null;
                }
                if (this.vLoader)
                {
                    this.vLoader.unloadAndStop(false);
                }
                this.vLoader = null;
                this.vConversion = true;
                return true;
            }
            return false;
        }// end function

        final public function getBitmapObject(param1:Object) : bitmapObject
        {
            var _loc_2:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = null;
            if (this.vPuppet)
            {
                return new bitmapObject();
            }
            var _loc_3:* = -1;
            if (this.vBDTab == null || this.vBDTab.length == 0)
            {
                return null;
            }
            if (param1 is String)
            {
                _loc_4 = param1.split(",");
                _loc_3 = this.vLabelsDictionary[_loc_4[0]];
                if (_loc_3 < 0)
                {
                    _loc_3 = 0;
                }
                else if (_loc_3 >= this.vOrderTab.length)
                {
                    _loc_3 = this.vOrderTab.length - 1;
                }
            }
            else if (param1 is int)
            {
                _loc_3 = int(param1) - 1;
                if (_loc_3 < 0)
                {
                    _loc_3 = 0;
                }
                else if (_loc_3 >= this.vOrderTab.length)
                {
                    _loc_3 = this.vOrderTab.length - 1;
                }
            }
            if (_loc_3 > -1)
            {
                _loc_5 = this.vBDTab[this.vOrderTab[_loc_3]];
                return _loc_5;
            }
            return null;
        }// end function

        private function copyLoader(param1:LoaderInfo, param2:Function) : Loader
        {
            var _loc_3:* = param1.bytes;
            if (_loc_3.bytesAvailable == 0)
            {
                trace("Loader is empty : impossible to copy");
                return null;
            }
            this.vLoaderCallBack = param2;
            var _loc_4:* = new Loader();
            _loc_4.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onLoaderCopyComplete);
            var _loc_5:* = new LoaderContext(false, ApplicationDomain.currentDomain, null);
            _loc_5.allowCodeImport = true;
            _loc_4.loadBytes(_loc_3, _loc_5);
            return _loc_4;
        }// end function

        private function onLoaderCopyComplete(event:Event) : void
        {
            var _loc_2:* = null;
            event.currentTarget.removeEventListener(Event.COMPLETE, this.onLoaderCopyComplete);
            if (this.vLoaderCallBack != null)
            {
                _loc_2 = this.vLoaderCallBack;
                this.vLoaderCallBack = null;
                this._loc_2();
            }
            return;
        }// end function

        final public function destroyAll() : void
        {
            var _loc_1:* = 0;
            this.removeEventListener(Event.ENTER_FRAME, this.waitAFrame);
            this.removeEventListener(Event.ENTER_FRAME, this.waitAFrameToFinish);
            if (this.vBDTab && this.vBDTab.length > 0)
            {
                _loc_1 = 0;
                while (_loc_1 < this.vBDTab.length)
                {
                    
                    if (this.vBDTab[_loc_1] && this.vBDTab[_loc_1].vBD is BitmapData)
                    {
                        this.vBDTab[_loc_1].vBD.dispose();
                    }
                    this.vBDTab[_loc_1] = null;
                    _loc_1++;
                }
            }
            this.vBDTab = null;
            this.vOrderTab = null;
            this.vMCPuppetTab = null;
            this.vPuppetObject = null;
            if (this.vBitmapAS3Tab)
            {
                _loc_1 = 0;
                while (_loc_1 < this.vBitmapAS3Tab.length)
                {
                    
                    if (this.vBitmapAS3Tab[_loc_1])
                    {
                        this.vBitmapAS3Tab[_loc_1].destroyAll();
                    }
                    _loc_1++;
                }
            }
            this.vBitmapAS3Tab = null;
            this.vMCVecto = null;
            this.vCallBack = null;
            if (this.vLoader)
            {
                this.vLoader.unloadAndStop(false);
            }
            this.vLoader = null;
            this.vLabelsDictionary = null;
            this.vMCLoader = null;
            this.vQueue = null;
            this.vConversionCallBack = null;
            this.vMCPuppetTab = null;
            return;
        }// end function

    }
}
