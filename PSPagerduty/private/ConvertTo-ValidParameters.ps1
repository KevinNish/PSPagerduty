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

    ##Normalize parameters
    $NormalizedParams = @{}

    foreach($Key in $Params.Keys){     
        #Ignore API Key as a param
        if($Key -eq 'APIKey'){
            continue
        }
        #Convert dates into ISO 8601
        if($($Params.$Key.GetTypeCode()) -eq 'DateTime'){
        
            $Value = Get-Date -Date $Params.$Key -Format "o"
            $NormalizedParams.$($Key.ToLower()) = $Value

        }else{
            
            $NormalizedParams.$($Key.ToLower()) = $Params.$Key 
        
        }   
    }
    
    
    if ($NormalizedParams.Count -ge 1){

        ##URL Apply URL encoding and additional formatting required by Pagerdutys API (ie [] beside any array)
        $Return = New-Object System.Collections.ArrayList

        foreach ($Key in $NormalizedParams.Keys){
            
            if($($NormalizedParams.$Key.GetType().BaseType.Name) -ne 'Array'){
                    
                # Signatures require upper-case hex digits.
                [string]$p = [System.Web.HttpUtility]::UrlEncode($key) + "=" + [System.Web.HttpUtility]::UrlEncode($NormalizedParams.$key)
                $p = [regex]::Replace($p,"(%[0-9A-Fa-f][0-9A-Fa-f])",{$args[0].Value.ToLowerInvariant()})
                $p = [regex]::Replace($p,"([!'()*])",{"%" + [System.Convert]::ToByte($args[0].Value[0]).ToString("X") })
                $p = $p.Replace("%7E","~")
                $p = $p.Replace("+", "%20")
                $_c = $Return.Add($p)
                      
            }else{
                
                foreach($item in $NormalizedParams.$key.GetEnumerator()){
                    
                    [string]$p = [System.Web.HttpUtility]::UrlEncode($key+"[]") + "=" + [System.Web.HttpUtility]::UrlEncode($item.ToLower())
                
                    # Signatures require upper-case hex digits.
                    $p = [regex]::Replace($p,"(%[0-9A-Fa-f][0-9A-Fa-f])",{$args[0].Value.ToLowerInvariant()})
                    $p = [regex]::Replace($p,"([!'()*])",{"%" + [System.Convert]::ToByte($args[0].Value[0]).ToString("X") })
                    $p = $p.Replace("%7E","~")
                    $p = $p.Replace("+", "%20")
                    $_c = $Return.Add($p)
                }       
            }      
        }

        $Return.Sort([System.StringComparer]::Ordinal)
        [string]$Params  = "?" + [string]::Join("&", ($Return.ToArray()))
        Write-Debug $Params

    }else{
        [string]$Params = ""
    }


    return $Params

}
