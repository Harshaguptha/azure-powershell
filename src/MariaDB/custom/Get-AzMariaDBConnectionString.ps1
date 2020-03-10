
# ----------------------------------------------------------------------------------
#
# Copyright Microsoft Corporation
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ----------------------------------------------------------------------------------
<#
.Synopsis
Gets information about a server.
.Description
Gets information about a server.
.Example
To view examples, please use the -Online parameter with Get-Help or navigate to: https://docs.microsoft.com/en-us/powershell/module/az.mariadb/get-azmariadbconnectionstring
.Inputs
Microsoft.Azure.PowerShell.Cmdlets.MariaDb.Models.IMariaDbIdentity
.Outputs
Microsoft.Azure.PowerShell.Cmdlets.MariaDb.Models.Api20180601Preview.IServer
.Notes
COMPLEX PARAMETER PROPERTIES
To create the parameters described below, construct a hash table containing the appropriate properties. For information on hash tables, run Get-Help about_Hash_Tables.

.Link
https://docs.microsoft.com/en-us/powershell/module/az.mariadb/get-azmariadbconnectionstring
#>
function Get-AzMariaDbConnectionString {
    [OutputType([System.String])]
    [CmdletBinding(DefaultParameterSetName='ServerName', PositionalBinding=$false)]
    [Microsoft.Azure.PowerShell.Cmdlets.MariaDb.Profile('latest-2019-04-30')]
    param(
        [Parameter(ParameterSetName='Get', Mandatory)]
        [Alias('ServerName')]
        [Microsoft.Azure.PowerShell.Cmdlets.MariaDb.Category('Path')]
        [System.String]
        # The name of the server.
        ${Name},
    
        [Parameter(ParameterSetName='ServerName', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.MariaDb.Category('Path')]
        [System.String]
        # The name of the resource group that contains the resource.
        # You can obtain this value from the Azure Resource Manager API or the portal.
        ${ResourceGroupName},
    
        [Parameter(ParameterSetName='ServerName')]
        [Microsoft.Azure.PowerShell.Cmdlets.MariaDb.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.MariaDb.Runtime.DefaultInfo(Script='(Get-AzContext).Subscription.Id')]
        [System.String[]]
        # The subscription ID that identifies an Azure subscription.
        ${SubscriptionId},
    
        [Parameter(ParameterSetName='ServerObject', ValueFromPipeline)]
        [Microsoft.Azure.PowerShell.Cmdlets.MariaDb.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.MariaDb.Models.IMariaDbIdentity]
        # Identity Parameter
        # To construct, see NOTES section for INPUTOBJECT properties and create a hash table.
        ${InputObject},

        [Parameter(Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.MariaDb.Category('Path')]
        [Validateset('ADO.NET', 'JDBC', 'Node.js', 'PHP', 'Python', 'Ruby', 'WebApp')]
        [string]
        ${Client},
    
        [Parameter()]
        [Alias('AzureRMContext', 'AzureCredential')]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.MariaDb.Category('Azure')]
        [System.Management.Automation.PSObject]
        # The credentials, account, tenant, and subscription used for communication with Azure.
        ${DefaultProfile},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.MariaDb.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Wait for .NET debugger to attach
        ${Break},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.MariaDb.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.MariaDb.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be appended to the front of the pipeline
        ${HttpPipelineAppend},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.MariaDb.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.MariaDb.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be prepended to the front of the pipeline
        ${HttpPipelinePrepend},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.MariaDb.Category('Runtime')]
        [System.Uri]
        # The URI for the proxy server to use
        ${Proxy},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.MariaDb.Category('Runtime')]
        [System.Management.Automation.PSCredential]
        # Credentials for a proxy server to use for the remote call
        ${ProxyCredential},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.MariaDb.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Use the default credentials for the proxy
        ${ProxyUseDefaultCredentials}
    )
    
    process {
        $null = $PSBoundParameters.Remove('Client')
        $MariaDB = Get-AzMariaDbServer @PSBoundParameters
        $DBHost = $MariaDB.FullyQualifiedDomainName
        $DBPort = 3306
        $AdminName = $MariaDB.AdministratorLogin
        $MariaDBName = $MariaDB.Name
        $SslConnectionString = GetConnectionStringSslPart -Client $Client -SslEnforcement $MariaDB.SslEnforcement
        $ConnectionStringMap = @{
            'ADO.NET' = "Server=${DBHost}; Port=${DBPort}; Database={your_database}; Uid=${AdminName}@${MariaDBName}; Pwd={your_password}; $SslConnectionString"
            'JDBC' = "String url =`"jdbc:mariadb://${DBHost}:${DBPort}/{your_database}$SslConnectionString`"; myDbConn = DriverManager.getConnection(url, `"${AdminName}@${MariaDBName}`", {your_password});"
            'Node.js' = "var conn = mysql.createConnection({host: `"${DBHost}`", user: `"${AdminName}@${MariaDBName}`", password: {your_password}, database: {your_database}, port: ${DBPort}$SslConnectionString});"
            'PHP' = "`$con=mysqli_init();$SslConnectionString mysqli_real_connect(`$con, `"${DBHost}`", `"${AdminName}@${MariaDBName}`", {your_password}, {your_database}, ${DBPort});"
            'Python' = "cnx = mysql.connector.connect(user=`"${AdminName}@${MariaDBName}`", password={your_password}, host=`"${DBHost}`", port=${DBPort}, database={your_database}$SslConnectionString)"
            'Ruby' = "client = Mysql2::Client.new(username: `"${AdminName}@${MariaDBName}`", password: {your_password}, database: {your_database}, host: `"${DBHost}`", port: ${DBPort}$SslConnectionString)"
            'WebApp' = "Database={your_database}; Data Source=${DBHost}; User Id=${AdminName}@${MariaDBName}; Password={your_password}"
        }
        return $ConnectionStringMap[$Client]
    }
}

function GetConnectionStringSslPart {
    param(
        [Parameter()]
        [string]
        ${Client},
        [Parameter()]
        [string]
        ${SslEnforcement}
    )
    $SslEnforcementTemplateMap = @{
        'ADO.NET' = 'SslMode=Preferred;'
        'JDBC' = '?useSSL=true'
        'Node.js' = ', ssl:{ca:fs.readFileSync({ca-cert filename})}'
        'PHP' = 'mysqli_ssl_set($con, NULL, NULL, {ca-cert filename}, NULL, NULL);'
        'Python' = ', ssl_ca={ca-cert filename}, ssl_verify_cert=true'
        'Ruby' = ', sslca:{ca-cert filename}, sslverify:false, sslcipher:"AES256-SHA"'
        'WebApp' = ''
    }
    if ($MariaDB.SslEnforcement -eq 'Enabled') {
        return $SslEnforcementTemplateMap[$Client]
    }
    return ''
}