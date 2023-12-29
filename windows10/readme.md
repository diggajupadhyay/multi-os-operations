
# PowerShell Script: System Configuration and App Management

## Overview
This PowerShell script is designed to automate the uninstallation of specific Windows apps, perform system configuration actions, and install basic applications.

## Usage
1. **Uninstall Windows Apps:** Run the script to uninstall unwanted Windows apps. You will be prompted to choose whether to uninstall each app individually.

2. **System Configuration:** Configure various system settings, such as disabling telemetry, Bing search, and more. Follow the prompts to make choices for each configuration action.

3. **Install Required Apps:** Install a set of essential apps using Winget. The script will prompt you for each app, allowing you to choose whether to install it.

4. **Install Additional Apps:** Install extra applications that are not available in the Winget repository. The script will prompt you for each additional app.

## How to Run
1. Download and save `script.ps1` file to your Downloads folder.
2. Open a PowerShell command prompt as an administrator from Downloads folder.
3. Navigate to the directory where the script is saved.
4. Run the script using the following command: `powershell .\script.ps1`
5. **Read Carefully and follow the Instruction!**

> Note: Ensure that your execution policy allows running scripts. You
> can set the execution policy using the following command (run
> PowerShell as Administrator):

`Set-ExecutionPolicy RemoteSigned`

## Disclaimer

Use this script at your own risk. Review the script content to ensure it aligns with your system configuration needs. Always exercise caution when running scripts obtained from external sources.

## Author

[Diggaj Upadhyay](https://github.com/diggajupadhyay/)
