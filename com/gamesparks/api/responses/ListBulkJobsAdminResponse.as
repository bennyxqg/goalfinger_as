package com.gamesparks.api.responses
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.types.*;

    public class ListBulkJobsAdminResponse extends GSResponse
    {

        public function ListBulkJobsAdminResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getBulkJobs() : Vector.<BulkJob>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<BulkJob>;
            if (data.bulkJobs != null)
            {
                _loc_2 = data.bulkJobs;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(new BulkJob(_loc_2[_loc_3]));
                }
            }
            return _loc_1;
        }// end function

    }
}
