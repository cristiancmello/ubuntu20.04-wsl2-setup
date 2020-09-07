# Ubuntu 20.04 LTS WSL2 Setup
Basic Setup for Ubuntu 20.04 LTS in WSL2.

Access to MS Store and search by **Ubuntu 20.04** app. After that, click on Ubuntu Icon and start installation. **Set up your username and password and close the window then terminated**.

## Setting up Memory Consumption

Download .wslconfig to Home's Windows folder (Rename to **.wslconfig**). Execute the instructions are into the file.

[.wslconfig](https://gist.githubusercontent.com/kikokoder/3a1f7a2447c1bc09f1059dca9fd86d80/raw/6840301502a76fafeacebee8c2fd1040f6d07140/.wslconfig)

## Creating Basic Scripts

In Windows Desktop, create:

1. **Shutdown.bat**

* [Shutdown.bat.example](https://gist.githubusercontent.com/kikokoder/e4b719ac28d1d231f631fdd31a44e49d/raw/88dc8358e8ffa1c66dd8a951a56966cbcb204b2b/Shutdown.bat.example)

2. **Workspace.bat**

* [Workspace.bat.example](https://gist.githubusercontent.com/kikokoder/d29c36f7ab927c0a360a016602fe019c/raw/da93c711c314c23011a76f3a20c1e05104612d5a/Workspace.bat.example)

- After download, edit and put `os_name=Ubuntu-20.04`
- Install Recommendations of vscode

3. **Environment template** (to edit or auto generate)

* [env.bat.example](https://gist.githubusercontent.com/kikokoder/56926f32078236bc4bed95fb6c197782/raw/a5a3465a314600c68c64c81dd911069535278a17/env.bat.example)

## Softwares:

- PyPI
- Miniconda3
- Conda packages: pandas, jupyterlab, jupyter notebook, voila, ipython
- PHP7
- PHP-CLI
- PHP7 Extensions: common, bz2, imap, intl, bcmath, json, mbstring, soap, sybase, xsl, zip (other as mysql already installed)
- Composer
- NVM
- NodeJS 12 LTS (npm, Yarn)
- Open Java JRE (default version, ~11)
- Open Java JDK (default version, ~11)
- SDKMAN
- Gradle 6.6
- .NET Core 3.1 Runtime (Full, ASP.NET app support added)
- .NET Core 3.1 SDK
