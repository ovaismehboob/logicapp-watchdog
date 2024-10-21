workflow EnableDRLogicApp {
    InlineScript {
        # Log in using Managed Identity
        Connect-AzAccount -Identity

        # Retrieve the web app details
        $webApp = Get-AzWebApp -ResourceGroupName "la-secondaryrg" -Name "testlogicapptfx"
        
        # Get existing app settings
        $existingSettings = Get-AzWebApp -ResourceGroupName "la-secondaryrg" -Name "testlogicapptfx" | Select-Object -ExpandProperty SiteConfig | Select-Object -ExpandProperty AppSettings

        # Update the app setting to enable the workflow
        $newSettings = @{
            "Workflows.testworkflow.FlowState" = "Enabled"
        }

        # Merge existing settings with new settings, conditionally updating the value
        foreach ($setting in $existingSettings) {
            if ($setting.Name -eq "Workflows.testworkflow.FlowState") {
                $newSettings[$setting.Name] = "Enabled"
            } else {
                $newSettings[$setting.Name] = $setting.Value
            }
        }
    
        # Update the web app settings with merged settings
        Set-AzWebApp -ResourceGroupName "la-secondaryrg" -Name "testlogicapptfx" -AppServicePlan $webApp.ServerFarmId -AppSettings $newSettings

        Write-Output "Command executed successfully"
    }
}
