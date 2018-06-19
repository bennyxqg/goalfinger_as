package com.gamesparks.api.types
{
    import com.gamesparks.*;

    public class BulkJob extends GSData
    {

        public function BulkJob(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getActualCount() : Number
        {
            if (data.actualCount != null)
            {
                return data.actualCount;
            }
            return NaN;
        }// end function

        public function getCompleted() : Date
        {
            if (data.completed != null)
            {
                return RFC3339toDate(data.completed);
            }
            return null;
        }// end function

        public function getCreated() : Date
        {
            if (data.created != null)
            {
                return RFC3339toDate(data.created);
            }
            return null;
        }// end function

        public function getData() : Object
        {
            if (data.data != null)
            {
                return data.data;
            }
            return null;
        }// end function

        public function getDoneCount() : Number
        {
            if (data.doneCount != null)
            {
                return data.doneCount;
            }
            return NaN;
        }// end function

        public function getErrorCount() : Number
        {
            if (data.errorCount != null)
            {
                return data.errorCount;
            }
            return NaN;
        }// end function

        public function getEstimatedCount() : Number
        {
            if (data.estimatedCount != null)
            {
                return data.estimatedCount;
            }
            return NaN;
        }// end function

        public function getId() : String
        {
            if (data.id != null)
            {
                return data.id;
            }
            return null;
        }// end function

        public function getModuleShortCode() : String
        {
            if (data.moduleShortCode != null)
            {
                return data.moduleShortCode;
            }
            return null;
        }// end function

        public function getPlayerQuery() : Object
        {
            if (data.playerQuery != null)
            {
                return data.playerQuery;
            }
            return null;
        }// end function

        public function getScheduledTime() : Date
        {
            if (data.scheduledTime != null)
            {
                return RFC3339toDate(data.scheduledTime);
            }
            return null;
        }// end function

        public function getScript() : String
        {
            if (data.script != null)
            {
                return data.script;
            }
            return null;
        }// end function

        public function getStarted() : Date
        {
            if (data.started != null)
            {
                return RFC3339toDate(data.started);
            }
            return null;
        }// end function

        public function getState() : String
        {
            if (data.state != null)
            {
                return data.state;
            }
            return null;
        }// end function

    }
}
