package 
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.events.*;
    import globz.*;

    dynamic public class PersoGrafMain extends MCAnimation
    {
        public var vPersoType:String;
        public var posX:Number;
        public var posY:Number;
        public var speed:Number;
        public var tabMC:Vector.<MovieClip>;
        public var vTexture:BitmapData;
        public var v3DHead:ExtrudeObject;
        public var v3D:Boolean;
        public var vOrientation:Number;
        public var vSWFImages:Object;
        public var vLoader:Loader;
        public var vBCHead:bitmapClip;

        public function PersoGrafMain()
        {
            addFrameScript(0, this.frame1, 32, this.frame33, 37, this.frame38, 63, this.frame64, 87, this.frame88, 132, this.frame133, 156, this.frame157, 179, this.frame180);
            return;
        }// end function

        public function getType(param1:String) : String
        {
            return param1.charAt(1);
        }// end function

        public function getHeadFrame(param1:String) : int
        {
            if (param1 == "PA_001")
            {
                return 1;
            }
            if (param1 == "PA_002")
            {
                return 2;
            }
            if (param1 == "PA_003")
            {
                return 3;
            }
            if (param1 == "PA_004")
            {
                return 4;
            }
            if (param1 == "PA_005")
            {
                return 5;
            }
            if (param1 == "PA_006")
            {
                return 6;
            }
            if (param1 == "PA_007")
            {
                return 7;
            }
            if (param1 == "PA_008")
            {
                return 8;
            }
            if (param1 == "PA_009")
            {
                return 9;
            }
            if (param1 == "PA_010")
            {
                return 10;
            }
            if (param1 == "PA_011")
            {
                return 11;
            }
            if (param1 == "PA_012")
            {
                return 12;
            }
            if (param1 == "PA_013")
            {
                return 13;
            }
            if (param1 == "PA_014")
            {
                return 14;
            }
            if (param1 == "PA_015")
            {
                return 15;
            }
            if (param1 == "PB_001")
            {
                return 1;
            }
            if (param1 == "PB_002")
            {
                return 2;
            }
            if (param1 == "PB_003")
            {
                return 3;
            }
            if (param1 == "PB_004")
            {
                return 4;
            }
            if (param1 == "PB_005")
            {
                return 5;
            }
            if (param1 == "PB_006")
            {
                return 6;
            }
            if (param1 == "PB_007")
            {
                return 7;
            }
            if (param1 == "PB_008")
            {
                return 8;
            }
            if (param1 == "PB_009")
            {
                return 9;
            }
            if (param1 == "PB_010")
            {
                return 10;
            }
            if (param1 == "PB_011")
            {
                return 11;
            }
            if (param1 == "PB_012")
            {
                return 12;
            }
            if (param1 == "PB_013")
            {
                return 13;
            }
            if (param1 == "PB_014")
            {
                return 14;
            }
            if (param1 == "PB_015")
            {
                return 15;
            }
            if (param1 == "PC_001")
            {
                return 1;
            }
            if (param1 == "PC_002")
            {
                return 2;
            }
            if (param1 == "PC_003")
            {
                return 3;
            }
            if (param1 == "PC_004")
            {
                return 4;
            }
            if (param1 == "PC_005")
            {
                return 5;
            }
            if (param1 == "PC_006")
            {
                return 6;
            }
            if (param1 == "PC_007")
            {
                return 7;
            }
            if (param1 == "PC_008")
            {
                return 8;
            }
            if (param1 == "PC_009")
            {
                return 9;
            }
            if (param1 == "PC_010")
            {
                return 10;
            }
            if (param1 == "PC_011")
            {
                return 11;
            }
            if (param1 == "PC_012")
            {
                return 12;
            }
            if (param1 == "PC_013")
            {
                return 13;
            }
            if (param1 == "PC_014")
            {
                return 14;
            }
            if (param1 == "PC_015")
            {
                return 15;
            }
            if (param1 == "PD_001")
            {
                return 1;
            }
            return 1;
        }// end function

        public function getSkinFrame(param1:String) : int
        {
            if (param1 == "PA_001")
            {
                return 1;
            }
            if (param1 == "PA_002")
            {
                return 2;
            }
            if (param1 == "PA_003")
            {
                return 3;
            }
            if (param1 == "PA_004")
            {
                return 4;
            }
            if (param1 == "PA_005")
            {
                return 5;
            }
            if (param1 == "PA_006")
            {
                return 6;
            }
            if (param1 == "PA_007")
            {
                return 7;
            }
            if (param1 == "PA_008")
            {
                return 8;
            }
            if (param1 == "PA_009")
            {
                return 9;
            }
            if (param1 == "PA_010")
            {
                return 10;
            }
            if (param1 == "PA_011")
            {
                return 11;
            }
            if (param1 == "PA_012")
            {
                return 12;
            }
            if (param1 == "PA_013")
            {
                return 13;
            }
            if (param1 == "PA_014")
            {
                return 14;
            }
            if (param1 == "PA_015")
            {
                return 15;
            }
            if (param1 == "PB_001")
            {
                return 16;
            }
            if (param1 == "PB_002")
            {
                return 17;
            }
            if (param1 == "PB_003")
            {
                return 18;
            }
            if (param1 == "PB_004")
            {
                return 19;
            }
            if (param1 == "PB_005")
            {
                return 20;
            }
            if (param1 == "PB_006")
            {
                return 21;
            }
            if (param1 == "PB_007")
            {
                return 22;
            }
            if (param1 == "PB_008")
            {
                return 23;
            }
            if (param1 == "PB_009")
            {
                return 24;
            }
            if (param1 == "PB_010")
            {
                return 25;
            }
            if (param1 == "PB_011")
            {
                return 26;
            }
            if (param1 == "PB_012")
            {
                return 27;
            }
            if (param1 == "PB_013")
            {
                return 28;
            }
            if (param1 == "PB_014")
            {
                return 29;
            }
            if (param1 == "PB_015")
            {
                return 30;
            }
            if (param1 == "PC_001")
            {
                return 31;
            }
            if (param1 == "PC_002")
            {
                return 32;
            }
            if (param1 == "PC_003")
            {
                return 33;
            }
            if (param1 == "PC_004")
            {
                return 34;
            }
            if (param1 == "PC_005")
            {
                return 35;
            }
            if (param1 == "PC_006")
            {
                return 36;
            }
            if (param1 == "PC_007")
            {
                return 37;
            }
            if (param1 == "PC_008")
            {
                return 38;
            }
            if (param1 == "PC_009")
            {
                return 39;
            }
            if (param1 == "PC_010")
            {
                return 40;
            }
            if (param1 == "PC_011")
            {
                return 41;
            }
            if (param1 == "PC_012")
            {
                return 42;
            }
            if (param1 == "PC_013")
            {
                return 43;
            }
            if (param1 == "PC_014")
            {
                return 44;
            }
            if (param1 == "PC_015")
            {
                return 45;
            }
            if (param1 == "PD_001")
            {
                return 46;
            }
            return 1;
        }// end function

        public function getShirtFrame(param1:String) : int
        {
            if (param1 == "SA_001")
            {
                return 1;
            }
            if (param1 == "SA_002")
            {
                return 2;
            }
            if (param1 == "SA_003")
            {
                return 3;
            }
            if (param1 == "SA_004")
            {
                return 4;
            }
            if (param1 == "SA_005")
            {
                return 5;
            }
            if (param1 == "SA_006")
            {
                return 6;
            }
            if (param1 == "SB_001")
            {
                return 7;
            }
            if (param1 == "SB_002")
            {
                return 8;
            }
            if (param1 == "SB_003")
            {
                return 9;
            }
            if (param1 == "SB_004")
            {
                return 10;
            }
            if (param1 == "SB_005")
            {
                return 11;
            }
            if (param1 == "SB_006")
            {
                return 12;
            }
            if (param1 == "SB_007")
            {
                return 13;
            }
            if (param1 == "SB_008")
            {
                return 14;
            }
            if (param1 == "SB_009")
            {
                return 15;
            }
            if (param1 == "SB_010")
            {
                return 16;
            }
            if (param1 == "SB_011")
            {
                return 17;
            }
            if (param1 == "SB_012")
            {
                return 18;
            }
            if (param1 == "SB_013")
            {
                return 19;
            }
            if (param1 == "SB_014")
            {
                return 20;
            }
            if (param1 == "SB_015")
            {
                return 21;
            }
            if (param1 == "SB_016")
            {
                return 22;
            }
            if (param1 == "SB_017")
            {
                return 23;
            }
            if (param1 == "SB_018")
            {
                return 24;
            }
            if (param1 == "SB_019")
            {
                return 25;
            }
            if (param1 == "SB_020")
            {
                return 26;
            }
            if (param1 == "SB_021")
            {
                return 27;
            }
            if (param1 == "SB_022")
            {
                return 28;
            }
            if (param1 == "SB_023")
            {
                return 29;
            }
            if (param1 == "SB_024")
            {
                return 30;
            }
            if (param1 == "SB_025")
            {
                return 49;
            }
            if (param1 == "SB_026")
            {
                return 47;
            }
            if (param1 == "SB_027")
            {
                return 48;
            }
            if (param1 == "SC_001")
            {
                return 34;
            }
            if (param1 == "SC_002")
            {
                return 39;
            }
            if (param1 == "SC_003")
            {
                return 33;
            }
            if (param1 == "SC_004")
            {
                return 31;
            }
            if (param1 == "SC_005")
            {
                return 35;
            }
            if (param1 == "SC_006")
            {
                return 36;
            }
            if (param1 == "SC_007")
            {
                return 37;
            }
            if (param1 == "SC_008")
            {
                return 38;
            }
            if (param1 == "SC_009")
            {
                return 32;
            }
            if (param1 == "SC_010")
            {
                return 44;
            }
            if (param1 == "SC_011")
            {
                return 43;
            }
            if (param1 == "SC_012")
            {
                return 42;
            }
            if (param1 == "SC_013")
            {
                return 41;
            }
            if (param1 == "SC_014")
            {
                return 40;
            }
            if (param1 == "SC_015")
            {
                return 45;
            }
            if (param1 == "SC_016")
            {
                return 50;
            }
            if (param1 == "SC_017")
            {
                return 51;
            }
            if (param1 == "SD_001")
            {
                return 46;
            }
            return 1;
        }// end function

        public function init() : void
        {
            var _loc_2:* = null;
            this.posX = x;
            this.posY = y;
            this.speed = 0;
            this.tabMC = new Vector.<MovieClip>;
            var _loc_1:* = 0;
            while (_loc_1 < mcPerso.numChildren)
            {
                
                _loc_2 = mcPerso.getChildAt(_loc_1);
                if (_loc_2 is MovieClip)
                {
                    this.tabMC.push(MovieClip(_loc_2));
                }
                _loc_1++;
            }
            mcPerso.mcTriangles1.mask = mcPerso.mcBody1;
            mcPerso.mcTriangles2.mask = mcPerso.mcBody2;
            return;
        }// end function

        public function initFollow() : void
        {
            this.init();
            this.addEventListener(Event.ENTER_FRAME, this.loop);
            return;
        }// end function

        public function loop(event:Event)
        {
            this.follow(stage.mouseX, stage.mouseY);
            return;
        }// end function

        public function follow(param1:Number = 0, param2:Number = 0) : void
        {
            this.speed = 0;
            var _loc_3:* = param1 - this.posX;
            var _loc_4:* = param2 - this.posY;
            if (Math.abs(_loc_3) < 5 && Math.abs(_loc_4) < 5)
            {
                return;
            }
            var _loc_5:* = Math.sqrt(_loc_3 * _loc_3 + _loc_4 * _loc_4);
            if (Math.sqrt(_loc_3 * _loc_3 + _loc_4 * _loc_4) == 0)
            {
                _loc_5 = 1e-006;
            }
            this.posX = this.posX + this.speed * _loc_3 / _loc_5;
            this.posY = this.posY + this.speed * _loc_4 / _loc_5;
            x = this.posX;
            y = this.posY;
            var _loc_6:* = Math.atan2(_loc_4, _loc_3) * 180 / Math.PI - 90;
            var _loc_7:* = 0;
            while (_loc_7 < this.tabMC.length)
            {
                
                this.tabMC[_loc_7].rotation = _loc_6;
                _loc_7++;
            }
            if (this.v3D && this.v3DHead)
            {
                this.v3DHead.AbsRotateSphere(0, _loc_6 + 180, 0);
            }
            mcPerso.mcTriangles1.mcT1.triangle(mcPerso.mcBody1.a1, mcPerso.mcBody1.a2, mcPerso.mcBody2.b1);
            mcPerso.mcTriangles1.mcT2.triangle(mcPerso.mcBody1.a3, mcPerso.mcBody1.a4, mcPerso.mcBody2.b3);
            mcPerso.mcTriangles2.mcT1.triangle(mcPerso.mcBody1.a1, mcPerso.mcBody1.a2, mcPerso.mcBody2.b1);
            mcPerso.mcTriangles2.mcT2.triangle(mcPerso.mcBody1.a3, mcPerso.mcBody1.a4, mcPerso.mcBody2.b3);
            return;
        }// end function

        public function setOrientation(param1:Number) : void
        {
            var _loc_2:* = param1;
            this.vOrientation = _loc_2;
            var _loc_3:* = 0;
            while (_loc_3 < this.tabMC.length)
            {
                
                this.tabMC[_loc_3].rotation = _loc_2;
                _loc_3++;
            }
            if (this.v3D && this.v3DHead)
            {
                this.v3DHead.AbsRotateSphere(0, _loc_2, 0);
            }
            mcPerso.mcTriangles1.mcT1.triangle(mcPerso.mcBody1.a1, mcPerso.mcBody1.a2, mcPerso.mcBody2.b1);
            mcPerso.mcTriangles1.mcT2.triangle(mcPerso.mcBody1.a3, mcPerso.mcBody1.a4, mcPerso.mcBody2.b3);
            mcPerso.mcTriangles2.mcT1.triangle(mcPerso.mcBody1.a1, mcPerso.mcBody1.a2, mcPerso.mcBody2.b1);
            mcPerso.mcTriangles2.mcT2.triangle(mcPerso.mcBody1.a3, mcPerso.mcBody1.a4, mcPerso.mcBody2.b3);
            return;
        }// end function

        public function setRealHead(param1:int) : void
        {
            var _loc_2:* = null;
            switch(this.vPersoType)
            {
                case "A":
                {
                    break;
                }
                case "B":
                {
                    break;
                }
                case "C":
                {
                    break;
                }
                case "D":
                {
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (this.vBCHead != null && this.vBCHead.parent)
            {
            }
            switch(this.vPersoType)
            {
                case "A":
                {
                    break;
                }
                case "B":
                {
                    break;
                }
                case "C":
                {
                    break;
                }
                case "D":
                {
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (this.v3DHead != null)
            {
            }
            switch(this.vPersoType)
            {
                case "A":
                {
                    break;
                }
                case "B":
                {
                    break;
                }
                case "C":
                {
                    break;
                }
                case "D":
                {
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (this.vBCHead != null)
            {
            }
            else
            {
            }
            return;
        }// end function

        public function setSkin(param1:int) : void
        {
            mcPerso.mcArm2.gotoAndStop(param1);
            mcPerso.mcArm3.gotoAndStop(param1);
            mcPerso.mcArm4.gotoAndStop(param1);
            mcPerso.mcLeg2.gotoAndStop(param1);
            return;
        }// end function

        public function setLook(param1:int) : void
        {
            mcPerso.mcArm1.gotoAndStop(param1);
            mcPerso.mcBody3.gotoAndStop(param1);
            mcPerso.mcLeg1.gotoAndStop(param1);
            mcPerso.mcLeg3.gotoAndStop(param1);
            mcPerso.mcLeg4.gotoAndStop(param1);
            mcPerso.mcTriangles1.mcTshirt.gotoAndStop(param1);
            mcPerso.mcTriangles1.mcT1.mcGraf.gotoAndStop(param1);
            mcPerso.mcTriangles1.mcT2.mcGraf.gotoAndStop(param1);
            mcPerso.mcTriangles2.mcTshirt.gotoAndStop(param1);
            mcPerso.mcTriangles2.mcT1.mcGraf.gotoAndStop(param1);
            mcPerso.mcTriangles2.mcT2.mcGraf.gotoAndStop(param1);
            return;
        }// end function

        public function setGraf(param1:String, param2:String, param3:Boolean = false, param4:Object = null, param5:Loader = null) : void
        {
            this.vPersoType = this.getType(param1);
            this.v3D = param3;
            this.vLoader = param5;
            if (param4 != null)
            {
                mcPerso.mcHead.visible = false;
                this.vSWFImages = param4;
                if (this.vBCHead != null)
                {
                    this.vBCHead.destroy();
                }
                this.vBCHead = null;
                this.vBCHead = new bitmapClip(this.vSWFImages["head_" + this.vPersoType]);
                this.vBCHead.transform.matrix = mcPerso.mcHead.transform.matrix;
                mcPerso.addChild(this.vBCHead);
            }
            this.setRealHead(this.getHeadFrame(param1));
            this.setSkin(this.getSkinFrame(param1));
            this.setLook(this.getShirtFrame(param2));
            return;
        }// end function

        public function setHead(param1:String, param2:Object = null, param3:Loader = null) : void
        {
            var _loc_4:* = null;
            this.vPersoType = this.getType(param1);
            this.vLoader = param3;
            if (param2 != null)
            {
                mcPerso.mcHead.visible = false;
                this.vSWFImages = param2;
                if (this.vBCHead != null)
                {
                    this.vBCHead.destroy();
                }
                this.vBCHead = null;
                trace("head_" + this.vPersoType);
                this.vBCHead = new bitmapClip(this.vSWFImages["head_" + this.vPersoType]);
                trace("head");
                this.vBCHead.transform.matrix = mcPerso.mcHead.transform.matrix;
                mcPerso.addChild(this.vBCHead);
            }
            this.setRealHead(this.getHeadFrame(param1));
            this.setSkin(this.getSkinFrame(param1));
            mcPerso.mcHead.y = 0;
            if (this.vBCHead != null)
            {
                this.vBCHead.y = 0;
            }
            var _loc_5:* = 0;
            while (_loc_5 < mcPerso.numChildren)
            {
                
                _loc_4 = mcPerso.getChildAt(_loc_5);
                if (_loc_4 != mcPerso.mcHead && _loc_4 != this.vBCHead)
                {
                    _loc_4.visible = false;
                }
                _loc_5++;
            }
            return;
        }// end function

        public function destroy() : void
        {
            if (this.v3DHead != null)
            {
                this.v3DHead.destroy();
            }
            this.v3DHead = null;
            if (this.vBCHead != null)
            {
                this.vBCHead.destroy();
            }
            this.vBCHead = null;
            this.vSWFImages = null;
            this.vLoader = null;
            return;
        }// end function

        function frame1()
        {
            stop();
            this.vOrientation = 0;
            return;
        }// end function

        function frame33()
        {
            checkEnd("show");
            return;
        }// end function

        function frame38()
        {
            checkEnd("shown");
            return;
        }// end function

        function frame64()
        {
            checkEnd("fall_up");
            return;
        }// end function

        function frame88()
        {
            checkEnd("fall_down");
            return;
        }// end function

        function frame133()
        {
            checkEnd("win");
            return;
        }// end function

        function frame157()
        {
            checkEnd("lose");
            return;
        }// end function

        function frame180()
        {
            checkEnd("lose");
            return;
        }// end function

    }
}
