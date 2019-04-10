<#
Author: Kevin Nishimura
Site: kevinnish.com
Module: PSPagerduty
Cmdlet: Get-PagerdutyIncidents
Created by: Kevin Nishimura (kevinnishimura91@gmail.com)

Licensed under GPLv3:
Copyright: Kevin Nishimura
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#>

function Get-PagerdutyIncident {
    <#
   .SYNOPSIS
       Gets events from Pagerduty API
    .DESCRIPTION
        Allows you to interact with the Pagerduty incidents API to get all types of incidents (Triggerd, Acknowledged, and Resolved)
   .EXAMPLE
       BASE MODULE TEMPLATE
   .EXAMPLE
       BASE MODULE TEMPLATE
   
   #>
   
   [cmdletbinding(DefaultParameterSetName='Default')]
   [alias('Get-Incidents')]

   param(

    
    [Parameter(Mandatory=$true)]
    [string]$APIKey,

    # View only Triggerd incidents
    [Parameter(Mandatory=$false,ParameterSetName='Default')]
    [Parameter(ParameterSetName='DateRange')]
    [Parameter(ParameterSetName='AllDates')]
    [switch]$Triggered,
    [Parameter(Mandatory=$false,ParameterSetName='Default')]
    [Parameter(ParameterSetName='DateRange')]
    [Parameter(ParameterSetName='AllDates')]
    [switch]$Acknowledged,
    [Parameter(Mandatory=$false,ParameterSetName='Default')]
    [Parameter(ParameterSetName='DateRange')]
    [Parameter(ParameterSetName='AllDates')]
    [switch]$Resolved,
    [Parameter(Mandatory=$false,ParameterSetName='Default')]
    [Parameter(ParameterSetName='DateRange')]
    [Parameter(ParameterSetName='AllDates')]
    [switch]$HighPriority,
    [Parameter(Mandatory=$false,ParameterSetName='Default')]
    [Parameter(ParameterSetName='DateRange')]
    [Parameter(ParameterSetName='AllDates')]
    [switch]$LowPriority,
    

    [Parameter(Mandatory=$false,ParameterSetName='DateRange')]
    [string]$Since,
    [Parameter(Mandatory=$false,ParameterSetName='DateRange')]
    [string]$Until,

    [Parameter(Mandatory=$false,ParameterSetName='AllDates')]
    [ValidateSet('all')]
    [string]$DateRange,

    #Search for specific incident
    [Parameter(Mandatory=$false,ParameterSetName='IncidentKey')]
    [ValidateLength(1,255)]
    [string]$IncidentKey,

    [string]$Timezone,
    [array]$ServiceIDs,
    [array]$UserIDs,
    [array]$TeamIDs,
    [ValidateSet('users',
            'services',
            'first_trigger_log_entries',
            'escalation_policies',
            'teams',
            'assignees',
            'acknowledgers',
            'priorities',
            'response_bridge')]
    [array]$IncludeAdditionDetails

)
        
        
    []
    $Path = '/incidents?'
    $BuildQuery = @{}
   #Build status query
   if($Resolved){
       $StatusQuery = 'statuses%5B%5D=resolved'
   }

   if($Acknowledged){
       $StatusQuery = 'statuses%5B%5D=acknowledged'
   }

   if($Triggered){
       $StatusQuery = 'statuses%5B%5D=triggered'
   }

   #Build time zone query
   if($time_zone){
        $timezonequery = "&time_zone=$time_zone"
   }else{
        $timezonequery = "&time_zone=UTC"
   }
   $Headers = @{
   
        'Accept' = 'application/vnd.pagerduty+json;version=2'
        'Authorization' = "Token token=$APIKey"
   
   }  

   $results = Invoke-RestMethod -Uri ('https://' + 'api.pagerduty.com' +$StatusQuery + ) -method GET -ContentType 'application/json' -Headers $Headers
   
   $results.incidents | Select-Object incident_number,incident_key,status,trigger_summary_data

}

