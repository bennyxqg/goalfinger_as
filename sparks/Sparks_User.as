package sparks
{
    import __AS3__.vec.*;
    import com.gamesparks.api.responses.*;
    import flash.display.*;
    import gbl.*;
    import gbl.perso.*;

    public class Sparks_User extends Object
    {
        public var vChars:Vector.<Sparks_Char>;
        public var vUserId:String;
        public var vCards:Object;
        public var vXP:int = 0;
        public var vLevel:int = 0;
        public var vHardCurrency:int = 0;
        public var vNextRegCardTime:Number = -1;
        public var vPromoPack:Object;
        public var vTrophy:int = 0;
        public var vTrophyMax:int = 0;
        public var vCurShirt:String;
        public var vCountry:String;
        public var vConsecutiveWins:int = 0;
        private var vShirts:Object;

        public function Sparks_User(param1:String)
        {
            this.vUserId = param1;
            this.vChars = new Vector.<Sparks_Char>;
            this.vCards = new Object();
            return;
        }// end function

        public function parseDetails(param1:AccountDetailsResponse, param2:Boolean = true) : void
        {
            var _loc_4:* = undefined;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_3:* = param1.getScriptData();
            this.vCountry = param1.getLocation().getCountry();
            this.vTrophy = _loc_3.trophies;
            if (_loc_3.stats.maxTrophies != null)
            {
                this.vTrophyMax = _loc_3.stats.maxTrophies;
            }
            this.vHardCurrency = param1.getCurrency1();
            this.vChars = new Vector.<Sparks_Char>;
            if (_loc_3.Characters != null)
            {
                for (_loc_4 in _loc_3.Characters)
                {
                    
                    _loc_5 = _loc_8[_loc_4];
                    _loc_6 = new Sparks_Char(this, _loc_4, _loc_5.Name);
                    _loc_6.setForce(_loc_5.Attributes.Force);
                    _loc_6.setSpeed(_loc_5.Attributes.Speed);
                    _loc_6.setVitality(_loc_5.Attributes.Vitality);
                    if (_loc_5.Energy == null)
                    {
                        _loc_6.vEnergy = 100;
                        _loc_6.vEnergyTS = 0;
                    }
                    else
                    {
                        _loc_6.vEnergy = _loc_5.Energy.Level;
                        _loc_6.vEnergyTS = Math.round(_loc_5.Energy.TS / 1000);
                    }
                    _loc_6.vPosition = _loc_5.Position;
                    _loc_6.vNbUpgrades = _loc_5.NbUpgrades;
                    _loc_6.vCategory = _loc_5.Categ;
                    _loc_6.vStatus = _loc_5.Status;
                    if (_loc_5.Job != null)
                    {
                        _loc_6.vJob = _loc_5.Job;
                    }
                    this.vChars.push(_loc_6);
                }
            }
            if (param2)
            {
                if (_loc_3.XP != null)
                {
                    this.vXP = _loc_3.XP.points;
                    this.vLevel = _loc_3.XP.level;
                    if (Global.vTopBar != null)
                    {
                        Global.vTopBar.forceNewXP(this.vLevel, this.vXP);
                    }
                }
            }
            if (_loc_3.NextRegCardTime != null)
            {
                this.vNextRegCardTime = Math.round(_loc_3.NextRegCardTime / 1000);
            }
            if (_loc_3.promoPack != null)
            {
                this.vPromoPack = _loc_3.promoPack;
                if (this.vPromoPack.endTime < Global.vServer.getTimeNow())
                {
                    this.vPromoPack = null;
                }
            }
            else
            {
                this.vPromoPack = null;
            }
            this.parseShirts(_loc_3.Shirts);
            this.vCurShirt = _loc_3.ActiveShirt;
            _loc_5 = param1.getVirtualGoods();
            this.vCards = new Object();
            for (_loc_4 in _loc_5)
            {
                
                this.addCards(_loc_4, _loc_5[_loc_4]);
            }
            this.vConsecutiveWins = _loc_3.consecutiveWins;
            return;
        }// end function

        public function hasChar(param1:String) : Boolean
        {
            var _loc_2:* = 0;
            while (_loc_2 < this.vChars.length)
            {
                
                if (this.vChars[_loc_2].vCharId == param1)
                {
                    return true;
                }
                _loc_2++;
            }
            return false;
        }// end function

        public function getChar(param1:String) : Sparks_Char
        {
            var _loc_2:* = 0;
            while (_loc_2 < this.vChars.length)
            {
                
                if (this.vChars[_loc_2].vCharId == param1)
                {
                    return this.vChars[_loc_2];
                }
                _loc_2++;
            }
            return null;
        }// end function

        public function removeChar(param1:String) : void
        {
            var _loc_2:* = 0;
            while (_loc_2 < this.vChars.length)
            {
                
                if (this.vChars[_loc_2].vCharId == param1)
                {
                    this.vChars.splice(_loc_2, 1);
                    return;
                }
                _loc_2++;
            }
            return;
        }// end function

        public function getPersoGraf(param1:int, param2:Boolean = false) : Sprite
        {
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_3:* = new Sprite();
            var _loc_4:* = 0;
            while (_loc_4 < this.vChars.length)
            {
                
                if (this.vChars[_loc_4].vPosition == param1)
                {
                    _loc_5 = new GBL_Glob(1, this.vChars[_loc_4].getForce(), this.vChars[_loc_4].getSpeed(), this.vChars[_loc_4].getVitality());
                    _loc_5.vName = this.vChars[_loc_4].vName;
                    _loc_5.vPosition = param1;
                    _loc_5.vCharCode = this.vChars[_loc_4].vCharId;
                    _loc_5.vShirtCode = this.vCurShirt;
                    _loc_6 = new GBL_Perso_Puppet();
                    _loc_6.init(_loc_5);
                    _loc_6.setOrientation(180, 0);
                    if (param2)
                    {
                        _loc_6.setInMenu();
                    }
                    _loc_3.addChild(_loc_6);
                }
                _loc_4++;
            }
            var _loc_7:* = 1.3;
            _loc_3.scaleY = 1.3;
            _loc_3.scaleX = _loc_7;
            return _loc_3;
        }// end function

        public function isTeamReady() : Boolean
        {
            var _loc_1:* = null;
            var _loc_2:* = 1;
            while (_loc_2 <= 3)
            {
                
                _loc_1 = this.getCharAtPosition(_loc_2);
                if (_loc_1 == null)
                {
                    return false;
                }
                if (!_loc_1.isActive())
                {
                    return false;
                }
                if (!_loc_1.canPlay())
                {
                    return false;
                }
                _loc_2++;
            }
            return true;
        }// end function

        public function isTeamComplete() : Boolean
        {
            var _loc_1:* = null;
            var _loc_2:* = 1;
            while (_loc_2 <= 3)
            {
                
                _loc_1 = this.getCharAtPosition(_loc_2);
                if (_loc_1 == null)
                {
                    return false;
                }
                _loc_2++;
            }
            return true;
        }// end function

        public function getCharAtPosition(param1:int) : Sparks_Char
        {
            var _loc_2:* = 0;
            while (_loc_2 < this.vChars.length)
            {
                
                if (this.vChars[_loc_2].vPosition == param1)
                {
                    return this.vChars[_loc_2];
                }
                _loc_2++;
            }
            return null;
        }// end function

        public function getCharByCode(param1:String) : Sparks_Char
        {
            var _loc_2:* = 0;
            while (_loc_2 < this.vChars.length)
            {
                
                if (this.vChars[_loc_2].vCharId == param1)
                {
                    return this.vChars[_loc_2];
                }
                _loc_2++;
            }
            return null;
        }// end function

        public function getTeamDesc() : String
        {
            var _loc_2:* = null;
            var _loc_3:* = false;
            var _loc_5:* = 0;
            var _loc_1:* = new Object();
            _loc_1.shirt = this.vCurShirt;
            _loc_1.boosters = this.getBoostersPlayable();
            var _loc_4:* = 1;
            while (_loc_4 <= 3)
            {
                
                _loc_3 = false;
                _loc_5 = 0;
                while (_loc_5 < this.vChars.length)
                {
                    
                    if (this.vChars[_loc_5].vPosition == _loc_4)
                    {
                        _loc_3 = true;
                        _loc_2 = new Object();
                        _loc_2.code = this.vChars[_loc_5].vCharId;
                        _loc_2.name = this.vChars[_loc_5].vName;
                        _loc_2.force = this.vChars[_loc_5].getForce();
                        _loc_2.speed = this.vChars[_loc_5].getSpeed();
                        _loc_2.vitality = this.vChars[_loc_5].getVitality();
                        _loc_2.category = this.vChars[_loc_5].vCategory;
                        _loc_2.infos = {};
                        _loc_2.infos.ArrowSum = 0;
                        _loc_2.infos.KO = 0;
                        _loc_2.infos.Kill = 0;
                        _loc_1["player" + _loc_4] = _loc_2;
                    }
                    _loc_5++;
                }
                if (_loc_3 == false)
                {
                    Global.addLogTrace("Not enough player in team", "Sparks_User");
                    Global.vRoot.restartApp("Not enough player in team");
                    return "";
                }
                _loc_4++;
            }
            return JSON.stringify(_loc_1);
        }// end function

        public function getCards(param1:String) : int
        {
            if (Global.vDev)
            {
            }
            if (this.vCards == null)
            {
                return 0;
            }
            if (this.vCards[param1] == null)
            {
                return 0;
            }
            return parseInt(this.vCards[param1]);
        }// end function

        public function setCards(param1:String, param2:int) : void
        {
            if (this.vCards == null)
            {
                return;
            }
            this.vCards[param1] = param2;
            return;
        }// end function

        public function addCards(param1:String, param2:int) : void
        {
            var _loc_3:* = 0;
            if (this.vCards == null)
            {
                return;
            }
            if (param1.substr(0, 4) == "Gold")
            {
                return;
            }
            if (param1.substr(0, 1) == "G")
            {
                _loc_3 = parseInt(param1.substr(1));
                Global.vTopBar.onGoldAdded(_loc_3 * param2);
                return;
            }
            if (this.vCards[param1] == null)
            {
                if (param2 > 0)
                {
                    this.vCards[param1] = param2;
                }
            }
            else
            {
                this.vCards[param1] = this.vCards[param1] + param2;
                if (this.vCards[param1] < 0)
                {
                    delete this.vCards[param1];
                }
            }
            return;
        }// end function

        public function getEnergyCards() : Array
        {
            var _loc_2:* = undefined;
            var _loc_1:* = new Array();
            for (_loc_2 in this.vCards)
            {
                
                if (_loc_2.substr(0, 1) == "E")
                {
                    if (parseInt(_loc_4[_loc_2]) > 0)
                    {
                        _loc_1.push({card:_loc_2, nb:_loc_4[_loc_2], value:_loc_2.substr(1)});
                    }
                }
            }
            _loc_1 = _loc_1.sort(this.sortEnergyCard);
            return _loc_1;
        }// end function

        private function sortEnergyCard(param1:Object, param2:Object) : int
        {
            if (param1.value > param2.value)
            {
                return -1;
            }
            if (param1.value < param2.value)
            {
                return 1;
            }
            return 0;
        }// end function

        private function parseShirts(param1:Object) : void
        {
            this.vShirts = param1;
            return;
        }// end function

        public function hasShirt(param1:String) : Boolean
        {
            if (this.vShirts[param1] != null)
            {
                return true;
            }
            return false;
        }// end function

        public function getMyShirts() : Array
        {
            var _loc_2:* = undefined;
            var _loc_1:* = new Array();
            for (_loc_2 in this.vShirts)
            {
                
                _loc_1.push(_loc_2);
            }
            return _loc_1;
        }// end function

        public function getBoostersPlayable() : Array
        {
            var _loc_1:* = new Array();
            if (this.getCards("BA") > 0)
            {
                _loc_1.push("BA");
            }
            while (_loc_1.length > 3)
            {
                
                var _loc_2:* = _loc_1;
                var _loc_3:* = _loc_1.length - 1;
                _loc_2.length = _loc_3;
            }
            return _loc_1;
        }// end function

    }
}
