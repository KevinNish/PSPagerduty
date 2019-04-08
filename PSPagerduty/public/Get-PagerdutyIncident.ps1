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
   [cmdletbinding()]
   [alias('Get-Incident')]

   param(
        # View only Triggerd incidents
        [Parameter(Mandatory=$false)]
        [switch]$Triggered,

        # View only Acknowledged incidents
        [Parameter(Mandatory=$false)]
        [switch]$Acknowledged,
           
        # View only Resolved incidents
        [Parameter(Mandatory=$false)]
        [switch]$Resolved,

        # API key for your PagerDuty account
        [Parameter(Mandatory=$true)]
        [string]$APIKey,
        
        # Timezone, default is UTC, will work in most cases
        [Parameter(Mandatory=$false)]
        [string]$time_zone = 'UTC'

    )
        
    $query = $null
   
   if($Resolved)
   {
       $query = '?statuses%5B%5D=resolved'
   }

   if($Acknowledged)
   {
       $query = '?statuses%5B%5D=acknowledged'
   }

   if($Triggerd)
   {
       $query = '?statuses%5B%5D=triggered'
   }

   $Headers = @{
   
        'Accept' = 'application/vnd.pagerduty+json;version=2'
        'Authorization' = "Token token=$APIKey"
   
   }  

   $results = Invoke-RestMethod -Uri ('https://' + 'api.pagerduty.com/incidents' +$query + "&time_zone=$time_zone") -method GET -ContentType 'application/json' -Headers $Headers
   
   $results.incidents | Select-Object incident_number,incident_key,status,trigger_summary_data

}

