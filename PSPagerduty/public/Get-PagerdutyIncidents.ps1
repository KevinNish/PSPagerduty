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

function Get-PagerdutyIncidents {
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

   param(
        # View only Triggerd incidents
        [Parameter(Mandatory=$false)]
        [switch]$Triggerd,

        # View only Acknowledged incidents
        [Parameter(Mandatory=$false)]
        [switch]$Acknowledged,
           
        # View only Resolved incidents
        [Parameter(Mandatory=$false)]
        [switch]$Resolved,

        # The Subdomain of your pager duty account
        [Parameter(Mandatory=$true)]
        [string]$PagerDutySubDomain,

        # API key for your PagerDuty account
        [Parameter(Mandatory=$true)]
        [string]$APIKey
    )
        
    $query = $null
   
   if($Resolved)
   {
       $query = '?status=resolved'
   }

   if($Acknowledged)
   {
       $query = '?status=acknowledged'
   }

   if($Triggerd)
   {
       $query = '?status=triggered'
   }

   $results = Invoke-RestMethod -Uri ('https://' + $PagerDutySubDomain + '.pagerduty.com/api/v1/incidents' + $query) -method Get -ContentType "application/json" -Headers @{"Authorization"=("Token token=" + $APIKey)}
   
   # Clean the OutPut
   $results.incidents | Select-Object incident_number,incident_key,status,trigger_summary_data

}

