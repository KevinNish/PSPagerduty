function ConvertTo-ValidParameters{

    [cmdletbinding()]
    param(

        [Parameter(
            Position=0,
            Mandatory=$true,
            ValueFromPipeline=$true
            )]
        [hashtable]$Params
    )

    $BuildQuery = @{}

    foreach($Key in $Params.Keys){
        
        if($Key -eq 'APIKey'){
            continue
        }
        #Convert dates into ISO 8601
        if($($Params.$Key.GetTypeCode()) -eq 'DateTime'){
        
            $Value = Get-Date -Date $Params.$Key -Format "o"
            $BuildQuery.$($Key.ToLower()) = $Value

        }else{
            
            $BuildQuery.$($Key.ToLower()) = $Params.$Key 
        
        }   
    }

    return $BuildQuery

}