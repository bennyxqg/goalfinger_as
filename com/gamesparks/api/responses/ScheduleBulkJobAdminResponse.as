package com.gamesparks.api.responses
{
    import com.gamesparks.*;

    public class ScheduleBulkJobAdminResponse extends GSResponse
    {

        public function ScheduleBulkJobAdminResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getEstimatedCount() : Number
        {
            if (data.estimatedCount != null)
            {
                return data.estimatedCount;
            }
            return NaN;
        }// end function

        public function getJobId() : String
        {
            if (data.jobId != null)
            {
                return data.jobId;
            }
            return null;
        }// end function

    }
}
