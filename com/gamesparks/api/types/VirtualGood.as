package com.gamesparks.api.types
{
    import __AS3__.vec.*;
    import com.gamesparks.*;

    public class VirtualGood extends GSData
    {

        public function VirtualGood(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getWP8StoreProductId() : String
        {
            if (data.WP8StoreProductId != null)
            {
                return data.WP8StoreProductId;
            }
            return null;
        }// end function

        public function getAmazonStoreProductId() : String
        {
            if (data.amazonStoreProductId != null)
            {
                return data.amazonStoreProductId;
            }
            return null;
        }// end function

        public function getBaseCurrency1Cost() : Number
        {
            if (data.baseCurrency1Cost != null)
            {
                return data.baseCurrency1Cost;
            }
            return NaN;
        }// end function

        public function getBaseCurrency2Cost() : Number
        {
            if (data.baseCurrency2Cost != null)
            {
                return data.baseCurrency2Cost;
            }
            return NaN;
        }// end function

        public function getBaseCurrency3Cost() : Number
        {
            if (data.baseCurrency3Cost != null)
            {
                return data.baseCurrency3Cost;
            }
            return NaN;
        }// end function

        public function getBaseCurrency4Cost() : Number
        {
            if (data.baseCurrency4Cost != null)
            {
                return data.baseCurrency4Cost;
            }
            return NaN;
        }// end function

        public function getBaseCurrency5Cost() : Number
        {
            if (data.baseCurrency5Cost != null)
            {
                return data.baseCurrency5Cost;
            }
            return NaN;
        }// end function

        public function getBaseCurrency6Cost() : Number
        {
            if (data.baseCurrency6Cost != null)
            {
                return data.baseCurrency6Cost;
            }
            return NaN;
        }// end function

        public function getBundledGoods() : Vector.<BundledGood>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<BundledGood>;
            if (data.bundledGoods != null)
            {
                _loc_2 = data.bundledGoods;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(new BundledGood(_loc_2[_loc_3]));
                }
            }
            return _loc_1;
        }// end function

        public function getCurrency1Cost() : Number
        {
            if (data.currency1Cost != null)
            {
                return data.currency1Cost;
            }
            return NaN;
        }// end function

        public function getCurrency2Cost() : Number
        {
            if (data.currency2Cost != null)
            {
                return data.currency2Cost;
            }
            return NaN;
        }// end function

        public function getCurrency3Cost() : Number
        {
            if (data.currency3Cost != null)
            {
                return data.currency3Cost;
            }
            return NaN;
        }// end function

        public function getCurrency4Cost() : Number
        {
            if (data.currency4Cost != null)
            {
                return data.currency4Cost;
            }
            return NaN;
        }// end function

        public function getCurrency5Cost() : Number
        {
            if (data.currency5Cost != null)
            {
                return data.currency5Cost;
            }
            return NaN;
        }// end function

        public function getCurrency6Cost() : Number
        {
            if (data.currency6Cost != null)
            {
                return data.currency6Cost;
            }
            return NaN;
        }// end function

        public function getDescription() : String
        {
            if (data.description != null)
            {
                return data.description;
            }
            return null;
        }// end function

        public function getDisabled() : Boolean
        {
            if (data.disabled != null)
            {
                return data.disabled;
            }
            return false;
        }// end function

        public function getGooglePlayProductId() : String
        {
            if (data.googlePlayProductId != null)
            {
                return data.googlePlayProductId;
            }
            return null;
        }// end function

        public function getIosAppStoreProductId() : String
        {
            if (data.iosAppStoreProductId != null)
            {
                return data.iosAppStoreProductId;
            }
            return null;
        }// end function

        public function getMaxQuantity() : Number
        {
            if (data.maxQuantity != null)
            {
                return data.maxQuantity;
            }
            return NaN;
        }// end function

        public function getName() : String
        {
            if (data.name != null)
            {
                return data.name;
            }
            return null;
        }// end function

        public function getPropertySet() : Object
        {
            if (data.propertySet != null)
            {
                return data.propertySet;
            }
            return null;
        }// end function

        public function getPsnStoreProductId() : String
        {
            if (data.psnStoreProductId != null)
            {
                return data.psnStoreProductId;
            }
            return null;
        }// end function

        public function getSegmentedCurrency1Cost() : Number
        {
            if (data.segmentedCurrency1Cost != null)
            {
                return data.segmentedCurrency1Cost;
            }
            return NaN;
        }// end function

        public function getSegmentedCurrency2Cost() : Number
        {
            if (data.segmentedCurrency2Cost != null)
            {
                return data.segmentedCurrency2Cost;
            }
            return NaN;
        }// end function

        public function getSegmentedCurrency3Cost() : Number
        {
            if (data.segmentedCurrency3Cost != null)
            {
                return data.segmentedCurrency3Cost;
            }
            return NaN;
        }// end function

        public function getSegmentedCurrency4Cost() : Number
        {
            if (data.segmentedCurrency4Cost != null)
            {
                return data.segmentedCurrency4Cost;
            }
            return NaN;
        }// end function

        public function getSegmentedCurrency5Cost() : Number
        {
            if (data.segmentedCurrency5Cost != null)
            {
                return data.segmentedCurrency5Cost;
            }
            return NaN;
        }// end function

        public function getSegmentedCurrency6Cost() : Number
        {
            if (data.segmentedCurrency6Cost != null)
            {
                return data.segmentedCurrency6Cost;
            }
            return NaN;
        }// end function

        public function getShortCode() : String
        {
            if (data.shortCode != null)
            {
                return data.shortCode;
            }
            return null;
        }// end function

        public function getSteamStoreProductId() : String
        {
            if (data.steamStoreProductId != null)
            {
                return data.steamStoreProductId;
            }
            return null;
        }// end function

        public function getTags() : String
        {
            if (data.tags != null)
            {
                return data.tags;
            }
            return null;
        }// end function

        public function getType() : String
        {
            if (data.type != null)
            {
                return data.type;
            }
            return null;
        }// end function

        public function getW8StoreProductId() : String
        {
            if (data.w8StoreProductId != null)
            {
                return data.w8StoreProductId;
            }
            return null;
        }// end function

    }
}
