package sparks
{
    import gbl.*;

    public class Sparks_Char extends Object
    {
        public var vUser:Sparks_User;
        public var vCharId:String;
        public var vName:String;
        private var vForce:int = 0;
        private var vSpeed:int = 0;
        private var vVitality:int = 0;
        public var vEnergy:int = 0;
        public var vEnergyTS:Number = 0;
        public var vHitPointsMax:int = 3;
        public var vHitPointsRegen:int = 2;
        public var vStatus:String = "";
        public var vJob:Object;
        public var vPosition:int = 0;
        public var vNbUpgrades:int = 0;
        public var vCategory:String;
        public var vCardPrice:String;
        public var vCardNb:int;
        public static var vEnergyRecoveryPace:int = 20;
        public static var vEnergyThreshold:int = 20;

        public function Sparks_Char(param1:Sparks_User, param2:String, param3:String)
        {
            this.vUser = param1;
            this.vCharId = param2;
            this.vName = param3;
            return;
        }// end function

        public function toString() : String
        {
            return "[Sparks_Char vCharId=" + this.vCharId + " vName=" + this.vName + " Force=" + this.vForce + " Speed=" + this.vSpeed + " Vitality=" + this.vVitality + " vPosition=" + this.vPosition + "]";
        }// end function

        public function isActive() : Boolean
        {
            if (this.vStatus == "active")
            {
                return true;
            }
            return false;
        }// end function

        public function canPlay() : Boolean
        {
            if (this.getEnergy() < vEnergyThreshold)
            {
                return false;
            }
            return true;
        }// end function

        public function setForce(param1:int) : void
        {
            this.vForce = param1;
            return;
        }// end function

        public function setSpeed(param1:int) : void
        {
            this.vSpeed = param1;
            return;
        }// end function

        public function setVitality(param1:int) : void
        {
            this.vVitality = param1;
            this.vHitPointsMax = Sparks_Char.getHitPointsMax(this.vVitality);
            this.vHitPointsRegen = Sparks_Char.getHitPointsRegen(this.vVitality);
            return;
        }// end function

        public function getForce() : int
        {
            return this.vForce;
        }// end function

        public function getSpeed() : int
        {
            return this.vSpeed;
        }// end function

        public function getVitality() : int
        {
            return this.vVitality;
        }// end function

        public function canUpgrade() : Boolean
        {
            var _loc_1:* = 1;
            while (_loc_1 <= 3)
            {
                
                if (this.canUpgradeAttribute(_loc_1))
                {
                    return true;
                }
                _loc_1++;
            }
            return false;
        }// end function

        public function canUpgradeAttribute(param1:int) : Boolean
        {
            var _loc_3:* = null;
            if (this.vNbUpgrades >= 10)
            {
                return false;
            }
            if (Global.vServer == null)
            {
                return false;
            }
            var _loc_2:* = Global.vServer.vUpgradePrices[this.getForce() + this.getSpeed() + this.getVitality()];
            if (param1 == 1)
            {
                _loc_3 = "AF";
            }
            else if (param1 == 2)
            {
                _loc_3 = "AS";
            }
            else if (param1 == 3)
            {
                _loc_3 = "AV";
            }
            var _loc_4:* = Global.vServer.vUser.getCards(_loc_3);
            if (_loc_2 > _loc_4)
            {
                return false;
            }
            if (param1 == 1 && this.getForce() == 10)
            {
                return false;
            }
            if (param1 == 2 && this.getSpeed() == 10)
            {
                return false;
            }
            if (param1 == 3 && this.getVitality() == 10)
            {
                return false;
            }
            return true;
        }// end function

        public function setNewEnergy(param1:int, param2:Number) : void
        {
            this.vEnergy = param1;
            this.vEnergyTS = Math.round(param2 / 1000);
            return;
        }// end function

        public function getEnergy() : int
        {
            if (Global.vServer == null)
            {
                return 100;
            }
            var _loc_1:* = Global.vServer.getTimeFrom(this.vEnergyTS);
            var _loc_2:* = this.vEnergy + Math.floor(_loc_1 / Sparks_Char.vEnergyRecoveryPace);
            if (_loc_2 > 100)
            {
                _loc_2 = 100;
            }
            if (_loc_2 < 0)
            {
                _loc_2 = 0;
            }
            return _loc_2;
        }// end function

        public function finishCurJob() : void
        {
            if (this.vStatus == "recruit")
            {
            }
            else if (this.vStatus == "training")
            {
                if (this.vJob.Attribute == "Force")
                {
                    var _loc_1:* = this;
                    var _loc_2:* = this.vForce + 1;
                    _loc_1.vForce = _loc_2;
                }
                if (this.vJob.Attribute == "Speed")
                {
                    var _loc_1:* = this;
                    var _loc_2:* = this.vSpeed + 1;
                    _loc_1.vSpeed = _loc_2;
                }
                if (this.vJob.Attribute == "Vitality")
                {
                    var _loc_1:* = this;
                    var _loc_2:* = this.vVitality + 1;
                    _loc_1.vVitality = _loc_2;
                    this.vHitPointsMax = Sparks_Char.getHitPointsMax(this.vVitality);
                    this.vHitPointsRegen = Sparks_Char.getHitPointsRegen(this.vVitality);
                }
                var _loc_1:* = this;
                var _loc_2:* = this.vNbUpgrades + 1;
                _loc_1.vNbUpgrades = _loc_2;
            }
            else if (this.vStatus == "injury")
            {
            }
            this.vStatus = "active";
            return;
        }// end function

        public function addInjury(param1:Number, param2:int) : void
        {
            this.vStatus = "injury";
            this.vJob = new Object();
            this.vJob.Started = param1;
            this.vJob.Duration = param2;
            return;
        }// end function

        public function isJobFinished() : Boolean
        {
            if (Global.vServer.getTimeLeft(this.vJob.Started, this.vJob.Duration) <= 0)
            {
                return true;
            }
            return false;
        }// end function

        public static function getHitPointsMax(param1:int) : int
        {
            var _loc_2:* = GBL_Main.vHitPoints_Start;
            var _loc_3:* = 1;
            while (_loc_3 <= param1)
            {
                
                if (_loc_3 % 2 != 0)
                {
                    _loc_2++;
                }
                _loc_3++;
            }
            return _loc_2;
        }// end function

        public static function getHitPointsRegen(param1:int) : int
        {
            var _loc_2:* = GBL_Main.vHitPoints_Regen;
            var _loc_3:* = 1;
            while (_loc_3 <= param1)
            {
                
                if (_loc_3 % 2 == 0)
                {
                    _loc_2++;
                }
                _loc_3++;
            }
            return _loc_2;
        }// end function

    }
}
