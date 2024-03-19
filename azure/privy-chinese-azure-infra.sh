#########################################################
#                                                       #                                    
#   用于创建 Azure VM 并执行初始化命令的 Powershell脚本      #
#                                                       #
#########################################################

# 如果是在 Cloud Shell 环境，不需要执行安装 Az 模块和登录 Azure 的命令

# 安装 Az 模块
if (-not (Get-Module -Name Az.Accounts -ListAvailable)) {
    Install-Module -Name Az.Accounts -AllowClobber -Scope CurrentUser -Force
}

# 设置环境变量
$Environment = "AzureChinaCloud" # 或者 "AzureCloud" 对于全球 Azure

# 登录 Azure
if ($Environment -eq "AzureChinaCloud") {
    Connect-AzAccount -Environment AzureChinaCloud
} else {
    Connect-AzAccount
}

# 设置变量
$ResourceGroupName = "myResourceGroup"
$Location = "chinanorth3"
$VNetName = "myVNet"
$SubnetName = "mySubnet"
$VNetAddressPrefix = "10.0.0.0/16"
$SubnetAddressPrefix = "10.0.0.0/24"
$PublicIpName = "myPublicIp"
$NsgName = "myNetworkSecurityGroup"
$RuleName = "AllowPort11434"
$Priority = 1001  # 设置优先级，数值越小优先级越高，范围是 100-4096
$Description = "Allow port 11434"
$VmName = "myVm"
$VmSize = "Standard_NC6s_v3"
$image = "UbuntuLTS"
$sshKeyName = "mySSHKey"

############################################################
# 创建资源组
New-AzResourceGroup -Name $ResourceGroupName -Location $Location

# 创建虚拟网络
$SubnetConfig = New-AzVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix $SubnetAddressPrefix
$VNet = New-AzVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroupName -Location $Location -AddressPrefix $VNetAddressPrefix -Subnet $SubnetConfig

# 创建公共 IP 地址
$PublicIp = New-AzPublicIpAddress -Name $PublicIpName -ResourceGroupName $ResourceGroupName -Location $Location -AllocationMethod Dynamic

# 创建网络安全组
$Nsg = New-AzNetworkSecurityGroup -ResourceGroupName $ResourceGroupName -Location $Location -Name $NsgName

# 创建新的安全规则
$AllowPortRule = New-AzNetworkSecurityRuleConfig -Name $RuleName -Description $Description -Access Allow -Protocol Tcp -Direction Inbound -Priority $Priority -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 11434

# 将新的安全规则添加到 NSG
$Nsg | Add-AzNetworkSecurityRuleConfig -Name $RuleName -Access Allow -Protocol Tcp -Direction Inbound -Priority $Priority -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 11434

# 更新 NSG
Set-AzNetworkSecurityGroup -NetworkSecurityGroup $Nsg

# 获取子网
$Subnet = Get-AzVirtualNetworkSubnetConfig -Name $SubnetName -VirtualNetwork $VNet

# 将 NSG 附加到子网
Set-AzVirtualNetworkSubnetConfig -VirtualNetwork $VNet -Name $SubnetName -AddressPrefix $SubnetAddressPrefix -NetworkSecurityGroup $Nsg

# 更新虚拟网络
Set-AzVirtualNetwork -VirtualNetwork $VNet

# 创建虚拟机
New-AzVm -ResourceGroupName $ResourceGroupName -Name $VmName -Location $Location -VirtualNetworkName $VNetName -SubnetName $SubnetName -SecurityGroupName $NsgName -PublicIpAddressName $PublicIpName -OpenPorts 11434 -Image $image -Size $VmSize -Credential (Get-Credential) -SshKeyName $sshKeyName

# 在刚刚创建的 VM 上执行初始化命令
$script = "curl -fsSL https://ollama.com/install.sh | sh"
Invoke-AzVMRunCommand -ResourceGroupName $ResourceGroupName -VMName $VmName -CommandId RunShellScript -Script $script
# 等待2分钟
Start-Sleep -s 120

# 修改 ollama 配置文件
$modifyConfScript = @"
sudo sed -i '/\[Service\]/a Environment="OLLAMA_HOST=0.0.0.0"\nEnvironment="OLLAMA_ORIGINS=*"' /etc/systemd/system/ollama.conf
"@

Invoke-AzVMRunCommand -ResourceGroupName $ResourceGroupName -VMName $VmName -CommandId RunShellScript -Script $modifyConfScript
# 重新启动ollama 服务
$restartOllamaScript = @"
sudo systemctl restart ollama
"@
Invoke-AzVMRunCommand -ResourceGroupName $ResourceGroupName -VMName $VmName -CommandId RunShellScript -Script $restartOllamaScript

# 下载deepseek-coder:6.7b模型
$downloadModelScript = @"
ollama pull deepseek-coder:6.7b
"@
Invoke-AzVMRunCommand -ResourceGroupName $ResourceGroupName -VMName $VmName -CommandId RunShellScript -Script $downloadModelScript
# 等待5分钟
Start-Sleep -s 300

# 下载deepseek-coder:6.7b-instruct模型
$downloadInstructModelScript = @"
ollama pull deepseek-coder:6.7b-instruct
"@
Invoke-AzVMRunCommand -ResourceGroupName $ResourceGroupName -VMName $VmName -CommandId RunShellScript -Script $downloadInstructModelScript
# 等待5分钟
Start-Sleep -s 300

# 重启ollama 服务
$restartOllamaScript = @"
sudo systemctl restart ollama
"@
Invoke-AzVMRunCommand -ResourceGroupName $ResourceGroupName -VMName $VmName -CommandId RunShellScript -Script $restartOllamaScript

# 验证服务正常
$publicIp = Get-AzPublicIpAddress -Name myPubIP -ResourceGroupName myResourceGroup | select "IpAddress"
curl -d '{"model": "deepseek-coder:6.7b","prompt": "write me a list sort function in python"}' -H "Content-Type: application/json" -X POST http://$publicIp:11434/api/generate

