using System;
using System.Collections.Generic;

namespace FundAppsScripts.Scripts
{
    public class TaskProfileResponse
    {
        public string Id { get; set; }

        public Type Type { get; set; }

        public Status Status { get; set; }

        public DateTime DateCreated { get; set; }

        public DateTime? DateUpdated { get; set; }

        public string TrackingEndpoint { get; set; }

        public List<string> Errors { get; set; }

        public StatusReport StatusReport { get; set; }

        //If the response contains a lot of errors/warnings the StatusReportWithMessage will be populated with Message and LinkToFile from where you can get the errors/warnings

        public StatusReportWithMessage StatusReportWithMessage { get; set; }
    }

    public class Type
    {
        public int Id { get; set; }

        public string Name { get; set; }
    }

    public class Status
    {
        public int Id { get; set; }

        public string Name { get; set; }

        public string Description { get; set; }
    }

    public class StatusReport
    {
        public List<string> Errors { get; set; }

        public List<string> Warnings { get; set; }
    }

    public class StatusReportWithMessage
    {
        public string Message { get; set; }

        public string LinkToFile { get; set; }
    }
}
