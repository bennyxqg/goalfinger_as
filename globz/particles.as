package globz
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    public class particles extends Sprite
    {
        public var vGravity:Number;
        public var vNBByFrames:int;
        public var vNBFramesWait:int;
        public var vNBFramesDuration:int;
        public var vNBTotalFramesDuration:int;
        private var vCurrentFrame:int;
        private var vNBTotal:int;
        private var vNB:int;
        private var vRandomX:Number;
        private var vRandomY:Number;
        private var vSpeedXMax:Number;
        private var vSpeedXMin:Number;
        private var vSpeedYMax:Number;
        private var vSpeedYMin:Number;
        private var vParticleList:Vector.<particle>;
        private var vMCClass:Class;
        private var vMCLabel:String;
        private var vMCThis:MovieClip;
        private var vDamp:Number;
        private var vScale:Number;
        private var vScaleRandom:Number;
        private var vBlendMode:String;
        private var vRotation:Boolean;
        private var vRotationSaved:Number;
        public var vParent:DisplayObjectContainer;
        public var vActive:Boolean;
        private var vBitmapAS3:Vector.<mcToBitmapAS3>;
        private var vTargetObject:DisplayObjectContainer;
        private var vRandomSpeed:Boolean;
        private var vTotalFrames:int;
        private var vRandomFrames:Object;
        private var vScaleTime:Number;
        private static const power:uint = 1;

        public function particles() : void
        {
            this.mouseEnabled = false;
            this.mouseChildren = false;
            this.addEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStage);
            return;
        }// end function

        final public function startParticles(param1:DisplayObjectContainer, param2 = null, param3 = null, param4:int = 1, param5:int = 0, param6:int = 0, param7:Number = 0, param8:Number = 0, param9 = true, param10:Number = 1, param11:Number = 0.5, param12:Number = 0, param13:Number = 0, param14:Number = 0, param15:Number = 0, param16:Number = 0, param17:Number = 0.98, param18:String = "normal", param19 = false, param20:Boolean = true) : void
        {
            var _loc_22:* = null;
            var _loc_23:* = 0;
            var _loc_21:* = 1;
            this.vParent = param1;
            if (param2 is DisplayObjectContainer)
            {
                this.vTargetObject = param2 as DisplayObjectContainer;
                _loc_22 = this.vTargetObject.getBounds(param1);
                this.vRandomX = _loc_22.width;
                this.vRandomY = _loc_22.height;
            }
            else if (param2 is Rectangle)
            {
                this.vRandomX = Rectangle(param2).width;
                this.vRandomY = Rectangle(param2).height;
                this.x = Rectangle(param2).x + this.vRandomX * 0.5;
                this.y = Rectangle(param2).y + this.vRandomY * 0.5;
            }
            else if (param2 is Point)
            {
                this.x = Point(param2).x;
                this.y = Point(param2).y;
                this.vRandomX = 0;
                this.vRandomY = 0;
            }
            else
            {
                this.vRandomX = 0;
                this.vRandomY = 0;
            }
            this.vGravity = param12;
            this.vSpeedXMax = param13;
            this.vSpeedXMin = param14;
            this.vSpeedYMax = param15;
            this.vSpeedYMin = param16;
            this.vBitmapAS3 = new Vector.<mcToBitmapAS3>;
            if (param3 is mcToBitmapAS3)
            {
                if (!param3.vPuppet)
                {
                    this.vBitmapAS3[0] = param3;
                }
            }
            else if (param3 is Array)
            {
                _loc_23 = 0;
                while (_loc_23 < param3.length)
                {
                    
                    if (!param3[_loc_23].vPuppet)
                    {
                        this.vBitmapAS3[_loc_23] = param3[_loc_23] as mcToBitmapAS3;
                    }
                    _loc_23++;
                }
            }
            else
            {
                this.destroy();
                return;
            }
            if (this.vBitmapAS3.length == 0)
            {
                this.destroy();
                return;
            }
            this.vParticleList = new Vector.<particle>;
            this.vNBByFrames = param4;
            this.vNBTotal = param6;
            if (this.vNBByFrames <= 0)
            {
                this.vNBByFrames = 1;
                if (this.vNBTotal == 0)
                {
                    this.vNBTotal = 1;
                }
            }
            this.vNBFramesWait = param5;
            this.vCurrentFrame = param5;
            _loc_21 = this.vBitmapAS3[0].vBitmapResolutionX;
            this.vScale = param10 * (1 / _loc_21);
            this.vScaleRandom = param11;
            this.vDamp = param17;
            this.vNB = 0;
            this.vBlendMode = param18;
            if (param18 != "normal")
            {
                this.blendMode = param18;
            }
            if (param19 is Boolean)
            {
                this.vRotation = param19 as Boolean;
                this.vRotationSaved = 0;
            }
            else if (param19 is Number)
            {
                this.vRotationSaved = param19 as Number;
            }
            if (param7 <= 0)
            {
                this.vNBFramesDuration = -1;
            }
            else
            {
                this.vNBFramesDuration = param7;
            }
            this.vNBTotalFramesDuration = this.vNBFramesDuration;
            this.vRandomFrames = param9;
            this.vRandomSpeed = param20;
            this.vScaleTime = param8;
            this.vActive = true;
            return;
        }// end function

        public function stopParticles(param1:Boolean = true) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = 0;
            if (param1)
            {
                if (this.vParticleList != null && this.vParticleList.length > 0)
                {
                    _loc_3 = 0;
                    while (_loc_3 < this.vParticleList.length)
                    {
                        
                        _loc_2 = this.vParticleList[_loc_3];
                        if (_loc_2 != null)
                        {
                            this.removeChild(_loc_2);
                        }
                        this.vParticleList[_loc_3] = null;
                        _loc_3++;
                    }
                }
                this.vActive = false;
                this.vParticleList = new Vector.<particle>;
                this.vBitmapAS3 = new Vector.<mcToBitmapAS3>;
            }
            else
            {
                this.vNBTotal = 0;
            }
            return;
        }// end function

        public function update(param1:Number = 1, param2:Number = 1) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = NaN;
            var _loc_6:* = NaN;
            var _loc_7:* = NaN;
            var _loc_8:* = null;
            var _loc_9:* = NaN;
            var _loc_10:* = 0;
            var _loc_11:* = 0;
            var _loc_12:* = null;
            var _loc_13:* = 0;
            var _loc_14:* = NaN;
            var _loc_15:* = NaN;
            var _loc_16:* = null;
            var _loc_17:* = NaN;
            var _loc_18:* = NaN;
            var _loc_19:* = NaN;
            if (!this.vActive)
            {
                return;
            }
            if (param1 < 0.25)
            {
                param1 = 0.25;
            }
            else if (param1 > 4)
            {
                param1 = 4;
            }
            if (param2 < 0.1)
            {
                param2 = 0.1;
            }
            else if (param2 > 2)
            {
                param2 = 2;
            }
            var _loc_3:* = 0;
            while (_loc_3 < this.vParticleList.length)
            {
                
                _loc_8 = this.vParticleList[_loc_3];
                _loc_8.vNBFramesDuration = _loc_8.vNBFramesDuration - 1 * param1;
                if (_loc_8.vNBFramesDuration <= 0)
                {
                    _loc_8.vActive = false;
                    this.removeChild(_loc_8);
                    _loc_8.destroy();
                    this.vParticleList[_loc_3] = null;
                    this.vParticleList.splice(_loc_3, 1);
                    continue;
                }
                if (this.vScaleTime > 0)
                {
                    _loc_6 = _loc_8.vNBFramesDuration / _loc_8.vTotalFrames;
                    if (_loc_6 < this.vScaleTime)
                    {
                        _loc_6 = easeOut(_loc_6 / this.vScaleTime, 0, 1, 1);
                        _loc_7 = _loc_8.vScaleSaved * _loc_6;
                        _loc_8.scaleX = _loc_7;
                        _loc_8.scaleY = _loc_7;
                        _loc_8.vRadius = _loc_8.vRadiusSaved * _loc_7;
                        if (!this.vRotation)
                        {
                            _loc_5 = 45 / 180 * Math.PI;
                            _loc_8.vTX = (-_loc_8.vRadius) * Math.cos(_loc_8.vAngleStart + _loc_5);
                            _loc_8.vTY = (-_loc_8.vRadius) * Math.sin(_loc_8.vAngleStart + _loc_5);
                        }
                    }
                }
                if (this.vRotation)
                {
                    if (this.vRandomSpeed)
                    {
                        _loc_8.vAngleStart = _loc_8.vAngleStart + _loc_8.vAngle * param1;
                        _loc_5 = 45 / 180 * Math.PI;
                        _loc_8.vTX = (-_loc_8.vRadius) * Math.cos(_loc_8.vAngleStart + _loc_5);
                        _loc_8.vTY = (-_loc_8.vRadius) * Math.sin(_loc_8.vAngleStart + _loc_5);
                        _loc_8.rotation = _loc_8.vAngleStart * 180 / Math.PI;
                        _loc_8.vAngle = _loc_8.vAngle * this.vDamp;
                    }
                    else
                    {
                        _loc_8.vAngleStart = Math.atan2(_loc_8.vSpeedY, _loc_8.vSpeedX);
                        _loc_5 = 45 / 180 * Math.PI;
                        _loc_8.vTX = (-_loc_8.vRadius) * Math.cos(_loc_8.vAngleStart + _loc_5);
                        _loc_8.vTY = (-_loc_8.vRadius) * Math.sin(_loc_8.vAngleStart + _loc_5);
                        _loc_8.rotation = _loc_8.vAngleStart * 180 / Math.PI;
                        _loc_8.vAngle = _loc_8.vAngle * this.vDamp;
                    }
                }
                _loc_8.vX = _loc_8.vX + _loc_8.vSpeedX * param1;
                _loc_8.vY = _loc_8.vY + _loc_8.vSpeedY * param1;
                _loc_8.x = _loc_8.vX + _loc_8.vTX;
                _loc_8.y = _loc_8.vY + _loc_8.vTY;
                _loc_8.vSpeedX = _loc_8.vSpeedX * this.vDamp;
                _loc_8.vSpeedY = _loc_8.vSpeedY * this.vDamp + this.vGravity;
                _loc_3++;
            }
            if (this.vNB >= this.vNBTotal && this.vNBTotal != -1 && this.vParticleList.length == 0)
            {
                this.vActive = false;
                return;
            }
            if (param1 < 1)
            {
                var _loc_20:* = this;
                var _loc_21:* = this.vCurrentFrame + 1;
                _loc_20.vCurrentFrame = _loc_21;
            }
            else
            {
                this.vCurrentFrame = this.vCurrentFrame + 1 * param1;
            }
            if (this.vCurrentFrame >= this.vNBFramesWait && (this.vNB <= this.vNBTotal || this.vNBTotal < 0))
            {
                this.vCurrentFrame = 0;
                _loc_10 = Math.round(this.vNBByFrames * param2);
                _loc_11 = Math.round(this.vNBTotal * param2);
                _loc_3 = 0;
                while (_loc_3 < _loc_10)
                {
                    
                    var _loc_20:* = this;
                    var _loc_21:* = this.vNB + 1;
                    _loc_20.vNB = _loc_21;
                    if (this.vNBTotal < 0 || _loc_11 > 0 && this.vNB <= _loc_11)
                    {
                        _loc_12 = this.vBitmapAS3[int(this.vBitmapAS3.length * Math.random())];
                        _loc_13 = 1;
                        if (this.vRandomFrames is Boolean && this.vRandomFrames == true)
                        {
                            _loc_13 = int(_loc_12.vBDTab.length * Math.random()) + 1;
                        }
                        else if (this.vRandomFrames is Number)
                        {
                            _loc_13 = this.vRandomFrames;
                        }
                        _loc_4 = _loc_12.getBitmapObject(_loc_13);
                        _loc_8 = new particle(_loc_4.vBD);
                        this.vParticleList[this.vParticleList.length] = _loc_8;
                        _loc_8.vFrame = _loc_13;
                        _loc_8.vBitmapAS3 = _loc_12;
                        if (this.vTargetObject)
                        {
                            _loc_16 = this.vTargetObject.getBounds(this.vParent);
                            this.vRandomX = _loc_16.width;
                            this.vRandomY = _loc_16.height;
                            _loc_14 = Math.random() * this.vRandomX - this.vRandomX * 0.5;
                            _loc_15 = Math.random() * this.vRandomY - this.vRandomY * 0.5;
                            _loc_8.vX = _loc_16.x + this.vRandomX * 0.5 + _loc_14;
                            _loc_8.vY = _loc_16.y + this.vRandomY * 0.5 + _loc_15;
                        }
                        else
                        {
                            _loc_14 = Math.random() * this.vRandomX - this.vRandomX * 0.5;
                            _loc_15 = Math.random() * this.vRandomY - this.vRandomY * 0.5;
                            _loc_8.vX = _loc_14;
                            _loc_8.vY = _loc_15;
                        }
                        if (this.vRandomSpeed)
                        {
                            _loc_8.vSpeedX = Math.random() * (this.vSpeedXMax - this.vSpeedXMin) + this.vSpeedXMin;
                            _loc_8.vSpeedY = Math.random() * (this.vSpeedYMax - this.vSpeedYMin) + this.vSpeedYMin;
                        }
                        else
                        {
                            if (this.vRandomX > 0)
                            {
                                _loc_17 = (_loc_14 - (-this.vRandomX) * 0.5) / this.vRandomX;
                                _loc_8.vSpeedX = _loc_17 * (this.vSpeedXMax - this.vSpeedXMin) + this.vSpeedXMin;
                            }
                            else
                            {
                                _loc_8.vSpeedX = Math.random() * (this.vSpeedXMax - this.vSpeedXMin) + this.vSpeedXMin;
                            }
                            if (this.vRandomY > 0)
                            {
                                _loc_18 = (_loc_15 - (-this.vRandomY) * 0.5) / this.vRandomY;
                                _loc_8.vSpeedY = _loc_18 * (this.vSpeedYMax - this.vSpeedYMin) + this.vSpeedYMin;
                            }
                            else
                            {
                                _loc_8.vSpeedY = Math.random() * (this.vSpeedYMax - this.vSpeedYMin) + this.vSpeedYMin;
                            }
                        }
                        var _loc_20:* = this.vScale * (1 - Math.random() * this.vScaleRandom);
                        _loc_8.vScaleSaved = this.vScale * (1 - Math.random() * this.vScaleRandom);
                        _loc_8.scaleY = _loc_20;
                        _loc_8.scaleX = _loc_20;
                        _loc_8.vRX = _loc_4.vX;
                        _loc_8.vRY = _loc_4.vY;
                        if (this.vRotation)
                        {
                            _loc_19 = Math.sqrt(_loc_8.vSpeedX * _loc_8.vSpeedX + _loc_8.vSpeedY * _loc_8.vSpeedY);
                            if (this.vRandomSpeed)
                            {
                                _loc_8.vAngleStart = Math.random() * 360 / 180 * Math.PI;
                                _loc_8.vAngle = (Math.random() * 10 < 5 ? (1) : (-1)) * (Math.random() * _loc_19) / 180 * Math.PI;
                            }
                            else
                            {
                                _loc_8.vAngleStart = Math.atan2(_loc_8.vSpeedY, _loc_8.vSpeedX);
                                _loc_8.vAngle = 0;
                            }
                            _loc_8.vRadiusSaved = Math.sqrt(_loc_4.vX * _loc_4.vX + _loc_4.vY * _loc_4.vY) / this.vScale;
                            _loc_8.vRadius = _loc_8.vRadiusSaved * _loc_8.vScaleSaved;
                            _loc_8.vTX = (-_loc_8.vRadius) * Math.cos(_loc_8.vAngleStart + 45 / 180 * Math.PI);
                            _loc_8.vTY = (-_loc_8.vRadius) * Math.sin(_loc_8.vAngleStart + 45 / 180 * Math.PI);
                            _loc_8.rotation = _loc_8.vAngleStart * 180 / Math.PI;
                        }
                        else
                        {
                            _loc_8.vAngleStart = this.vRotationSaved / 180 * Math.PI;
                            _loc_8.vRadiusSaved = Math.sqrt(_loc_4.vX * _loc_4.vX + _loc_4.vY * _loc_4.vY) / this.vScale;
                            _loc_8.vRadius = _loc_8.vRadiusSaved * _loc_8.vScaleSaved;
                            _loc_8.vTX = (-_loc_8.vRadius) * Math.cos(_loc_8.vAngleStart + 45 / 180 * Math.PI);
                            _loc_8.vTY = (-_loc_8.vRadius) * Math.sin(_loc_8.vAngleStart + 45 / 180 * Math.PI);
                            _loc_8.rotation = _loc_8.vAngleStart * 180 / Math.PI;
                        }
                        if (this.vNBFramesDuration == -1)
                        {
                            var _loc_20:* = _loc_12.vBDTab.length;
                            _loc_8.vNBFramesDuration = _loc_12.vBDTab.length;
                            _loc_8.vTotalFrames = _loc_20;
                        }
                        else
                        {
                            _loc_8.vNBFramesDuration = this.vNBFramesDuration;
                            _loc_8.vTotalFrames = this.vNBFramesDuration;
                        }
                        _loc_8.x = _loc_8.vX + _loc_8.vTX;
                        _loc_8.y = _loc_8.vY + _loc_8.vTY;
                        this.addChild(_loc_8);
                    }
                    _loc_3++;
                }
            }
            return;
        }// end function

        final public function updateSpeeds(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0) : void
        {
            this.vSpeedXMax = param1;
            this.vSpeedXMin = param2;
            this.vSpeedYMax = param3;
            this.vSpeedYMin = param4;
            return;
        }// end function

        final public function updateTarget(param1:DisplayObjectContainer = null, param2 = null) : void
        {
            var _loc_3:* = null;
            if (param1)
            {
                this.vParent = param1;
            }
            if (param2 is DisplayObjectContainer)
            {
                this.vTargetObject = param2 as DisplayObjectContainer;
                _loc_3 = this.vTargetObject.getBounds(param1);
                this.vRandomX = _loc_3.width;
                this.vRandomY = _loc_3.height;
            }
            else if (param2 is Rectangle)
            {
                this.vRandomX = Rectangle(param2).width;
                this.vRandomY = Rectangle(param2).height;
                this.x = Rectangle(param2).x + this.vRandomX * 0.5;
                this.y = Rectangle(param2).y + this.vRandomY * 0.5;
            }
            else if (param2 is Point)
            {
                this.x = Point(param2).x;
                this.y = Point(param2).y;
                this.vRandomX = 0;
                this.vRandomY = 0;
            }
            else
            {
                this.vRandomX = 0;
                this.vRandomY = 0;
            }
            return;
        }// end function

        private function removedFromStage(event:Event) : void
        {
            this.destroy();
            return;
        }// end function

        final public function destroy() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = 0;
            this.removeEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStage);
            this.vActive = false;
            if (this.vParticleList != null && this.vParticleList.length > 0)
            {
                _loc_2 = 0;
                while (_loc_2 < this.vParticleList.length)
                {
                    
                    _loc_1 = this.vParticleList[_loc_2];
                    if (_loc_1 != null)
                    {
                        _loc_1.destroy();
                        this.removeChild(_loc_1);
                    }
                    this.vParticleList[_loc_2] = null;
                    _loc_2++;
                }
            }
            this.vParticleList = new Vector.<particle>;
            this.vMCClass = null;
            this.blendMode = "normal";
            this.vTargetObject = null;
            this.vParent = null;
            this.vNBTotal = 0;
            return;
        }// end function

        private static function easeIn(param1:Number, param2:Number, param3:Number, param4:Number) : Number
        {
            var _loc_5:* = param1 / param4;
            param1 = param1 / param4;
            return param3 * _loc_5 * param1 + param2;
        }// end function

        private static function easeOut(param1:Number, param2:Number, param3:Number, param4:Number) : Number
        {
            var _loc_5:* = param1 / param4;
            param1 = param1 / param4;
            return (-param3) * _loc_5 * (param1 - 2) + param2;
        }// end function

        private static function easeInOut(param1:Number, param2:Number, param3:Number, param4:Number) : Number
        {
            var _loc_5:* = param1 / (param4 * 0.5);
            param1 = param1 / (param4 * 0.5);
            if (_loc_5 < 1)
            {
                return param3 * 0.5 * param1 * param1 + param2;
            }
            param1 = (param1 - 1);
            return (-param3) * 0.5 * (param1 * (param1 - 2) - 1) + param2;
        }// end function

    }
}

import __AS3__.vec.*;

import flash.display.*;

import flash.events.*;

import flash.geom.*;

class particle extends Bitmap
{
    public var vGravity:Number;
    public var vNBByFrames:int;
    public var vNBFramesWait:int;
    public var vNBFramesDuration:Number;
    public var vCurrentFrame:int;
    public var vNBTotal:int;
    public var vNB:int;
    public var vRandomX:Number;
    public var vRandomY:Number;
    public var vSpeedX:Number;
    public var vSpeedY:Number;
    public var vSpeedXMax:Number;
    public var vSpeedXMin:Number;
    public var vSpeedYMax:Number;
    public var vSpeedYMin:Number;
    public var vMCTab:Vector.<Bitmap>;
    public var vMCClass:Class;
    public var vMCLabel:String;
    public var vMCThis:MovieClip;
    public var vDamp:Number;
    public var vScale:Number;
    public var vScaleRandom:Number;
    public var vScaleSaved:Number;
    public var vScaleFactor:Number;
    public var vBlendMode:String;
    public var vRotation:Boolean;
    public var vParent:DisplayObjectContainer;
    public var vActive:Boolean;
    public var vBitmapAS3:mcToBitmapAS3;
    public var vBitmapData:BitmapData;
    public var vFrame:int = 0;
    public var vTotalFrames:int;
    public var vX:Number;
    public var vY:Number;
    public var vTX:Number;
    public var vTY:Number;
    public var vRadius:Number;
    public var vRadiusSaved:Number;
    public var vAngleStart:Number;
    public var vAngle:Number;
    public var vRX:Number;
    public var vRY:Number;

    function particle(param1:BitmapData) : void
    {
        this.bitmapData = param1;
        this.vActive = true;
        return;
    }// end function

    public function destroy() : void
    {
        this.bitmapData = null;
        this.vBitmapAS3 = null;
        return;
    }// end function

}

